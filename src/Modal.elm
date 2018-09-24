module Modal
    exposing
        ( ClosingAnimation(..)
        , ClosingEffect(..)
        , Config
        , Model
        , Msg
        , OpenedAnimation(..)
        , OpeningAnimation(..)
        , animationEnd
        , closeModal
        , initModel
        , newConfig
        , openModal
        , setBody
        , setBodyCss
        , setClosingAnimation
        , setClosingEffect
        , setFooter
        , setFooterCss
        , setHeader
        , setHeaderCss
        , setOpenedAnimation
        , setOpeningAnimation
        , update
        , view
        , subscriptions
        , cmdGetWindowSize
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick)
import Json.Decode as Json
import Task
import Window


-- Model


type Model msg
    = Opening (Config msg)
    | Opened (Config msg)
    | Closing (Config msg)
    | Closed
    | WindowSize Window.Size


initModel : Model msg
initModel =
    Closed



-- subscriptions


subscriptions : Sub (Msg msg)
subscriptions =
    Window.resizes GetWindowSize



-- Commands


cmdGetWindowSize =
    Task.perform GetWindowSize Window.size



-- Types


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


type Config msg
    = Config
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
        , tagger : Msg msg -> msg
        }



-- Msg


type Msg msg
    = OpenModal (Config msg)
    | CloseModal
    | AnimationEnd
    | GetWindowSize Window.Size
    | WindowSizeChanged



-- Update


{-| -}
setModalState : Model msg -> Model msg
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

        WindowSize size ->
            WindowSize size


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
update : Msg msg -> Model msg -> ( Model msg, Cmd msg )
update msg model =
    case msg of
        OpenModal config ->
            ( Opening config
            , Cmd.none
            )

        CloseModal ->
            ( setModalState model
            , Cmd.none
            )

        AnimationEnd ->
            ( setModalState model
            , Cmd.none
            )

        GetWindowSize size ->
            ( setModalState model
            , Cmd.none
            )

        WindowSizeChanged ->
            ( model
            , cmdGetWindowSize
            )


{-| Create a new configuration for Modal.

    newConfig |> setHeaderCss "header--bg-color"

-}
newConfig : (Msg msg -> msg) -> Config msg
newConfig tagger =
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
        , tagger = tagger
        }


openModal : (Msg msg -> msg) -> Config msg -> msg
openModal fn config =
    fn (OpenModal config)


closeModal : (Msg msg -> msg) -> msg
closeModal fn =
    fn CloseModal


animationEnd : (Msg msg -> msg) -> msg
animationEnd fn =
    fn AnimationEnd



-- Setters for Config


{-| Set styles as css of modal's body

    Modal.setBodyCss "body--bg-color" config

-}
setBodyCss : String -> Config msg -> Config msg
setBodyCss newBodyCss config =
    let
        fn (Config c) =
            Config { c | bodyCss = newBodyCss }
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
        fn (Config c) =
            Config { c | body = newBody }
    in
        mapConfig fn config


setHeaderCss : String -> Config msg -> Config msg
setHeaderCss newHeaderCss config =
    let
        fn (Config c) =
            Config { c | headerCss = newHeaderCss }
    in
        mapConfig fn config


setHeader : Header msg -> Config msg -> Config msg
setHeader newHeader config =
    let
        fn (Config c) =
            Config { c | header = newHeader }
    in
        mapConfig fn config


setFooterCss : String -> Config msg -> Config msg
setFooterCss newFooterCss config =
    let
        fn (Config c) =
            Config { c | footerCss = newFooterCss }
    in
        mapConfig fn config


setFooter : Footer msg -> Config msg -> Config msg
setFooter newFooter config =
    let
        fn (Config c) =
            Config { c | footer = newFooter }
    in
        mapConfig fn config


setOpeningAnimation : OpeningAnimation -> Config msg -> Config msg
setOpeningAnimation opening config =
    let
        fn (Config c) =
            Config { c | openingAnimation = opening }
    in
        mapConfig fn config


setOpenedAnimation : OpenedAnimation -> Config msg -> Config msg
setOpenedAnimation opened config =
    let
        fn (Config c) =
            Config { c | openedAnimation = opened }
    in
        mapConfig fn config


setClosingAnimation : ClosingAnimation -> Config msg -> Config msg
setClosingAnimation closing config =
    let
        fn (Config c) =
            Config { c | closingAnimation = closing }
    in
        mapConfig fn config


setClosingEffect : ClosingEffect -> Config msg -> Config msg
setClosingEffect newClosingEffect config =
    let
        fn (Config c) =
            Config { c | closingEffect = newClosingEffect }
    in
        mapConfig fn config



-- View


{-| Render the view

    Html.map ModalMsg (Modal.view yourConfig model.modal)

-}
view : Model msg -> Html msg
view modal =
    case modal of
        Opening (Config config) ->
            div [ class "modal" ]
                [ div
                    [ class ("modal__body " ++ openingAnimationClass config.openingAnimation)
                    , onAnimationEnd (config.tagger AnimationEnd)
                    ]
                    [ div
                        [ class ("modal__header " ++ config.headerCss) ]
                        [ config.header ]
                    , div [ class ("modal__content " ++ config.bodyCss) ]
                        [ config.body ]
                    , div [ class ("modal__footer " ++ config.footerCss) ]
                        [ config.footer ]
                    ]
                ]

        Opened (Config config) ->
            div [ class "modal" ]
                [ div
                    [ class ("modal__body " ++ openedAnimationClass config.openedAnimation) ]
                    [ div
                        [ class ("modal__header " ++ config.headerCss) ]
                        [ config.header ]
                    , div [ class ("modal__content " ++ config.bodyCss) ]
                        [ config.body ]
                    , div [ class ("modal__footer " ++ config.footerCss) ]
                        [ config.footer ]
                    ]
                ]

        Closing (Config config) ->
            div [ class ("modal modal--close " ++ closingEffectClass config.closingEffect) ]
                [ div
                    [ class ("modal__body " ++ closingAnimationClass config.closingAnimation)
                    , onAnimationEnd (config.tagger AnimationEnd)
                    ]
                    [ div
                        [ class ("modal__header " ++ config.headerCss) ]
                        [ config.header ]
                    , div [ class ("modal__content " ++ config.bodyCss) ]
                        [ config.body ]
                    , div [ class ("modal__footer " ++ config.footerCss) ]
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

        ToLeft ->
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
mapConfig : (Config msg -> Config msg) -> Config msg -> Config msg
mapConfig fn config =
    fn config
