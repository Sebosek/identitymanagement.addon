module Model.Msg exposing (Msg(..))

import Model.FormField exposing (FormField)
import Model.Token exposing (Token)
import RemoteData exposing (WebData)


type Msg
    = NoOp
    | PostToken
    | OnPostToken (WebData Token)
    | CopyToken
    | TokenCopied String
    | EnterCopyToken
    | CleanFormField FormField
    | SetFormField FormField String
    | Blur FormField
