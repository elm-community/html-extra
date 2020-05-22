module Rules.NoTextEmptyString exposing (suite)

-- import Expect exposing (Expectation)

import Html.Rules.NoTextEmptyString as NoTextEmptyString
import Review.Test
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "NoTextEmptyString"
        [ test "should not report anything if there is no `text \"\"` - not even imported " <|
            \() ->
                """
module A exposing (..)

foo : String
foo = "bar"
    """
                    |> Review.Test.run NoTextEmptyString.rule
                    |> Review.Test.expectNoErrors
        , test "should not report anything if `text \"\"` is not form Html" <|
            \() ->
                """
module A exposing (..)

import Html

text: String -> String
text = identity


foo : Html.Html msg
foo = Html.text <| text ""
    """
                    |> Review.Test.run NoTextEmptyString.rule
                    |> Review.Test.expectNoErrors
        , test "it should detect `Html.text \"\"`" <|
            \() ->
                """
module A exposing (..)

import Html 

foo : Html.Html msg
foo = Html.text ""
            """
                    |> Review.Test.run NoTextEmptyString.rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = NoTextEmptyString.error.message
                            , details = NoTextEmptyString.error.details
                            , under = "Html.text \"\""
                            }
                        ]
        , test "it should detect `text \"\"`" <|
            \() ->
                """
module A exposing (..)

import Html exposing (text)

foo : Html.Html msg
foo = text ""
          """
                    |> Review.Test.run NoTextEmptyString.rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = NoTextEmptyString.error.message
                            , details = NoTextEmptyString.error.details
                            , under = "text \"\""
                            }
                        ]
        , test "it should detect `H.text \"\"`" <|
            \() ->
                """
module A exposing (..)

import Html as H exposing (text)

foo : Html.Html msg
foo = H.text ""
            """
                    |> Review.Test.run NoTextEmptyString.rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = NoTextEmptyString.error.message
                            , details = NoTextEmptyString.error.details
                            , under = "H.text \"\""
                            }
                        ]
        , test "it should detect all possible errors (even though this example doesn't compile)" <|
            \() ->
                """
module A exposing (..)

import Html as H exposing (text)

foo : Html.Html msg
foo = Html.div [ ] 
  [H.text ""
  , text ""
  , Html.text ""]
                            """
                    |> Review.Test.run NoTextEmptyString.rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = NoTextEmptyString.error.message
                            , details = NoTextEmptyString.error.details
                            , under = "H.text \"\""
                            }
                        , Review.Test.error
                            { message = NoTextEmptyString.error.message
                            , details = NoTextEmptyString.error.details
                            , under = "text \"\""
                            }
                            |> Review.Test.atExactly { start = { row = 9, column = 5 }, end = { row = 9, column = 12 } }
                        ]
        ]
