module Model.ValidationErrors exposing (ValidationErrors, empty, errors, hasErrors, make)

import Model.ValidationError exposing (ValidationError)


type ValidationErrors
    = ValidationErrors (List ValidationError)


empty : ValidationErrors
empty =
    ValidationErrors []


make : List ValidationError -> ValidationErrors
make list =
    ValidationErrors list


hasErrors : ValidationErrors -> Bool
hasErrors errors =
    case errors of
        ValidationErrors errs ->
            not <| List.isEmpty errs


errors : ValidationErrors -> List ValidationError
errors errs =
    case errs of
        ValidationErrors e ->
            e
