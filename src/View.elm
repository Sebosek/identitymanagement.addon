module View exposing (view)

import Html exposing (Html, div, section, text)
import Html.Attributes exposing (class)
import Model exposing (Model)
import Model.Msg exposing (Msg(..))
import View.Form exposing (form)
import View.Token exposing (token)


view : Model -> Html Msg
view model =
    section [ class "content" ]
        [ div [ class "grid" ]
            [ form model.login
            , token model
            ]
        ]
