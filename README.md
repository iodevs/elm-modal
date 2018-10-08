# elm-modal
A library for displaying Modal window. You can set a behaviour and style of your modal window by a Config settings.

Install package usually a way (elm-0.19):
```
elm install iodevs/elm-modal
```

and compile
```
elm make example/Main.elm --output=example/main.js
```


## Usage
You have to import Modal everywhere where you want to use it.
```haskell
import Modal
```

### Main
```haskell
-- add to init a part
Cmd.map ModalMsg Modal.cmdGetWindowSize

-- add to subscriptions a part
Sub.map ModalMsg Modal.subscriptions
```

### Model
```haskell
type alias Model =
    { modal : Modal.Model Msg
    , ...
    }

initModel : Model
initModel =
    { modal = Modal.initModel
    , ...
    }
```

### Messages
```haskell
type Msg
    = ModalMsg (Modal.Msg Msg)
    | ...
```

### Update
```haskell
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
        ...
```

### View
```haskell
import Components.ConfigModal

view : Model -> Html Msg
view model =
    div [ ]
        [ ...
        , div []
            [ button
                [ onClick (Modal.openModal ModalMsg ConfigModal.configAlert)
                ]
                [ text "Modal Alert" ]
            ]
        , ...
        , Modal.view model.modal
        ]
```

### Components/ConfigModal.elm
Here you can define a lot of various Modal windows. In our case we defined "Alert" modal. Also you visit [elm-package](https://package.elm-lang.org/packages/iodevs/elm-history/latest/) where you can find an another settings functions.

```haskell
import Modal
    exposing
        ( ClosingAnimation(..)
        , ClosingEffect(..)
        , OpenedAnimation(..)
        , OpeningAnimation(..)
        )

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
    div [ ... ] [ ... ]


footerAlert : msg -> msg -> Html msg
footerAlert stopMsg closeMsg =
    div [ class "button-group" ]
        [ button
            [ class "button"
            , onClick stopMsg
            ]
            [ text "Stop" ]
        , button
            [ class "button"
            , onClick closeMsg
            ]
            [ text "Close" ]
        ]
```

## or look at
* an `example` directory in this repository
* or a live [demo](https://iodevs.github.io/elm-modal)


## Notes
* an animations in a part `OpenedAnimation` currently are not defined