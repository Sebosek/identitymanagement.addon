module Model.Copy exposing (Copy(..), fromString, toString)


type Copy
    = Copied
    | Failed
    | NoAction


fromString : String -> Copy
fromString value =
    case value of
        "Copied" ->
            Copied

        "Failed" ->
            Failed

        _ ->
            NoAction


toString : Copy -> String
toString copy =
    case copy of
        Copied ->
            "Copied!"

        Failed ->
            "Unable copy to clipboard"

        _ ->
            "Copy to clipboard"
