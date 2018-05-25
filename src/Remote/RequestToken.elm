module Remote.RequestToken exposing (errorDescription, postToken)

import Http exposing (Body, Error(..), encodeUri, expectJson, header, request, stringBody)
import Json.Decode exposing (decodeString)
import Model.Error as Model exposing (Error, errorDecoder)
import Model.Login exposing (Login, toBody)
import Model.Msg exposing (Msg(OnPostToken))
import Model.Token exposing (tokenDecoder)
import RemoteData exposing (WebData, sendRequest)


postToken : Login -> Cmd Msg
postToken login =
    let
        postTokenUrl =
            login.url.value ++ "/services/identitymanagement/identity/connect/token"
    in
    Http.request
        { body = toBody login
        , expect = expectJson tokenDecoder
        , headers =
            [ header "Authorization" "Basic c2hjbGllbnRfbG9uZzpCSUN3b3JrZXIxNQ=="
            , header "Accept" "application/json"
            ]
        , method = "POST"
        , timeout = Nothing
        , url = postTokenUrl
        , withCredentials = False
        }
        |> sendRequest
        |> Cmd.map OnPostToken


errorDescription : Http.Error -> String
errorDescription error =
    let
        decodeError : String -> Result String Model.Error
        decodeError raw =
            decodeString errorDecoder raw
    in
    case error of
        BadStatus response ->
            case decodeError response.body of
                Ok detail ->
                    case detail.code of
                        Just value ->
                            toString value

                        _ ->
                            detail.description

                _ ->
                    "Unable parse response body."

        _ ->
            toString error
