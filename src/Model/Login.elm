module Model.Login exposing (Login, blur, cleanValue, init, input, isValid, setValue, toBody, validate, valueOf)

import Http exposing (Body, encodeUri, stringBody)
import List exposing (map)
import Model.FormField exposing (FormField(..))
import Model.Input as Input exposing (Input, blur, setValue, validate)
import Model.ValidationError exposing (ValidationError, create)
import Model.ValidationErrors exposing (empty)
import Regex exposing (Regex, contains, regex)
import String exposing (join)
import Validate exposing (Validator, firstError, ifBlank, ifFalse)


type alias Login =
    { url : Input
    , email : Input
    , password : Input
    }


init : Login
init =
    Login
        (Input Url "" empty False)
        (Input Email "" empty False)
        (Input Password "" empty False)


toBody : Login -> Body
toBody login =
    let
        content =
            join "&" <|
                map mapKeyValue
                    [ ( "grant_type", "login" )
                    , ( "username", login.email.value )
                    , ( "password", login.password.value )
                    , ( "scope", encodeUri "sh_access offline_access" )
                    ]
    in
    stringBody "application/x-www-form-urlencoded" content


valueOf : Login -> FormField -> String
valueOf login field =
    case field of
        Url ->
            login.url.value

        Email ->
            login.email.value

        Password ->
            login.password.value


setValue : Login -> FormField -> String -> Login
setValue login field value =
    case field of
        Url ->
            { login | url = Input.setValue login.url value } |> validateField Url

        Email ->
            { login | email = Input.setValue login.email value } |> validateField Email

        Password ->
            { login | password = Input.setValue login.password value } |> validateField Password


cleanValue : Login -> FormField -> Login
cleanValue login field =
    case field of
        Url ->
            { login | url = Input.clean login.url }

        Email ->
            { login | email = Input.clean login.email }

        Password ->
            { login | password = Input.clean login.password }


blur : FormField -> Login -> Login
blur field login =
    case field of
        Url ->
            { login | url = Input.blur login.url } |> validateField Url

        Email ->
            { login | email = Input.blur login.email } |> validateField Email

        Password ->
            { login | password = Input.blur login.password } |> validateField Password


isValidUrl : String -> Bool
isValidUrl value =
    contains validUrl value


urlValidator : Validator ValidationError Input
urlValidator =
    firstError
        [ ifBlank .value <| create "Field is mandatory"
        , ifFalse (\n -> isValidUrl <| .value n) <| create "URL is not in valid format"
        ]


requiredValidator : Validator ValidationError Input
requiredValidator =
    ifBlank .value <| create "Field is mandatory"


validateField : FormField -> Login -> Login
validateField field login =
    case field of
        Url ->
            { login | url = Input.validate login.url urlValidator }

        Email ->
            { login | email = Input.validate login.email requiredValidator }

        Password ->
            { login | password = Input.validate login.password requiredValidator }


validate : Login -> Login
validate login =
    { login
        | url = Input.validate login.url urlValidator
        , email = Input.validate login.email requiredValidator
        , password = Input.validate login.password requiredValidator
    }


isValid : Login -> Bool
isValid login =
    Input.isValid login.url
        && Input.isValid login.email
        && Input.isValid login.password


input : Login -> FormField -> Input
input login field =
    case field of
        Url ->
            login.url

        Email ->
            login.email

        Password ->
            login.password


mapKeyValue : ( String, String ) -> String
mapKeyValue ( key, value ) =
    key ++ "=" ++ value


validUrl : Regex
validUrl =
    regex "^(?:(?:https?|ftp):\\/\\/)(?:(?:[1-9]\\d?|1\\d\\d|2[01]\\d|22[0-3])(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))|(?:(?:[a-z\\u00a1-\\uffff0-9]-*)*[a-z\\u00a1-\\uffff0-9]+)(?:\\.(?:[a-z\\u00a1-\\uffff0-9]-*)*[a-z\\u00a1-\\uffff0-9]+)*(?:\\.(?:[a-z\\u00a1-\\uffff]{2,}))\\.?)(?::\\d{2,5})?(?:[/?#]\\S*)?$"
