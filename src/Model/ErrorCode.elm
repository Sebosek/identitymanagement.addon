module Model.ErrorCode exposing (ErrorCode(..), errorCode, fromString)

import Json.Decode exposing (Decoder, andThen, string)
import Json.Decode.Extra exposing (fromResult)
import Result exposing (Result(..))


type ErrorCode
    = Requests
    | Captcha


fromString : String -> Result String ErrorCode
fromString value =
    case value of
        "requests" ->
            Ok Requests

        "captcha" ->
            Ok Captcha

        _ ->
            Err "Unknown value"


{-| Decode a string value to ErrorCode
see: <https://www.brianthicks.com/post/2017/01/13/create-custom-json-decoders-in-elm-018/>
-}
errorCode : Decoder ErrorCode
errorCode =
    string |> andThen (fromString >> fromResult)
