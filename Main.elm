-- Read more about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/effects/random.html


module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)


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
    , movies : List Movie
    }


init : ( Model, Cmd Msg )
init =
    ( Model "welcome to trailer tracker" initialMovies, Cmd.none )


initialMovies : List Movie
initialMovies =
    [ Movie "Lucky"
        "https://trailers.apple.com/trailers/magnolia/lucky/"
        "dude from alien"
    , Movie "Thor: Ragnorok"
        "https://trailers.apple.com/trailers/marvel/thor-ragnarok/"
        ""
    , Movie "Strange Weather"
        "https://trailers.apple.com/trailers/independent/strange-weather/"
        "Holly Hunter and Carrie Coon"
    , Movie "Incredibles 2" "" ""
    ]


type alias Movie =
    { title : String
    , url : String
    , notes : String
    }



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


viewMovieItem : Movie -> Html Msg
viewMovieItem movie =
    li []
        [ text movie.title
        , text " - "
        , a [ href movie.url ] [ text movie.url ]
        , text " - "
        , text movie.notes
        ]


viewMovieList : List Movie -> Html Msg
viewMovieList movies =
    ul []
        (List.map viewMovieItem movies)


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text model.greeting ]
        , viewMovieList model.movies
        , hr [ class "mt4" ] []
        , text (toString model)
        ]
