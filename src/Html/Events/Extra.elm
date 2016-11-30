module Html.Events.Extra
    exposing
        ( charCode
        , targetValueFloat
        , targetValueInt
        , targetValueMaybe
        , targetValueMaybeFloat
        , targetValueMaybeInt
        , targetValueFloatParse
        , targetValueIntParse
        , targetValueMaybeFloatParse
        , targetValueMaybeIntParse
        , targetSelectedIndex
        , onClickPreventDefault
        , onClickStopPropagation
        , onClickPreventDefaultAndStopPropagation
        , onEnter
        )

{-| Additional decoders for use with event handlers in html.

# Event decoders
* TODO: `key`
* TODO: `code`
* TODO: `KeyEvent`, `keyEvent`
@docs charCode

# Typed event decoders
@docs targetValueFloat, targetValueInt, targetValueMaybe, targetValueMaybeFloat, targetValueMaybeInt
@docs targetValueFloatParse, targetValueIntParse, targetValueMaybeFloatParse, targetValueMaybeIntParse
@docs targetSelectedIndex


# Event Handlers
@docs onClickPreventDefault, onClickStopPropagation, onClickPreventDefaultAndStopPropagation, onEnter
-}

import Html exposing (Attribute)
import Html.Events exposing (..)
import Json.Decode as Json


