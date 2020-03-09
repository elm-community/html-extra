module Html.Attributes.Extra exposing
    ( static
    , empty
    , valueAsFloat, valueAsInt, autocomplete
    , role
    , low, high, optimum
    , volume
    , stringProperty
    , boolProperty
    , floatProperty
    , intProperty
    )

{-| Additional attributes for html


# Embedding static attributes

@docs static


# No-op attribute

@docs empty


# Inputs

@docs valueAsFloat, valueAsInt, autocomplete


# Semantic web

@docs role


# Meter element

@docs low, high, optimum


# Media element

@docs volume


# Custom Attributes

@docs stringProperty
@docs boolProperty
@docs floatProperty
@docs intProperty

-}

import Html exposing (Attribute)
import Html.Attributes exposing (attribute, property)
import Html.Attributes.Autocomplete as Autocomplete
import Json.Encode as Json


{-| Embedding static attributes.

Works alike to [`Html.Extra.static`](Html-Extra#static).

-}
static : Attribute Never -> Attribute msg
static =
    Html.Attributes.map never


{-| A no-op attribute.

Allows for patterns like:

    Html.div
        [ someAttr
        , if someCondition then
            empty

          else
            someAttr2
        ]
        [ someHtml ]

instead of

    Html.div
        (someAttr
            :: (if someCondition then
                    []

                else
                    [ someAttr2 ]
               )
        )
        [ someHtml ]

This is useful eg. for conditional event handlers.

---

The only effect it can have on the resulting DOM is adding a `class` attribute,
or adding an extra trailing space in the `class` attribute if added after
`Html.Attribute.class` or `Html.Attribute.classList`:

    -- side effect 1:
    -- <div class="" />
    Html.div [ empty ] []

    -- side effect 2:
    -- <div class="x " />
    Html.div [ class "x", empty ] []

    -- no side effect:
    -- <div class="x" />
    Html.div [ empty, class "x" ] []

    -- side effect 2:
    -- <div class="x " />
    Html.div [ classList [ ( "x", True ) ], empty ] []

    -- no side effect:
    -- <div class="x" />
    Html.div [ empty, classList [ ( "x", True ) ] ] []

-}
empty : Attribute msg
empty =
    Html.Attributes.classList []


{-| Create arbitrary string _properties_.
-}
stringProperty : String -> String -> Attribute msg
stringProperty name string =
    property name (Json.string string)


{-| Create arbitrary bool _properties_.
-}
boolProperty : String -> Bool -> Attribute msg
boolProperty name bool =
    property name (Json.bool bool)


{-| Create arbitrary floating-point _properties_.
-}
floatProperty : String -> Float -> Attribute msg
floatProperty name float =
    property name (Json.float float)


{-| Create arbitrary integer _properties_.
-}
intProperty : String -> Int -> Attribute msg
intProperty name int =
    property name (Json.int int)


{-| Uses `valueAsNumber` to update an input with a floating-point value.
This should only be used on &lt;input&gt; of type `number`, `range`, or `date`.
It differs from `value` in that a floating point value will not necessarily overwrite the contents on an input element.

    valueAsFloat 2.5 -- e.g. will not change the displayed value for input showing "2.5000"

    valueAsFloat 0.4 -- e.g. will not change the displayed value for input showing ".4"

-}
valueAsFloat : Float -> Attribute msg
valueAsFloat value =
    floatProperty "valueAsNumber" value


{-| Uses `valueAsNumber` to update an input with an integer value.
This should only be used on &lt;input&gt; of type `number`, `range`, or `date`.
It differs from `value` in that an integer value will not necessarily overwrite the contents on an input element.

    valueAsInt 18 -- e.g. will not change the displayed value for input showing "00018"

-}
valueAsInt : Int -> Attribute msg
valueAsInt value =
    intProperty "valueAsNumber" value


{-| Render one of the possible `Completion` types into an `Attribute`.
-}
autocomplete : Autocomplete.Completion -> Attribute msg
autocomplete =
    Autocomplete.completionValue >> attribute "autocomplete"


{-| Used to annotate markup languages with machine-extractable semantic information about the purpose of an element.
See the [official specs](http://www.w3.org/TR/role-attribute/).
-}
role : String -> Attribute msg
role r =
    attribute "role" r


{-| The upper numeric bound of the low end of the measured range, used with the meter element.
-}
low : String -> Attribute msg
low =
    stringProperty "low"


{-| The lower numeric bound of the high end of the measured range, used with the meter element.
-}
high : String -> Attribute msg
high =
    stringProperty "high"


{-| This attribute indicates the optimal numeric value, used with the meter element.
-}
optimum : String -> Attribute msg
optimum =
    stringProperty "optimum"


{-| Audio volume, starting from 0.0 (silent) up to 1.0 (loudest).
-}
volume : Float -> Attribute msg
volume =
    floatProperty "volume"
