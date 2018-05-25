module View.SvgIcon exposing (icon)

import Html exposing (Html)
import Svg exposing (node, svg)
import Svg.Attributes as SvgAttrs exposing (xlinkHref)


icon : String -> Html msg
icon name =
    let
        iconName =
            "#" ++ name
    in
    svg [ SvgAttrs.class "icon" ]
        [ node "use"
            [ xlinkHref iconName ]
            []
        ]
