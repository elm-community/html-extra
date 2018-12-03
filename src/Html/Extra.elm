module Html.Extra exposing (static, nothing, viewIf, viewIfLazy)

{-| Convenience functionality on
[`Html`](http://package.elm-lang.org/packages/elm-lang/html/latest/Html#Html)

@docs static, nothing, viewIf, viewIfLazy

-}

import Html exposing (Html)


{-| Embedding static html.

The type argument
[`Never`](http://package.elm-lang.org/packages/elm-lang/core/latest/Basics#Never)
in `Html Never` tells us that the html has no event handlers attached,
it will not generate any messages. We may want to embed such static
html into arbitrary views, while using types to enforce the
staticness. That is what this function provides.

_Note:_ To call this function, the argument need not be literally of type
`Html Never`. It suffices if it is a fully polymorphic (in the message type)
`Html` value. For example, this works: `static (Html.text "abcdef")`.

-}
static : Html Never -> Html msg
static =
    Html.map never


{-| Render nothing.

A more idiomatic way of rendering nothing compared to using
`Html.text ""` directly.

-}
nothing : Html msg
nothing =
    Html.text ""


{-| A function to only render html under a certain condition

    fieldView : Model -> Html Msg
    fieldView model =
        div
            []
            [ fieldInput model
            , viewIf
                (not <| List.isEmpty model.errors)
                errorsView
            ]

-}
viewIf : Bool -> Html msg -> Html msg
viewIf condition html =
    if condition then
        html

    else
        nothing


{-| Just like `viewIf` except its more performant. In viewIf, the html is always evaluated, even if its not rendered. `viewIfLazy` only evaluates your view function if it needs to. The trade off is your view function needs to accept a unit type (`()`) as its final parameter

    fieldView : Model -> Html Msg
    fieldView model =
        div
            []
            [ fieldInput model
            , viewIf
                (not <| List.isEmpty model.errors)
                errorsView
            ]

-}
viewIfLazy : Bool -> (() -> Html msg) -> Html msg
viewIfLazy condition htmlF =
    if condition then
        htmlF ()

    else
        nothing
