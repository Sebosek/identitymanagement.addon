port module Ports exposing (copied, copy)


port copy : String -> Cmd msg


port copied : (String -> msg) -> Sub msg
