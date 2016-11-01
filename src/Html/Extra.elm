module Html.Extra
    exposing
        ( static
        )

{-| Convenience functionality on
[`Html`](http://package.elm-lang.org/packages/elm-lang/html/latest/Html#Html)

@docs static
-}

import Html exposing (Html)


{-| Embedding static html.

The type argument
[`Never`](http://package.elm-lang.org/packages/elm-lang/core/latest/Basics#Never)
in `Html Never` tells us that the html has no event handlers attached,
it will not generate any messages. We may want to embed such static
html into arbitrary views, while using types to enforce the
staticness. That is what this function provides.

*Note:* To call this function, the argument need not be literally of type
`Html Never`. It suffices if it is a fully polymorphic (in the message type)
`Html` value. For example, this works: `static (Html.text "abcdef")`.
-}
static : Html Never -> Html msg
static =
    Html.map never
