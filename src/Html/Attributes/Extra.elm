module Html.Attributes.Extra where
{-| Additional attributes for html

# Inputs
@docs valueAsFloat, valueAsInt

# Semantic web
@docs role

# Custom Attributes
@docs floatProperty
@docs intProperty

-}

import Html (Attribute)
import Html.Attributes (attribute, property)
import Json.Encode as Json

{-| Create arbitrary floating-point *properties*.
-}
floatProperty : String -> Float -> Attribute
floatProperty name float =
  property name (Json.float float)

{-| Create arbitrary integer *properties*.
-}
intProperty : String -> Int -> Attribute
intProperty name int =
  property name (Json.int int)

{-| Uses `valueAsNumber` to update an input with a floating-point value.
This should only be used on &lt;input&gt; of type `number`, `range`, or `date`.
It differs from `value` in that a floating point value will not necessarily overwrite the contents on an input element.

    valueAsFloat 2.5 -- e.g. will not change the displayed value for input showing "2.5000"
    valueAsFloat 0.4 -- e.g. will not change the displayed value for input showing ".4"

-}
valueAsFloat : Float -> Attribute
valueAsFloat value =
   floatProperty "valueAsNumber" value

{-| Uses `valueAsNumber` to update an input with an integer value.
This should only be used on &lt;input&gt; of type `number`, `range`, or `date`.
It differs from `value` in that an integer value will not necessarily overwrite the contents on an input element.

    valueAsInt 18 -- e.g. will not change the displayed value for input showing "00018"

-}
valueAsInt : Int -> Attribute
valueAsInt value =
  intProperty "valueAsNumber" value

{-| Used to annotate markup languages with machine-extractable semantic information about the purpose of an element.
See the [official specs](http://www.w3.org/TR/role-attribute/).
-}
role : String -> Attribute
role r =
  attribute "role" r
