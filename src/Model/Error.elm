module Model.Error exposing (Error, errorDecoder)

import Json.Decode exposing (Decoder, int, nullable, string)
import Json.Decode.Pipeline exposing (decode, optional, required)
import Model.ErrorCode exposing (ErrorCode, errorCode)


type alias Error =
    { error : String
    , description : String
    , code : Maybe ErrorCode
    }


errorDecoder : Decoder Error
errorDecoder =
    decode Error
        |> required "error" string
        |> required "error_description" string
        |> optional "code" (nullable errorCode) Nothing
