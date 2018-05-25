module Model.Input exposing (Input, blur, clean, errors, isValid, setValue, validate)

import Model.FormField exposing (FormField)
import Model.ValidationError exposing (ValidationError)
import Model.ValidationErrors exposing (ValidationErrors, empty, hasErrors, make)
import Validate exposing (Validator)


type alias Input =
    { field : FormField
    , value : String
    , errors : ValidationErrors
    , left : Bool
    }


setValue : Input -> String -> Input
setValue input value =
    { input | value = value }


blur : Input -> Input
blur input =
    { input | left = True }


clean : Input -> Input
clean input =
    { input | value = "" }


validate : Input -> Validator ValidationError Input -> Input
validate input validator =
    case Validate.validate validator input of
        [] ->
            { input | errors = empty }

        errors ->
            { input | errors = make errors }


isValid : Input -> Bool
isValid input =
    if not <| .left input then
        True
    else
        not <| hasErrors input.errors


errors : Input -> ValidationErrors
errors input =
    if not <| .left input then
        empty
    else
        .errors input
