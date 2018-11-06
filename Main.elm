module Main exposing (main)

import Browser
import Html exposing (Html, article, button, div, h1, h2, h3, i, img, li, text, ul)
import Html.Attributes exposing (class, classList, src, style)
import Html.Events exposing (onClick)
import Modal
    exposing
        ( ClosingAnimation(..)
        , ClosingEffect(..)
        , OpenedAnimation(..)
        , OpeningAnimation(..)
        )
import Task


main : Program () Model Msg
main =
    Browser.element
        { init =
            always
                ( initModel
                , Cmd.batch
                    [ Cmd.map ModalMsg Modal.cmdGetWindowSize
                    ]
                )
        , subscriptions =
            \model ->
                Sub.batch
                    [ Sub.map ModalMsg Modal.subscriptions
                    ]
        , update = update
        , view = view
        }



-- Model


type alias Model =
    { modal : Modal.Model Msg
    , status : Maybe Status
    }


initModel : Model
initModel =
    { modal = Modal.initModel
    , status = Nothing
    }



-- Types


type Status
    = Success
    | Warning
    | Alert
    | Info



-- Msg


type Msg
    = NoOp
    | Approve
    | ModalMsg (Modal.Msg Msg)



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ModalMsg modalMsg ->
            let
                ( updatedModal, cmdModal ) =
                    Modal.update modalMsg model.modal
            in
            ( { model | modal = updatedModal }
            , Cmd.map ModalMsg cmdModal
            )

        Approve ->
            ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



-- View


view : Model -> Html Msg
view model =
    div
        [ class "grid-container"
        , style "margin-top" "50px"
        ]
        [ div [ class "grid-x grid-margin-x align-spaced" ]
            [ div [ class "cell small-12 medium-6 large-6 hide-for-small-only" ]
                [ img [ src "images/300x300.jpg", class "blue-box" ]
                    []
                ]
            , div [ class "cell small-12 medium-6 large-6 blue-box" ]
                [ h3 [ class "info__header" ] [ text "Modal window" ]
                , div [ style "margin-left" "10px" ]
                    [ div [] [ text "+ Elm" ]
                    , div [] [ text "+ Foundation" ]
                    , ul [ class "info__text" ]
                        [ li []
                            [ text "you can use other css frameworks" ]
                        , li []
                            [ text "large selection of open/close settings" ]
                        , li []
                            [ text "possibility define own style for modal body" ]
                        , li []
                            [ text "see a couple of examples bellow" ]
                        ]
                    ]
                ]
            ]
        , div [ class "grid-x align-spaced" ]
            [ div []
                [ button
                    [ class "button btn--width"
                    , onClick (Modal.openModal ModalMsg configSuccess)
                    ]
                    [ text "Modal Success" ]
                ]
            , div []
                [ button
                    [ class "button btn--width"
                    , onClick (Modal.openModal ModalMsg configWarning)
                    ]
                    [ text "Modal Warning" ]
                ]
            , div []
                [ button
                    [ class "button btn--width"
                    , onClick (Modal.openModal ModalMsg configAlert)
                    ]
                    [ text "Modal Alert" ]
                ]
            , div []
                [ button
                    [ class "button btn--width"
                    , onClick (Modal.openModal ModalMsg configInfo)
                    ]
                    [ text "Modal Info" ]
                ]
            ]
        , div [ class "grid-x align-spaced" ]
            [ div []
                [ button
                    [ class "button btn--width"
                    , onClick
                        (Modal.openModal
                            ModalMsg
                            (configSuccess
                                |> Modal.setOpeningAnimation FromLeft
                                |> Modal.setClosingAnimation ToRight
                            )
                        )
                    ]
                    [ i [ class "fi-arrow-right icon--margin" ] []
                    , i [ class "fi-arrow-right icon--margin" ] []
                    ]
                ]
            , div []
                [ button
                    [ class "button btn--width"
                    , onClick
                        (Modal.openModal
                            ModalMsg
                            (configSuccess
                                |> Modal.setOpeningAnimation FromLeft
                                |> Modal.setClosingAnimation ToBottom
                            )
                        )
                    ]
                    [ i [ class "fi-arrow-right icon--margin" ] []
                    , i [ class "fi-arrow-down icon--margin" ] []
                    ]
                ]
            , div []
                [ button
                    [ class "button btn--width"
                    , onClick
                        (Modal.openModal
                            ModalMsg
                            (configSuccess
                                |> Modal.setOpeningAnimation FromTop
                                |> Modal.setClosingAnimation ToBottom
                            )
                        )
                    ]
                    [ i [ class "fi-arrow-down icon--margin" ] []
                    , i [ class "fi-arrow-down icon--margin" ] []
                    ]
                ]
            , div []
                [ button
                    [ class "button btn--width"
                    , onClick
                        (Modal.openModal
                            ModalMsg
                            (configSuccess
                                |> Modal.setOpeningAnimation FromRight
                                |> Modal.setClosingAnimation ToLeft
                            )
                        )
                    ]
                    [ i [ class "fi-arrow-left icon--margin" ] []
                    , i [ class "fi-arrow-left icon--margin" ] []
                    ]
                ]
            ]
        , Modal.view model.modal
        ]



