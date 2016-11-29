module Html.Attributes.Extra exposing (..)

{-| Additional attributes for html

# Embedding static attributes
@docs static

# Inputs
@docs valueAsFloat, valueAsInt

# Semantic web
@docs role

# Meter element
@docs low, high, optimum

# Media element
@docs volume

# Unescaped HTML
@docs innerHtml

# Custom Attributes
@docs stringProperty
@docs boolProperty
@docs floatProperty
@docs intProperty

-}

import Html exposing (Attribute)
import Html.Attributes exposing (attribute, property)
import Json.Encode as Json


{-| Embedding static attributes.

Works alike to [`Html.Extra.static`](Html-Extra#static).
-}
static : Attribute Never -> Attribute msg
static =
    Html.Attributes.map never


{-| Create arbitrary string *properties*.
-}
stringProperty : String -> String -> Attribute msg
stringProperty name string =
    property name (Json.string string)


{-| Create arbitrary bool *properties*.
-}
boolProperty : String -> Bool -> Attribute msg
boolProperty name bool =
    property name (Json.bool bool)


{-| Create arbitrary floating-point *properties*.
-}
floatProperty : String -> Float -> Attribute msg
floatProperty name float =
    property name (Json.float float)


{-| Create arbitrary integer *properties*.
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


{-| Useful for inserting arbitrary unescaped HTML into an element. This function comes with some caveats.

* **Security:** You should never pass untrusted strings (e.g. from user input) to this function. Doing so will lead to [XSS](https://www.owasp.org/index.php/Cross-site_Scripting_(XSS)) vulnerabilities.
* **Performance:** The virtual DOM subsystem is not aware of HTML inserted in this manner, so these HTML fragments will be slower.
-}
innerHtml : String -> Attribute msg
innerHtml =
    stringProperty "innerHTML"
