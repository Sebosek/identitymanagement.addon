# How to deal with 2 different JSON structure in body response

1) Define response union type

type TokenResponse
    = ValidTokenResponse Token
    | ErrorTokenResponse Error


2) Define Decoders for all of them

tokenDecoder : Decode.Decoder Token
tokenDecoder =
    decode Token
        |> required "access_token" Decode.string
        |> required "expires_in" Decode.int
        |> required "token_type" Decode.string
        |> required "refresh_token" Decode.string


errorDecoder : Decode.Decoder Error
errorDecoder =
    decode Error
        |> required "error" Decode.string
        |> required "error_description" Decode.string
        |> optional "code" (Decode.nullable errorCode) Nothing


3) Define final Decoder

tokenResponseDecoder : Decode.Decoder TokenResponse
tokenResponseDecoder =
    Decode.oneOf
        [ Decode.map (\response -> ValidTokenResponse response) tokenDecoder
        , Decode.map (\response -> ErrorTokenResponse response) errorDecoder
        ]


4) Done!