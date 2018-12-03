# Changelog

* Remove the `innerHtml` Html Attribute since Elm 0.19 no longer supports using
  it. You should use ports instead - see https://github.com/elm/html/issues/172
* Add `viewIf` & `viewIfLazy` function to conditonally render HTML.
* Add the `nothing` value to represent an empty HTML node.
* Upgrade library to Elm v0.19

## v2.2.0

* Add onClick event handlers with default action and/or propogation prevented.
* Add onEnter event handler.