-- Various settings of Config for modal window
-- These definitions can be located e.g. in
-- src/components/Modal.elm


configSuccess : Modal.Config Msg
configSuccess =
    Modal.newConfig ModalMsg
        |> Modal.setBodyHeight 280
        |> Modal.setHeaderCss "modal__header label success"
        |> Modal.setHeader (h2 [] [ text "Success" ])
        |> Modal.setBodyCss "modal__body"
        |> Modal.setBody (bodySuccess Approve)
        |> Modal.setFooterCss "modal__footer"
        |> Modal.setFooter (footerSuccess (Modal.closeModal ModalMsg) (Modal.closeModal ModalMsg))


bodySuccess : msg -> Html msg
bodySuccess approveMsg =
    div
        [ class "callout clearfix"
        , style "width" "100%"
        ]
        [ div [] [ text "Elm is great." ]
        , div [ class " float-right" ]
            [ button
                [ class "hollow button success"
                , onClick approveMsg
                ]
                [ text "Approve" ]
            ]
        ]


footerSuccess : msg -> msg -> Html msg
footerSuccess confirmMsg closeMsg =
    div [ class "button-group" ]
        [ button
            [ class "button"
            , onClick confirmMsg
            ]
            [ text "Confirm" ]
        , button
            [ class "button"
            , onClick closeMsg
            ]
            [ text "Close" ]
        ]


configWarning : Modal.Config Msg
configWarning =
    Modal.newConfig ModalMsg
        |> Modal.setClosingEffect WithoutAnimate
        |> Modal.setOpeningAnimation FromTop
        |> Modal.setOpenedAnimation OpenFromTop
        |> Modal.setClosingAnimation ToTop
        |> Modal.setHeaderCss "modal__header label warning"
        |> Modal.setHeader (h2 [] [ text "Warning" ])
        |> Modal.setBodyCss "modal__body"
        |> Modal.setBody bodyWarning
        |> Modal.setFooterCss "modal__footer"
        |> Modal.setFooter (footerWarning (Modal.closeModal ModalMsg))


bodyWarning : Html msg
bodyWarning =
    div []
        [ text "Don't be worry. It's just warning..." ]


footerWarning : msg -> Html msg
footerWarning msg =
    button
        [ class "button"
        , onClick msg
        ]
        [ text "Close" ]


configAlert : Modal.Config Msg
configAlert =
    Modal.newConfig ModalMsg
        |> Modal.setOpeningAnimation FromBottom
        |> Modal.setOpenedAnimation OpenFromBottom
        |> Modal.setClosingAnimation ToBottom
        |> Modal.setHeaderCss "modal__header label alert"
        |> Modal.setHeader (h2 [] [ text "Alert" ])
        |> Modal.setBodyCss "modal__body"
        |> Modal.setBody bodyAlert
        |> Modal.setFooterCss "modal__footer"
        |> Modal.setFooter (footerSuccess (Modal.closeModal ModalMsg) (Modal.closeModal ModalMsg))


bodyAlert : Html msg
bodyAlert =
    div []
        [ text "Run and make panic..." ]


footerAlert : msg -> msg -> Html msg
footerAlert confirmMsg closeMsg =
    div [ class "button-group" ]
        [ button
            [ class "button"
            , onClick confirmMsg
            ]
            [ text "Stop" ]
        , button
            [ class "button"
            , onClick closeMsg
            ]
            [ text "Close" ]
        ]


configInfo : Modal.Config Msg
configInfo =
    Modal.newConfig ModalMsg
        |> Modal.setOpeningAnimation FromRight
        |> Modal.setOpenedAnimation OpenFromRight
        |> Modal.setClosingAnimation ToRight
        |> Modal.setHeaderCss "modal__header label primary"
        |> Modal.setHeader (h2 [] [ text "Info" ])
        |> Modal.setBodyCss "modal__body"
        |> Modal.setBody bodyInfo
        |> Modal.setFooterCss "modal__footer"
        |> Modal.setFooter (footerSuccess (Modal.closeModal ModalMsg) (Modal.closeModal ModalMsg))


bodyInfo : Html msg
bodyInfo =
    div []
        [ text "Everything is fine." ]


footerInfo : msg -> msg -> msg -> Html msg
footerInfo confirmMsg callMsg closeMsg =
    div [ class "button-group" ]
        [ button
            [ class "button"
            , onClick confirmMsg
            ]
            [ text "Ok" ]
        , button
            [ class "button"
            , onClick callMsg
            ]
            [ text "Call" ]
        , button
            [ class "button"
            , onClick closeMsg
            ]
            [ text "Close" ]
        ]