-- TODO
-- {-| Decode the key that was pressed.
-- The key attribute is intended for users who are interested in the meaning of the key being pressed, taking into account the current keyboard layout.
--
-- * If there exists an appropriate character in the [key values set](http://www.w3.org/TR/DOM-Level-3-Events-key/#key-value-tables), this will be the result. See also [MDN key values](https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent.key#Key_values).
-- * If the value is has a printed representation, it will be a non-empty Unicode character string consisting of the char value.
-- * If more than one key is being pressed and the key combination includes modifier keys (e.g. `Control + a`), then the key value will still consist of the printable char value with no modifier keys except for 'Shift' and 'AltGr' applied.
-- * Otherwise the value will be `"Unidentified"`
--
-- Note that `keyCode`, `charCode` and `which` are all being deprecated. You should avoid using these in favour of `key` and `code`.
-- Google Chrome and Safari currently support this as `keyIdentifier` which is defined in the old draft of DOM Level 3 Events.
--
-- -}
-- key : Json.Decoder String
-- key = Json.oneOf [ Json.field "key" string, Json.field "keyIdentifier" string ]
-- TODO: Waiting for proper support in chrome & safari
-- {-| Return a string identifying the key that was pressed.
-- `keyCode`, `charCode` and `which` are all being deprecated. You should avoid using these in favour of `key` and `code`.
-- See [KeyboardEvent.keyCode](https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent.keyCode).
-- -}
-- code : Json.Decoder String
-- code =
--     Json.field "code" string
-- TODO: Complete keyboard event
-- keyEvent : Json.Decoder KeyEvent
-- keyEvent =
--     Json.oneOf [ Json.field "keyCode" int ]


{-| Character code for key board events.
This is being deprecated, but support for DOM3 Keyboard events is not yet present in most browsers.
-}
charCode : Json.Decoder (Maybe Char)
charCode =
    Json.map (Maybe.map Tuple.first << String.uncons) (Json.field "charCode" Json.string)



-- implementation taken from: https://groups.google.com/d/msg/elm-dev/Ctl_kSKJuYc/rjkdBxx6AwAJ


customDecoder : Json.Decoder a -> (a -> Result String b) -> Json.Decoder b
customDecoder d f =
    let
        resultDecoder x =
            case x of
                Ok a ->
                    Json.succeed a

                Err e ->
                    Json.fail e
    in
        Json.map f d |> Json.andThen resultDecoder


{-| Floating-point target value.
-}
targetValueFloat : Json.Decoder Float
targetValueFloat =
    customDecoder (Json.at [ "target", "valueAsNumber" ] Json.float) <|
        \v ->
            if isNaN v then
                Err "Not a number"
            else
                Ok v


{-| Integer target value.
-}
targetValueInt : Json.Decoder Int
targetValueInt =
    Json.at [ "target", "valueAsNumber" ] Json.int


{-| String or empty target value.
-}
targetValueMaybe : Json.Decoder (Maybe String)
targetValueMaybe =
    customDecoder targetValue
        (\s ->
            Ok <|
                if s == "" then
                    Nothing
                else
                    Just s
        )


{-| Floating-point or empty target value.
-}
targetValueMaybeFloat : Json.Decoder (Maybe Float)
targetValueMaybeFloat =
    targetValueMaybe
        |> Json.andThen
            (\mval ->
                case mval of
                    Nothing ->
                        Json.succeed Nothing

                    Just _ ->
                        Json.map Just targetValueFloat
            )


{-| Integer or empty target value.
-}
targetValueMaybeInt : Json.Decoder (Maybe Int)
targetValueMaybeInt =
    let
        traverse f mx =
            case mx of
                Nothing ->
                    Ok Nothing

                Just x ->
                    Result.map Just (f x)
    in
        customDecoder targetValueMaybe (traverse String.toInt)


{-| Parse a floating-point value from the input instead of using `valueAsNumber`.
Use this with inputs that do not have a `number` type.
-}
targetValueFloatParse : Json.Decoder Float
targetValueFloatParse =
    customDecoder targetValue String.toFloat


{-| Parse an integer value from the input instead of using `valueAsNumber`.
Use this with inputs that do not have a `number` type.
-}
targetValueIntParse : Json.Decoder Int
targetValueIntParse =
    customDecoder targetValue String.toInt


{-| Parse an optional floating-point value from the input instead of using `valueAsNumber`.
Use this with inputs that do not have a `number` type.
-}
targetValueMaybeFloatParse : Json.Decoder (Maybe Float)
targetValueMaybeFloatParse =
    let
        traverse f mx =
            case mx of
                Nothing ->
                    Ok Nothing

                Just x ->
                    Result.map Just (f x)
    in
        customDecoder targetValueMaybe (traverse String.toFloat)


{-| Parse an optional integer value from the input instead of using `valueAsNumber`.
Use this with inputs that do not have a `number` type.
-}
targetValueMaybeIntParse : Json.Decoder (Maybe Int)
targetValueMaybeIntParse =
    let
        traverse f mx =
            case mx of
                Nothing ->
                    Ok Nothing

                Just x ->
                    Result.map Just (f x)
    in
        customDecoder targetValueMaybe (traverse String.toInt)


{-| Parse the index of the selected option of a select.
Returns Nothing in place of the spec's magic value -1.
-}
targetSelectedIndex : Json.Decoder (Maybe Int)
targetSelectedIndex =
    Json.at [ "target", "selectedIndex" ]
        (Json.map
            (\int ->
                if int == -1 then
                    Nothing
                else
                    Just int
            )
            Json.int
        )



-- Event Handlers


{-| Always send `msg` upon click, preventing the browser's default behavior.
-}
onClickPreventDefault : msg -> Attribute msg
onClickPreventDefault msg =
    onWithOptions "click"
        { defaultOptions | preventDefault = True }
        (Json.succeed msg)


{-| Always send `msg` upon click, preventing click propagation.
-}
onClickStopPropagation : msg -> Attribute msg
onClickStopPropagation msg =
    onWithOptions "click"
        { defaultOptions | stopPropagation = True }
        (Json.succeed msg)


{-| Always send `msg` upon click, preventing the browser's default behavior and propagation
-}
onClickPreventDefaultAndStopPropagation : msg -> Attribute msg
onClickPreventDefaultAndStopPropagation msg =
    onWithOptions "click"
        { defaultOptions
            | stopPropagation = True
            , preventDefault = True
        }
        (Json.succeed msg)


{-| When the enter key is released, send the `msg`.
    Otherwise, do nothing.
-}
onEnter : msg -> Attribute msg
onEnter onEnterAction =
    on "keyup" <|
        Json.andThen
            (\keyCode ->
                if keyCode == 13 then
                    Json.succeed onEnterAction
                else
                    Json.fail (toString keyCode)
            )
            keyCode
