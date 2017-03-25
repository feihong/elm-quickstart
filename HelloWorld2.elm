module Main exposing (..)

import Html exposing (Html, div, p, text, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Array
import Random
import Json.Decode exposing (..)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


greetingsJson =
    """
[ "Hello World"
, "Hola Mundo"
, "ਸਤਿ ਸ੍ਰੀ ਅਕਾਲ ਦੁਨਿਆ"
, "こんにちは世界"
, "你好世界"
, "Përshendetje Botë"
, "مرحبا بالعالم"
, "Բարեւ, աշխարհ"
, "হ্যালো দুনিয়া"
, "Saluton mondo"
, "გამარჯობა მსოფლიო"
]
"""


generate greetings =
    let
        upper =
            (Array.length greetings) - 1
    in
        Random.generate NewIndex (Random.int 0 upper)



-- MODEL


type alias Model =
    { index : Int, greetings : Array.Array String }


init : ( Model, Cmd Msg )
init =
    let
        greetings =
            case decodeString (array string) greetingsJson of
                Ok results ->
                    results

                Err _ ->
                    Array.empty
    in
        ( { index = 0, greetings = greetings }, Cmd.none )



-- UPDATE


type Msg
    = Generate
    | NewIndex Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Generate ->
            ( model, generate model.greetings )

        NewIndex num ->
            ( { model | index = num }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        greeting =
            case Array.get model.index model.greetings of
                Just i ->
                    i

                Nothing ->
                    "???"
    in
        div []
            [ p [] [ text (toString model.index) ]
            , p [] [ text greeting ]
            , button [ class "btn btn-default", onClick Generate ] [ text "Click me!" ]
            ]
