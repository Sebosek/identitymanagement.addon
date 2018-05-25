module Main exposing (..)

import Html exposing (Html, div, text)
import Maybe exposing (andThen)
import Model exposing (Model, init)
import Model.Copy as Copy exposing (Copy(..), fromString)
import Model.FormField exposing (FormField(..))
import Model.Login as Login exposing (Login, blur, cleanValue, isValid, setValue, validate)
import Model.Msg exposing (Msg(..))
import Model.Token as Token exposing (maybeString)
import Ports exposing (copied, copy)
import Remote.RequestToken exposing (postToken)
import RemoteData exposing (RemoteData(..), toMaybe)
import View exposing (view)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetFormField field value ->
            { model | login = setValue model.login field value } ! []

        CleanFormField field ->
            { model | login = cleanValue model.login field } ! []

        Blur field ->
            { model | login = blur field model.login } ! []

        PostToken ->
            let
                login : Login
                login =
                    model.login
                        |> blur Url
                        |> blur Email
                        |> blur Password

                next : Model
                next =
                    { model | login = validate login }
            in
            if isValid next.login then
                { next | response = Loading } ! [ postToken model.login ]
            else
                next ! []

        OnPostToken response ->
            let
                oneOf : Maybe a -> Maybe a -> Maybe a
                oneOf a b =
                    case a of
                        Nothing ->
                            b

                        Just value ->
                            a
            in
            { model
                | response = response
                , token = oneOf (maybeString <| toMaybe response) model.token
            }
                ! []

        CopyToken ->
            case model.token of
                Nothing ->
                    { model | copied = Failed } ! []

                Just value ->
                    { model | copied = NoAction } ! [ copy <| value ]

        TokenCopied value ->
            { model | copied = Copy.fromString value } ! []

        EnterCopyToken ->
            { model | copied = NoAction } ! []

        _ ->
            model ! []


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = \subs -> Sub.batch [ copied TokenCopied ]
        }
