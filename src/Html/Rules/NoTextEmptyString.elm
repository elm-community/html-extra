module Html.Rules.NoTextEmptyString exposing (error, rule)

{-| @doc rule
-}

import Elm.Syntax.Exposing as Exposing
import Elm.Syntax.Expression as Expression exposing (Expression)
import Elm.Syntax.Import exposing (Import)
import Elm.Syntax.ModuleName exposing (ModuleName)
import Elm.Syntax.Node as Node exposing (Node)
import Review.Rule as Rule exposing (Error, Rule)


type Context
    = NoImport
    | Import { aliasing : Maybe ModuleName, exposed : Bool }


rule : Rule
rule =
    Rule.newModuleRuleSchema "NoTextEmptyString" NoImport
        |> Rule.withImportVisitor importVisitor
        |> Rule.withExpressionVisitor expressionVisitor
        |> Rule.fromModuleRuleSchema


importVisitor : Node Import -> Context -> ( List (Error {}), Context )
importVisitor node context =
    case Node.value node |> .moduleName |> Node.value of
        [ "Html" ] ->
            ( []
            , let
                exposed =
                    case Node.value node |> .exposingList |> Maybe.map Node.value of
                        Just (Exposing.All _) ->
                            True

                        Just (Exposing.Explicit exposedNames) ->
                            List.any
                                (\exposedName ->
                                    case Node.value exposedName of
                                        Exposing.FunctionExpose "text" ->
                                            True

                                        _ ->
                                            False
                                )
                                exposedNames

                        Nothing ->
                            False

                aliasing =
                    Node.value node |> .moduleAlias |> Maybe.map Node.value
              in
              Import { aliasing = aliasing, exposed = exposed }
            )

        _ ->
            ( [], context )


expressionVisitor : Node Expression -> Rule.Direction -> Context -> ( List (Error {}), Context )
expressionVisitor expression direction context =
    case ( direction, context ) of
        ( Rule.OnEnter, Import { aliasing, exposed } ) ->
            case Node.value expression of
                Expression.Application [ function, argument ] ->
                    case ( Node.value function, Node.value argument ) of
                        ( Expression.FunctionOrValue [] "text", Expression.Literal "" ) ->
                            if exposed then
                                -- then this "text" is `Html.text`
                                ( [ Rule.error error (Node.range expression) ], context )

                            else
                                ( [], context )

                        ( Expression.FunctionOrValue moduleName "text", Expression.Literal "" ) ->
                            if moduleName == (aliasing |> Maybe.withDefault [ "Html" ]) then
                                ( [ Rule.error error (Node.range expression) ], context )

                            else
                                ( [], context )

                        _ ->
                            ( [], context )

                _ ->
                    ( [], context )

        _ ->
            -- Either NoImport or not "onEnter"
            ( [], context )


error : { message : String, details : List String }
error =
    { message = "Do not use `Html.text \"\"` to represent \"Nothing\""
    , details =
        [ "Since your project is using Html.Extra please use one of the following function instead of `Html.text \"\"`"
        , " - (`Html.Extra.nothing`)[https://package.elm-lang.org/packages/elm-community/html-extra/latest/Html-Extra#nothing]"
        , " - (`Html.Extra.viewIf`)[https://package.elm-lang.org/packages/elm-community/html-extra/latest/Html-Extra#viewIf]"
        , " - (`Html.Extra.viewMaybe`)[https://www.papillesetpupilles.fr/2019/09/sirop-de-fleurs-sauvages-maison.html/?fbclid=IwAR3BcddwSYAjNyspmabbMNaYyUkbVpsOv81VBYhOd85-XQqnhYYnJzuRWBU]"
        , " - (`Html.Extra.viewIfLazy`)[https://package.elm-lang.org/packages/elm-community/html-extra/latest/Html-Extra#viewIfLazy]"
        ]
    }
