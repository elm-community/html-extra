# Changelog

## v3.1.1

* Properly expose the `Html.Events.Extra.charCode` decoder.

## v3.1.0

* Add an `onChange` event attribute.

## v3.0.0

* Remove the `innerHtml` Html Attribute since Elm 0.19 no longer supports using
  it. You should use ports instead - see https://github.com/elm/html/issues/172
* Add `viewIf` & `viewIfLazy` function to conditionally render HTML.
* Add the `nothing` value to represent an empty HTML node.
* Upgrade library to Elm v0.19

## v2.2.0

* Add onClick event handlers with default action and/or propagation prevented.
* Add onEnter event handler.
