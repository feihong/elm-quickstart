module Main exposing (..)

import Html exposing (Html, div, p, text, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Array
import Random
import Json.Decode exposing (..)
import Http


main : Program Never Model Msg
main =
    Html.program
        { init = ( initModel, fetchGreetings () )
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


generate greetings =
    let
        upper =
            (Array.length greetings) - 1
    in
        Random.generate NewIndex (Random.int 0 upper)



-- MODEL


type alias Greetings =
    Array.Array String


type alias Model =
    { index : Int, greetings : Greetings }


initModel : Model
initModel =
    { index = 0, greetings = Array.empty }



-- UPDATE


type Msg
    = HandleGreetingsResponse (Result Http.Error Greetings)
    | Generate
    | NewIndex Int


fetchGreetings () =
    let
        request =
            Http.get "greetings.json" (array string)
    in
        Http.send HandleGreetingsResponse request


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HandleGreetingsResponse response ->
            let
                newModel =
                    case response of
                        Ok results ->
                            { model | greetings = results }

                        Err _ ->
                            model
            in
                ( newModel, generate newModel.greetings )

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
                    ""
    in
        div []
            [ p [] [ text (toString model.index) ]
            , p [] [ text greeting ]
            , button [ onClick Generate ] [ text "Click me!" ]
            ]
