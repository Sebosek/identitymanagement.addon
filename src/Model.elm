module Model exposing (Model, init)

import Model.Copy exposing (Copy(..))
import Model.Login as Login exposing (Login, init)
import Model.Msg exposing (Msg(..))
import Model.Token exposing (Token)
import RemoteData exposing (RemoteData(..), WebData)


type alias Model =
    { login : Login
    , response : WebData Token
    , copied : Copy
    , token : Maybe String
    , captcha : Maybe String
    }


init : ( Model, Cmd Msg )
init =
    Model Login.init NotAsked NoAction Nothing Nothing ! []
