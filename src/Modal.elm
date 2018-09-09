module Modal exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, on)
import Json.Decode as Json


-- Model


type alias Model =
    Modal


initModel =
    Closed



-- type alias Model config =
--     { modal : Modal config }
-- initModel =
--     { modal = Closed }
--Types


{-| Opaque type that holds the configuration
-}
type Config msg
    = Config (PrivateConfig msg)


{-| Opaque type that holds the current model
-}
type Mdl
    = PrivateModel Model


{-| Opaque type for internal library messages
-}
type Mesg config
    = PrivateMsg (Msg config)


type OpeningAnimation
    = FromTop
    | FromRight
    | FromBottom
    | FromLeft


type OpenedAnimation
    = OpenFromTop
    | OpenFromRight
    | OpenFromBottom
    | OpenFromLeft


type ClosingAnimation
    = ToTop
    | ToRight
    | ToBottom
    | ToLeft


type ClosingEffect
    = WithoutAnimate
    | WithAnimate


type alias Header msg =
    Html msg


type alias Body msg =
    Html msg


type alias Footer msg =
    Html msg


type alias PrivateConfig msg =
    { openingAnimation : OpeningAnimation
    , openedAnimation : OpenedAnimation
    , closingAnimation : ClosingAnimation
    , closingEffect : ClosingEffect
    , headerCss : String
    , header : Header msg
    , bodyCss : String
    , body : Body msg
    , footerCss : String
    , footer : Footer msg
    }


{-| Create a new configuration for Modal.

    newConfig |> setHeaderCss "header--bg-color"

-}
newConfig : Config msg
newConfig =
    Config
        { openingAnimation = FromTop
        , openedAnimation = OpenFromTop
        , closingAnimation = ToTop
        , closingEffect = WithAnimate
        , headerCss = ""
        , header = text ""
        , bodyCss = ""
        , body = text ""
        , footerCss = ""
        , footer = text ""
        }


type Modal config
    = Opening config
    | Opened config
    | Closing config
    | Closed


type Msg config
    = OpenModal config
    | CloseModal
    | AnimationEnd



-- Setter for Config


{-| Set styles as css of modal's body

    Modal.setBodyCss "body--bg-color" config

-}
setBodyCss : String -> Config msg -> Config msg
setBodyCss newBodyCss config =
    let
        fn c =
            { c | bodyCss = newBodyCss }
    in
        mapConfig fn config


{-| Set styles and msg to the body of modal

    bodySuccess : Html msg
    bodySuccess =
        div [][ text "Hello from body modal." ]

    Modal.setBody bodySuccess config

-}
setBody : Body msg -> Config msg -> Config msg
setBody newBody config =
    let
        fn c =
            { c | body = newBody }
    in
        mapConfig fn config


setHeaderCss : String -> Config msg -> Config msg
setHeaderCss newHeaderCss config =
    let
        fn c =
            { c | headerCss = newHeaderCss }
    in
        mapConfig fn config


setHeader : Header msg -> Config msg -> Config msg
setHeader newHeader config =
    let
        fn c =
            { c | header = newHeader }
    in
        mapConfig fn config


setFooterCss : String -> Config msg -> Config msg
setFooterCss newFooterCss config =
    let
        fn c =
            { c | footerCss = newFooterCss }
    in
        mapConfig fn config


setFooter : Footer msg -> Config msg -> Config msg
setFooter newFooter config =
    let
        fn c =
            { c | footer = newFooter }
    in
        mapConfig fn config


setOpeningAnimation : OpeningAnimation -> Config msg -> Config msg
setOpeningAnimation opening config =
    let
        fn c =
            { c | openingAnimation = opening }
    in
        mapConfig fn config


setOpenedAnimation : OpenedAnimation -> Config msg -> Config msg
setOpenedAnimation opened config =
    let
        fn c =
            { c | openedAnimation = opened }
    in
        mapConfig fn config


setClosingAnimation : ClosingAnimation -> Config msg -> Config msg
setClosingAnimation closing config =
    let
        fn c =
            { c | closingAnimation = closing }
    in
        mapConfig fn config


setClosingEffect : ClosingEffect -> Config msg -> Config msg
setClosingEffect newClosingEffect config =
    let
        fn c =
            { c | closingEffect = newClosingEffect }
    in
        mapConfig fn config



-- Update


{-| -}
setModalState : Modal config -> Modal config
setModalState modal =
    case modal of
        Opening config ->
            Opened config

        Opened config ->
            Closing config

        Closing _ ->
            Closed

        Closed ->
            Closed


