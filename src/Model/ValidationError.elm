module Model.ValidationError exposing (ValidationError, create, message)


type ValidationError
    = ValidationError String


create : String -> ValidationError
create message =
    ValidationError message


message : ValidationError -> String
message error =
    case error of
        ValidationError e ->
            e
