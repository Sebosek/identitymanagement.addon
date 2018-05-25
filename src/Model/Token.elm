module Model.Token exposing (Token, maybeString, tokenDecoder)

import Json.Decode exposing (Decoder, int, string)
import Json.Decode.Pipeline exposing (decode, optional, required)


type alias Token =
    { value : String
    , expiresIn : Int
    , tokenType : String
    , refreshToken : String
    }


tokenDecoder : Decoder Token
tokenDecoder =
    decode Token
        |> required "access_token" string
        |> required "expires_in" int
        |> required "token_type" string
        |> required "refresh_token" string


maybeString : Maybe Token -> Maybe String
maybeString token =
    case token of
        Just a ->
            Just a.value

        Nothing ->
            Nothing
