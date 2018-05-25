module View.Token exposing (token)

import Html exposing (Html, a, button, div, fieldset, form, input, label, section, span, text, textarea)
import Html.Attributes as Attributes exposing (attribute, class, rows, src, type_, value)
import Html.Events as Events exposing (onBlur, onClick, onFocus, onInput, onMouseEnter)
import Model exposing (Model)
import Model.Copy as Copy exposing (toString)
import Model.Msg exposing (Msg(..))
import Remote.RequestToken exposing (errorDescription)
import RemoteData exposing (RemoteData(..), WebData)
import View.SvgIcon exposing (icon)


token : Model -> Html Msg
token model =
    div [ class "column-14" ]
        [ view model ]



-- view : Model -> Html Msg
-- view model =
--     case model.token of
--         Nothing ->
--             div [ class "alert alert--info" ] [ text "No token yet" ]
--         Just value ->
--             div [ class "input input--success" ]
--                 [ div [ class "input__envelope" ]
--                     [ textarea [ class "input__control", rows 19 ] [ text value ]
--                     , div [ class "input__icon input__icon--top" ]
--                         [ span
--                             [ class "tooltip-wrapper tooltip tooltip--left"
--                             , attribute "data-tooltip" <| Copy.toString <| .copied model
--                             , onClick CopyToken
--                             , onMouseEnter EnterCopyToken
--                             ]
--                             [ button [ class "button button--green button--circle" ]
--                                 [ span [] [ icon "files" ]
--                                 ]
--                             ]
--                         ]
--                     ]
--                 ]


view : Model -> Html Msg
view model =
    let
        response =
            .response model
    in
    case response of
        RemoteData.Success token ->
            div [ class "input input--success" ]
                [ div [ class "input__envelope" ]
                    [ textarea [ class "input__control", rows 19 ] [ text token.value ]
                    , div [ class "input__icon input__icon--top" ]
                        [ span
                            [ class "tooltip-wrapper tooltip tooltip--left"
                            , attribute "data-tooltip" <| Copy.toString <| .copied model
                            , onClick CopyToken
                            , onMouseEnter EnterCopyToken
                            ]
                            [ button [ class "button button--green button--circle" ]
                                [ span [] [ icon "files" ]
                                ]
                            ]
                        ]
                    ]
                ]

        RemoteData.Failure error ->
            div [ class "alert alert--danger" ] [ text <| errorDescription error ]

        RemoteData.Loading ->
            div [ class "alert alert--info" ] [ text "Loading..." ]

        RemoteData.NotAsked ->
            div [ class "alert alert--info" ] [ text "No token yet" ]
