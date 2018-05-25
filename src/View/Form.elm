module View.Form exposing (form)

import Html exposing (Html, button, div, fieldset, form, input, label, section, span, text, textarea)
import Html.Attributes exposing (attribute, class, rows, src, type_, value)
import Html.Events as Events exposing (onBlur, onClick, onFocus, onInput, onMouseEnter)
import List exposing (map)
import Model.FormField exposing (FormField(..), title)
import Model.Input as Input exposing (Input, errors, isValid)
import Model.Login as Login exposing (Login, valueOf)
import Model.Msg exposing (Msg(..))
import Model.ValidationError exposing (ValidationError, message)
import Model.ValidationErrors as ValidationErrors exposing (ValidationErrors, errors, hasErrors)
import View.SvgIcon exposing (icon)


form : Login -> Html Msg
form model =
    div [ class "column-10" ]
        [ section [ class "layout" ]
            [ Html.form [ class "layout__body" ]
                [ fieldset []
                    [ textInput model Url
                    , textInput model Email
                    , textInput model Password
                    ]
                , div
                    [ class "text text--right" ]
                    [ button [ class "button button--primary", type_ "button", onClick PostToken ]
                        [ span [] [ text "Get a token" ] ]
                    ]
                ]
            ]
        ]


textInput : Login -> FormField -> Html Msg
textInput model field =
    label [ class <| inputClasses <| Login.input model field ]
        [ div
            [ class "input__label" ]
            [ text <| title field ]
        , div [ class "input__envelope" ]
            [ input
                [ class "input__control"
                , onInput <| SetFormField field
                , value <| valueOf model field
                , onBlur <| Blur field
                ]
                []
            , div
                [ class "input__icon tooltip"
                , attribute "data-tooltip" "Clean value"
                , onClick <| CleanFormField field
                ]
                [ icon "close" ]
            ]
        , inputErrors <| Input.errors <| Login.input model field
        ]


inputClasses : Input -> String
inputClasses input =
    case Input.isValid input of
        True ->
            "input"

        False ->
            "input input--error"


inputError : ValidationError -> Html msg
inputError error =
    div [ class "input__message input__message--error" ]
        [ span [ class "input__icon" ]
            [ icon "alert"
            ]
        , text <| message error
        ]


inputErrors : ValidationErrors -> Html msg
inputErrors validated =
    case hasErrors validated of
        True ->
            div [ class "input__messages" ] <| map (\item -> inputError item) <| ValidationErrors.errors validated

        _ ->
            text ""
