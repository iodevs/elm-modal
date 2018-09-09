module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Modal
    exposing
        ( OpeningAnimation(..)
        , OpenedAnimation(..)
        , ClosingAnimation(..)
        , ClosingEffect(..)
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
    { modal : Modal.Mdl
    , status : Status
    }


initModel : Model
initModel =
    { modal = Modal.initModel
    , status = None
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
    | ModalMsg Modal.Mesg



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ModalMsg modalMsg ->
            let
                ( updatedModal, cmdModal ) =
                    Modal.update modalMsg (whichConfig model.status) model.modal
            in
                ( { model | modal = updatedModal }
                , Cmd.map ModalMsg cmdModal
                )

        Confirm ->
            ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



-- Settings Config for Modal


configSuccess : Modal.Config Msg
configSuccess =
    Modal.newConfig
        |> setHeaderCss "label success"
        |> setHeader (h2 [] [ text "Success" ])
        |> setBodyCss "body__success--bg-color"
        |> setBody (bodySuccess Confirm)
        |> setFooterCss "footer__success--bg-color"
        |> setFooter (footerSuccess ModalMsg.CloseModal ModalMsg.CloseModal)


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
    Modal.newConfig
        |> setClosingEffect WithoutAnimate
        |> setOpeningAnimation FromTop
        |> setOpenedAnimation OpenFromTop
        |> setClosingAnimation ToTop
        |> setHeaderCss "label warning"
        |> setHeader (h2 [] [ text "Warning" ])
        |> setBody bodyWarning
        |> setFooter (footerWarning ModalMsg.CloseModal)


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
    Modal.newConfig
        |> setOpeningAnimation FromBottom
        |> setOpenedAnimation OpenFromBottom
        |> setClosingAnimation ToBottom
        |> setHeaderCss "label alert"
        |> setHeader (h2 [] [ text "Alert" ])
        |> setBody bodyAlert
        |> setFooter (footerSuccess ModalMsg.CloseModal ModalMsg.CloseModal)


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
    Modal.newConfig
        |> setOpeningAnimation FromRight
        |> setOpenedAnimation OpenFromRight
        |> setClosingAnimation ToRight
        |> setHeaderCss "label primary"
        |> setHeader (h2 [] [ text "Info" ])
        |> setBody bodyAlert
        |> setFooter (footerSuccess ModalMsg.CloseModal ModalMsg.CloseModal ModalMsg.CloseModal)


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
                    , onClick (ModalMsg.OpenModal configSuccess)
                    ]
                    [ text "Modal Success" ]
                ]
            , div []
                [ button
                    [ class "button btn--width"
                    , onClick (ModalMsg.OpenModal configWarning)
                    ]
                    [ text "Modal Warning" ]
                ]
            , div []
                [ button
                    [ class "button btn--width"
                    , onClick (ModalMsg.OpenModal configAlert)
                    ]
                    [ text "Modal Alert" ]
                ]
            , div []
                [ button
                    [ class "button btn--width"
                    , onClick (ModalMsg.OpenModal configInfo)
                    ]
                    [ text "Modal Info" ]
                ]
            ]
        , div [ class "row align-spaced" ]
            [ div []
                [ button
                    [ class "button btn--width"
                    , onClick
                        (ModalMsg.OpenModal
                            (configSuccess
                                |> setOpeningAnimation FromRight
                                |> setClosingAnimation ToBottom
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
                        (ModalMsg.OpenModal
                            (configSuccess
                                |> setOpeningAnimation FromLeft
                                |> setClosingAnimation ToBottom
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
                        (ModalMsg.OpenModal
                            (configSuccess
                                |> setOpeningAnimation FromTop
                                |> setClosingAnimation ToBottom
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
                        (ModalMsg.OpenModal
                            (configSuccess
                                |> setOpeningAnimation FromRight
                                |> setClosingAnimation ToLeft
                            )
                        )
                    ]
                    [ i [ class "fi-arrow-left icon--margin" ] []
                    , i [ class "fi-arrow-left icon--margin" ] []
                    ]
                ]
            ]
        , mapStatusToModal model.status model.modal
        ]


mapStatusToModal : Status -> Modal -> Html Msg
mapStatusToModal status modal =
    let
        config =
            whichConfig status
    in
        Html.map ModalMsg (Modal.view config modal)


whichConfig : Status -> Config Msg
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
