port module Main exposing (..)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input exposing (button, labelHidden, thumb)
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
    , thumb = sliderThumb
    , step = Nothing
    }


sliderTranslation : Int -> String
sliderTranslation value =
    case value // 20 of
        0 ->
            "Ingenting"

        1 ->
            "Lite"

        2 ->
            "Noe"

        3 ->
            "Mye"

        _ ->
            "Alt"



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


sliderThumbSize : number
sliderThumbSize =
    50


sliderThumb : Element.Input.Thumb
sliderThumb =
    thumb
        [ width (px sliderThumbSize)
        , height (px sliderThumbSize)
        , Border.rounded sliderThumbSize
        , Background.color (rgb255 0 163 255)
        ]


slider : Model -> Element Msg
slider model =
    let
        sliderBackground =
            el
                [ width fill
                , height (px 2)
                , centerY
                , Background.color (rgb255 0 0 0)
                ]
                none
    in
    column
        [ width fill
        , centerX
        , spacing 5
        ]
        [ row
            [ width fill
            , height (px sliderThumbSize)
            , behindContent sliderBackground
            ]
            [ Element.Input.slider [ height fill ] { sliderConfig | value = model.sliderValue } ]
        , row
            [ Font.size 14
            , width fill
            , spaceEvenly
            ]
            [ text "Forstår ingenting"
            , text "Forstår alt"
            ]
        ]


view : Model -> Html Msg
view model =
    Element.layout
        []
    <|
        column
            [ width (fill |> maximum 900)
            , centerX
            , height fill
            , Font.family
                [ Font.typeface "Roboto", Font.sansSerif ]
            ]
            [ column [ width fill, height (fillPortion 3), padding 20, spaceEvenly ]
                [ el [ centerX, Font.size 32 ] <|
                    text "Gaute sin slider-app!"
                , column [ centerX, spacing 15 ]
                    [ el [ centerX, Font.size 24 ] <| text "Jeg forstår"
                    , el [ centerX, Font.bold, Font.size 26 ] <| text <| sliderTranslation <| round model.sliderValue
                    ]
                , slider model
                ]
            , column
                [ height (fillPortion 1) ]
                []
            ]
