module Model.FormField exposing (FormField(..), title)


type FormField
    = Url
    | Email
    | Password


title : FormField -> String
title field =
    case field of
        Url ->
            "URL"

        Email ->
            "Login email"

        Password ->
            "Password"
