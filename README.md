# Additional HTML-related Functions

[![html-extra Build Status](https://travis-ci.org/elm-community/html-extra.svg?branch=master)](https://travis-ci.org/elm-community/html-extra)

This package contains convenience functions for working with Html, beyond that
which `elm-lang/html` provides.

You may want to import this into the `Html` namespace:

```elm
import Html.Extra as Html
```

Then you can do things like writing `Html.nothing` instead of `text ""`.

There are many event handlers & decoders in `Html.Events.Extra`, such as
`targetValueInt` or `onClickPreventDefault`.


Feedback and contributions are very welcome.

## License

MIT
