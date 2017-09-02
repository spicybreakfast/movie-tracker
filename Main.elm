-- Read more about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/effects/random.html


module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (autofocus, class, href, placeholder, type_, value)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode exposing (Decoder, field, succeed)


-- MODEL


type alias Model =
    { greeting : String
    , movies : List Movie
    , titleInput : String
    , alertMessage : Maybe String
    }


initialModel : Model
initialModel =
    Model "welcome to trailer tracker." [] "" (Just "feelin fine.")


type alias Movie =
    { id : Int
    , title : String
    , url : String
    , notes : String
    }



-- UPDATE


type Msg
    = AddMovie
    | SetMovieInput String
    | SaveMovie
    | NewMovies (Result Http.Error (List Movie))
    | CloseAlert


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewMovies (Ok newMovies) ->
            ( { model | movies = newMovies }, Cmd.none )

        NewMovies (Err error) ->
            ( { model | alertMessage = Just ("abbot is death process: " ++ toString error) }, Cmd.none )

        AddMovie ->
            ( model, Cmd.none )

        SetMovieInput value ->
            ( { model | titleInput = value }, Cmd.none )

        SaveMovie ->
            ( { model
                | movies = model.movies ++ [ Movie 1 model.titleInput "" "" ]
                , titleInput = ""
              }
            , Cmd.none
            )

        CloseAlert ->
            ( { model | alertMessage = Nothing }, Cmd.none )



-- DECODERS


movieDecoder : Decoder Movie
movieDecoder =
    Decode.map4 Movie
        (field "id" Decode.int)
        (field "title" Decode.string)
        (field "url" Decode.string)
        (field "notes" Decode.string)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- COMMANDS


moviesUrl : String
moviesUrl =
    "http://localhost:3000/movies"


getMovies : Cmd Msg
getMovies =
    Decode.list movieDecoder
        |> Http.get moviesUrl
        |> Http.send NewMovies



-- VIEW


viewMovieItem : Movie -> Html Msg
viewMovieItem movie =
    li [ class "ph3 pv3 bb b--light-silver" ]
        [ text movie.title
        , text " - "
        , a [ href movie.url ] [ text movie.url ]
        , text " - "
        , text movie.notes
        ]


viewMovieList : List Movie -> Html Msg
viewMovieList movies =
    ul [ class "list pl0 ml0 mw9 ba b--light-silver br2 bg-white" ]
        (List.map viewMovieItem movies)


viewMovieInput : Model -> Html Msg
viewMovieInput model =
    div []
        [ input
            [ type_ "text"
            , placeholder "New Movie?"
            , autofocus True
            , value model.titleInput
            , onInput SetMovieInput
            , class "f6 f5-l input-reset bn fl black-80 bg-white pa3 lh-solid w-100 w-75-m w-30-l br2-ns br--left-ns"
            ]
            []
        , button
            [ onClick SaveMovie
            , class "f6 f5-l button-reset fl pv3 tc bn bg-animate bg-light-blue hover-bg-blue white pointer w-100 w-25-m w-10-l br2-ns br--right-ns"
            ]
            [ text "Save" ]
        , a [ href "#", class "f4 fw7 dib pa2 ma2 no-underline hover-bg-light-blue red" ] [ text "Cancel" ]
        ]


viewAlertMessage : Maybe String -> Html Msg
viewAlertMessage alertMessage =
    case alertMessage of
        Just message ->
            div [ class "bg-red pa3 white" ]
                [ span [ class "fr pointer", onClick CloseAlert ] [ text "X" ]
                , text message
                ]

        Nothing ->
            div [] []


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text model.greeting ]
        , viewAlertMessage model.alertMessage
        , viewMovieList model.movies
        , viewMovieInput model
        , hr [ class "mt4" ] []
        , text (toString model)
        ]



-- MAIN


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, getMovies )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
