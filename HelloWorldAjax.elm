module Main exposing (..)

import Html exposing (Html, div, p, text, button)
import Html.Events exposing (onClick)
import Array
import Random
import Json.Decode exposing (..)
import Http
import Process
import Task exposing (Task)
import Time exposing (Time)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias Greetings =
    Array.Array String


type alias Model =
    { current : String, greetings : Greetings }


initModel : Model
initModel =
    { current = "Loading greetings...", greetings = Array.empty }


init : ( Model, Cmd Msg )
init =
    ( initModel, delay (Time.second * 3) FetchGreetings )



-- UPDATE


type Msg
    = FetchGreetings
    | HandleGreetingsResponse (Result Http.Error Greetings)
    | Generate
    | NewIndex Int


delay : Time -> msg -> Cmd msg
delay time msg =
    Process.sleep time
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity


fetchGreetings : () -> Cmd Msg
fetchGreetings () =
    let
        request =
            Http.get "greetings.json" (array string)
    in
        Http.send HandleGreetingsResponse request


generateIndex : Array.Array a -> Cmd Msg
generateIndex greetings =
    let
        max =
            (Array.length greetings) - 1
    in
        Random.generate NewIndex (Random.int 0 max)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchGreetings ->
            ( model, fetchGreetings () )

        HandleGreetingsResponse response ->
            let
                greetings =
                    case response of
                        Ok result ->
                            result

                        Err _ ->
                            Array.empty
            in
                ( { model | greetings = greetings }, generateIndex greetings )

        Generate ->
            ( model, generateIndex model.greetings )

        NewIndex index ->
            let
                current =
                    case Array.get index model.greetings of
                        Just elem ->
                            elem

                        Nothing ->
                            ""
            in
                ( { model | current = current }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ p [] [ text model.current ]
        , button [ onClick Generate ] [ text "Click me!" ]
        ]
