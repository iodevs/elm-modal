module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Modal
    exposing
        ( ClosingAnimation(..)
        , ClosingEffect(..)
        , OpenedAnimation(..)
        , OpeningAnimation(..)
        )


main : Program Never Model Msg
main =
    program
        { init = ( initModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \model -> Sub.none
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
    | Confirm
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
            , cmdModal
            )

        Confirm ->
            ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



-- Settings Config for Modal


configSuccess : Modal.Config Msg
configSuccess =
    Modal.newConfig ModalMsg
        |> Modal.setHeaderCss "label success"
        |> Modal.setHeader (h2 [] [ text "Success" ])
        |> Modal.setBodyCss "body__success--bg-color"
        |> Modal.setBody (bodySuccess Confirm)
        |> Modal.setFooterCss "footer__success--bg-color"
        |> Modal.setFooter (footerSuccess (Modal.closeModal ModalMsg) (Modal.closeModal ModalMsg))


bodySuccess : msg -> Html msg
bodySuccess confirmMsg =
    div []
        [ text "Hlaseni v rozhlase"
        , button
            [ class "button"
            , onClick confirmMsg
            ]
            [ text "Confirm" ]
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
        |> Modal.setHeaderCss "label warning"
        |> Modal.setHeader (h2 [] [ text "Warning" ])
        |> Modal.setBody bodyWarning
        |> Modal.setFooter (footerWarning (Modal.closeModal ModalMsg))


bodyWarning : Html msg
bodyWarning =
    div []
        [ text "Hlaseni na nadrazi" ]


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
        |> Modal.setHeaderCss "label alert"
        |> Modal.setHeader (h2 [] [ text "Alert" ])
        |> Modal.setBody bodyAlert
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
        |> Modal.setHeaderCss "label primary"
        |> Modal.setHeader (h2 [] [ text "Info" ])
        |> Modal.setBody bodyAlert
        |> Modal.setFooter (footerSuccess (Modal.closeModal ModalMsg) (Modal.closeModal ModalMsg))


bodyInfo : Html msg
bodyInfo =
    div []
        [ text "Hlaseni v televizi" ]


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



-- View


view : Model -> Html Msg
view model =
    div [ class "fnds__container" ]
        [ div [ class "row align-spaced align-top" ]
            [ div [ class "columns medium-6 large-6" ]
                [ img [ src "static/img/elm.jpg", class "info-box" ]
                    []
                ]
            , div [ class "columns medium-6 large-6 info-box" ]
                [ h3 [ class "info__header" ] [ text "Modal window " ]
                , div [] [ text "+ Elm" ]
                , div [] [ text "+ Foundation" ]
                , ul [ class "info-text" ]
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
        , div [ class "row align-spaced" ]
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
        , div [ class "row align-spaced" ]
            [ div []
                [ button
                    [ class "button btn--width"
                    , onClick
                        (Modal.openModal
                            ModalMsg
                            (configSuccess
                                |> Modal.setOpeningAnimation FromRight
                                |> Modal.setClosingAnimation ToBottom
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


whichConfig : Status -> Modal.Config Msg
whichConfig status =
    case status of
        Success ->
            configSuccess

        Warning ->
            configWarning

        Alert ->
            configAlert

        Info ->
            configInfo
