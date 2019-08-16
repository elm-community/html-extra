module Html.Attributes.Autocomplete exposing
    ( Completion(..), completionValue
    , DetailedCompletion(..), detailedValue
    , ContactType(..), contactTypeValue
    , ContactCompletion(..), contactValue
    )

{-| This module contains types and values you can use to build up a list of
autocomplete tokens for form fields. Simple values like `On` or `Off` are
available, as well as more complex, nestable values: `Detailed <| Section "red"
<| Shipping <| Contact (Just Fax) Telephone`.

You'll probably want to import this module with an alias:

    import Html exposing (input)
    import Html.Attributes.Autocomplete as Autocomplete
    import Html.Attributes.Extra exposing (autocomplete)

    myShippingEmailInput =
        input
            [ autocomplete <|
                Autocomplete.Detailed <|
                    Autocomplete.Shipping <|
                        Autocomplete.Contact Nothing <|
                            Autocomplete.Email
            ]
            []

Check out the [HTML Spec][spec] for more informaion about the `autocomplete`
attribute and the autocomplete detail tokens, such as their meaning, valid
controls, and inputformat.

[spec]: https://html.spec.whatwg.org/multipage/form-control-infrastructure.html#autofill

@docs Completion, completionValue

@docs DetailedCompletion, detailedValue

@docs ContactType, contactTypeValue

@docs ContactCompletion, contactValue

-}


{-| This is the generalized completion value. You explicitly toggle completion
on or off, or use a more complex `DetailedCompletion`.
-}
type Completion
    = On
    | Off
    | Detailed DetailedCompletion


{-| Build the attribute value for a `Completion`.
-}
completionValue : Completion -> String
completionValue v =
    case v of
        On ->
            "on"

        Off ->
            "off"

        Detailed dv ->
            detailedValue dv
                |> String.join " "


{-| The base type for detailed autocomplete attributes. Some of these are
simple, like `Email`, while some allow nesting of autocomplete tokens, like
`Billing Email`.
-}
type DetailedCompletion
    = Section String DetailedCompletion
    | Shipping DetailedCompletion
    | Billing DetailedCompletion
    | Contact (Maybe ContactType) ContactCompletion
    | Name
    | HonorificPrefix
    | GivenName
    | AdditionalName
    | FamilyName
    | HonorificSuffix
    | Nickname
    | Username
    | NewPassword
    | CurrentPassword
    | OneTimeCode
    | OrganizationTitle
    | Organization
    | StreetAddress
    | AddressLine1
    | AddressLine2
    | AddressLine3
    | AddressLevel4
    | AddressLevel3
    | AddressLevel2
    | AddressLevel1
    | Country
    | CountryName
    | PostalCode
    | CreditCardName
    | CreditCardGivenName
    | CreditCardAdditionalName
    | CreditCardFamilyName
    | CreditCardNumber
    | CreditCardExpiration
    | CreditCardExpirationMonth
    | CreditCardExpirationYear
    | CreditCardCSC
    | CreditCardType
    | TransactionCurrency
    | TransactionAmount
    | Language
    | Birthday
    | BirthdayDay
    | BirthdayMonth
    | BirthdayYear
    | Sex
    | Url
    | Photo


