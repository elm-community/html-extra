module Html.Extra
    exposing
        ( embedStatic
        )

{-| Convenience functionality on
[`Html`](http://package.elm-lang.org/packages/elm-lang/html/latest/Html#Html)

@docs embedStatic
-}

import Basics.Extra
import Html exposing (Html)
import Html.App


{-| Embedding static html.

The type argument
[`Never`](http://package.elm-lang.org/packages/elm-lang/core/latest/Basics#Never)
in `Html Never` tells us that the html has no event handlers attached,
it will not generate any messages. We may want to embed such static
html into arbitrary views, while using types to enforce the
staticness. That is what this function provides.
-}
embedStatic : Html Never -> Html msg
embedStatic =
    Html.App.map Basics.Extra.never
