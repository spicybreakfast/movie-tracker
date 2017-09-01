-- Read more about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/effects/random.html


module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)


--import Html.Events exposing (..)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { greeting : String
    , movies : List String
    }


init : ( Model, Cmd Msg )
init =
    ( Model "welcome to trailer tracker" initialMovies, Cmd.none )


initialMovies : List String
initialMovies =
    [ "Lucky", "Thor: Ragnorok", "Strange Weather", "Incredibles 2" ]



-- UPDATE


type Msg
    = Noop


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


viewTrailerItem : String -> Html Msg
viewTrailerItem trailer =
    li []
        [ text trailer ]


viewTrailerList : List String -> Html Msg
viewTrailerList movies =
    ul []
        (List.map viewTrailerItem movies)


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text model.greeting ]
        , viewTrailerList model.movies
        , hr [ class "mt4" ] []
        , text (toString model)
        ]