{-| Build a list of autocomplete tokens for a `DetailedCompletion`.
-}
detailedValue : DetailedCompletion -> List String
detailedValue v =
    case v of
        Section name rest ->
            ("section-" ++ name) :: detailedValue rest

        Shipping rest ->
            "shipping" :: detailedValue rest

        Billing rest ->
            "billing" :: detailedValue rest

        Contact maybeType completion ->
            List.filterMap identity
                [ Maybe.map contactTypeValue maybeType
                , Just <| contactValue completion
                ]

        Name ->
            List.singleton "name"

        HonorificPrefix ->
            List.singleton "honorific-prefix"

        GivenName ->
            List.singleton "given-name"

        AdditionalName ->
            List.singleton "additional-name"

        FamilyName ->
            List.singleton "family-name"

        HonorificSuffix ->
            List.singleton "honorific-suffix"

        Nickname ->
            List.singleton "nickname"

        Username ->
            List.singleton "username"

        NewPassword ->
            List.singleton "new-password"

        CurrentPassword ->
            List.singleton "current-password"

        OneTimeCode ->
            List.singleton "one-time-code"

        OrganizationTitle ->
            List.singleton "organization-title"

        Organization ->
            List.singleton "organization"

        StreetAddress ->
            List.singleton "street-address"

        AddressLine1 ->
            List.singleton "address-line1"

        AddressLine2 ->
            List.singleton "address-line2"

        AddressLine3 ->
            List.singleton "address-line3"

        AddressLevel4 ->
            List.singleton "address-level4"

        AddressLevel3 ->
            List.singleton "address-level3"

        AddressLevel2 ->
            List.singleton "address-level2"

        AddressLevel1 ->
            List.singleton "address-level1"

        Country ->
            List.singleton "country"

        CountryName ->
            List.singleton "country-name"

        PostalCode ->
            List.singleton "postal-code"

        CreditCardName ->
            List.singleton "cc-name"

        CreditCardGivenName ->
            List.singleton "cc-given-name"

        CreditCardAdditionalName ->
            List.singleton "cc-additional-name"

        CreditCardFamilyName ->
            List.singleton "cc-family-name"

        CreditCardNumber ->
            List.singleton "cc-number"

        CreditCardExpiration ->
            List.singleton "cc-exp"

        CreditCardExpirationMonth ->
            List.singleton "cc-exp-month"

        CreditCardExpirationYear ->
            List.singleton "cc-exp-year"

        CreditCardCSC ->
            List.singleton "cc-csc"

        CreditCardType ->
            List.singleton "cc-type"

        TransactionCurrency ->
            List.singleton "transaction-currency"

        TransactionAmount ->
            List.singleton "transaction-amount"

        Language ->
            List.singleton "language"

        Birthday ->
            List.singleton "bday"

        BirthdayDay ->
            List.singleton "bday-day"

        BirthdayMonth ->
            List.singleton "bday-month"

        BirthdayYear ->
            List.singleton "bday-year"

        Sex ->
            List.singleton "sex"

        Url ->
            List.singleton "url"

        Photo ->
            List.singleton "photo"


{-| The optional contact types a `ContactCompletion` can be tagged with.
-}
type ContactType
    = Home
    | Work
    | Mobile
    | Fax
    | Pager


{-| Transform a ContactType into it's autocomplete detail token.
-}
contactTypeValue : ContactType -> String
contactTypeValue v =
    case v of
        Home ->
            "home"

        Work ->
            "work"

        Mobile ->
            "mobile"

        Fax ->
            "fax"

        Pager ->
            "pager"


{-| Autocomplete tokens with the ability to be tagged with a `ContactType`.
-}
type ContactCompletion
    = Telephone
    | TelephoneCountryCode
    | TelephoneNational
    | TelephoneAreaCode
    | TelephoneLocal
    | TelephoneLocalPrefix
    | TelephoneLocalSuffix
    | TelephoneExtension
    | Email
    | IMPP


{-| Transform a ContactCompletion into it's autocomplete detail token.
-}
contactValue : ContactCompletion -> String
contactValue v =
    case v of
        Telephone ->
            "tel"

        TelephoneCountryCode ->
            "tel-country-code"

        TelephoneNational ->
            "tel-national"

        TelephoneAreaCode ->
            "tel-area-code"

        TelephoneLocal ->
            "tel-local"

        TelephoneLocalPrefix ->
            "tel-local-prefix"

        TelephoneLocalSuffix ->
            "tel-local-suffix"

        TelephoneExtension ->
            "tel-extension"

        Email ->
            "email"

        IMPP ->
            "impp"