{-| Update the component state

    ModalMsg subMsg ->
        let
            ( updated, cmd ) =
                Modal.update setConfig subMsg model.modal
        in
            ( { model | modal = updated }
            , Cmd.map ModalMsg cmd
            )

-}
update : Mesg config -> Config msg -> Mdl -> ( Model, Cmd msg )
update msg_ config_ model_ =
    let
        config =
            unwrapConfig config_

        msg =
            unwrapMsg msg_

        model =
            unwrapModel model_
    in
        case msg of
            OpenModal config ->
                ( { model
                    | modal = Opening config
                  }
                , Cmd.none
                )

            CloseModal ->
                ( { model | modal = setModalState model.modal }
                , Cmd.none
                )

            AnimationEnd ->
                ( { model | modal = setModalState model.modal }
                , Cmd.none
                )



-- View


{-| Render the view

    Html.map ModalMsg (Modal.view yourConfig model.modal)

-}
view : Config msg -> Modal config -> Html (Msg config)
view config_ modal =
    let
        config =
            unwrapConfig config_
    in
        case modal of
            Opening config ->
                div [ class "modal" ]
                    [ div
                        [ class ("modal__body " ++ (openingAnimationClass config.openingAnimation))
                        , onAnimationEnd AnimationEnd
                        ]
                        [ div
                            [ class ("modal__header " ++ (config.headerCss)) ]
                            [ config.header ]
                        , div [ class ("modal__content " ++ (config.bodyCss)) ]
                            [ config.body ]
                        , div [ class ("modal__footer " ++ (config.footerCss)) ]
                            [ config.footer ]
                        ]
                    ]

            Opened config ->
                div [ class "modal" ]
                    [ div
                        [ class ("modal__body " ++ (openedAnimationClass config.openedAnimation)) ]
                        [ div
                            [ class ("modal__header " ++ (config.headerCss)) ]
                            [ config.header ]
                        , div [ class ("modal__content " ++ (config.bodyCss)) ]
                            [ config.body ]
                        , div [ class ("modal__footer " ++ (config.footerCss)) ]
                            [ config.footer ]
                        ]
                    ]

            Closing config ->
                div [ class ("modal modal--close " ++ closingEffectClass config.closingEffect) ]
                    [ div
                        [ class ("modal__body " ++ closingAnimationClass config.closingAnimation)
                        , onAnimationEnd AnimationEnd
                        ]
                        [ div
                            [ class ("modal__header " ++ (config.headerCss)) ]
                            [ config.header ]
                        , div [ class ("modal__content " ++ (config.bodyCss)) ]
                            [ config.body ]
                        , div [ class ("modal__footer " ++ (config.footerCss)) ]
                            [ config.footer ]
                        ]
                    ]

            Closed ->
                text ""



-- Private setters for Modal


closingEffectClass : ClosingEffect -> String
closingEffectClass animation =
    case animation of
        WithoutAnimate ->
            "modal--without-animate"

        WithAnimate ->
            ""


openingAnimationClass : OpeningAnimation -> String
openingAnimationClass animation =
    case animation of
        FromTop ->
            "modal--top-opening"

        FromRight ->
            "modal--right-opening"

        FromBottom ->
            "modal--bottom-opening"

        FromLeft ->
            "modal--left-opening"


closingAnimationClass : ClosingAnimation -> String
closingAnimationClass animation =
    case animation of
        ToTop ->
            "modal--top-closing"

        ToRight ->
            "modal--right-closing"

        ToBottom ->
            "modal--bottom-closing"

        toLeft ->
            "modal--left-closing"


openedAnimationClass : OpenedAnimation -> String
openedAnimationClass animation =
    case animation of
        OpenFromTop ->
            "modal--open-from-top"

        OpenFromRight ->
            "modal--open-from-right"

        OpenFromBottom ->
            "modal--open-from-bottom"

        OpenFromLeft ->
            "modal--open-from-left"



-- Internal


onAnimationStart : msg -> Attribute msg
onAnimationStart msg =
    on "animationstart" (Json.succeed msg)


onAnimationIteration : msg -> Attribute msg
onAnimationIteration msg =
    on "animationiteration" (Json.succeed msg)


onAnimationEnd : msg -> Attribute msg
onAnimationEnd msg =
    on "animationend" (Json.succeed msg)



-- Private helpers


{-| @priv
-}
mapConfig : (PrivateConfig msg -> PrivateConfig msg) -> Config msg -> Config msg
mapConfig fn config =
    config
        |> unwrapConfig
        |> fn
        |> Config


{-| @priv
-}
unwrapConfig : Config msg -> PrivateConfig msg
unwrapConfig (Config config) =
    config


{-| @priv
-}
unwrapMsg : Mesg config -> Msg config
unwrapMsg (PrivateMsg msg) =
    msg


{-| @priv
-}
unwrapModel : Mdl -> Model
unwrapModel (PrivateModel model) =
    model
