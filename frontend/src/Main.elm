port module Main exposing (..)

import Browser
import Element exposing (..)
import Element.Input exposing (button, defaultThumb, labelHidden)
import Html exposing (Html)



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- PORTS


port sendMessage : String -> Cmd msg


port messageReceiver : (String -> msg) -> Sub msg



-- MODEL


type alias Model =
    { sliderValue : Float
    , recieved : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model sliderConfig.value "Nothing yet..."
    , Cmd.none
    )


sliderConfig =
    { onChange = SliderUpdated
    , label = labelHidden "slider"
    , min = 0
    , max = 100
    , value = 50
    , thumb = defaultThumb
    , step = Nothing
    }



-- UPDATE


type Msg
    = NoOp
    | Recieve String
    | Send
    | SliderUpdated Float


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SliderUpdated value ->
            ( { model | sliderValue = value }, sendMessage (String.fromFloat value) )

        NoOp ->
            ( model, Cmd.none )

        Recieve string ->
            ( { model | recieved = string }, Cmd.none )

        Send ->
            ( model, sendMessage "Meaw" )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    messageReceiver Recieve



-- VIEW


view : Model -> Html Msg
view model =
    Element.layout [] <|
        column [ width <| fillPortion 2, centerX ]
            [ text ("value: " ++ String.fromFloat model.sliderValue)
            , Element.Input.slider [] { sliderConfig | value = model.sliderValue }
            ]
