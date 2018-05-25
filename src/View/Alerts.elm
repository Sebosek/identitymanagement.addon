module View.Alerts exposing (alerts)

import Html exposing (Html, div, text)
import Html.Attributes as Attributes exposing (class)
import Http exposing (Error(..))
import Json.Decode exposing (decodeString)
import Model.Error as Model exposing (Error, errorDecoder)
import Model.Token exposing (Token)
import RemoteData exposing (RemoteData(..), WebData)


alerts : WebData Token -> Html msg
alerts response =
    case response of
        Failure error ->
            div [ class "alerts" ]
                [ div [ class "alert alert--danger" ] [ reasonOfError error ]
                ]

        _ ->
            text ""


reasonOfError : Http.Error -> Html msg
reasonOfError error =
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
                            text <| toString value

                        _ ->
                            text detail.description

                _ ->
                    text "Unable parse response body."

        _ ->
            text <| toString error
