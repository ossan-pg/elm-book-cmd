-- 基礎からわかるElm P.129-130


module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Http


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias Model =
    { resultCore : String
    , resultSvg : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { resultCore = "", resultSvg = "" }
    , Cmd.none
    )



-- UPDATE


type Msg
    = Click
    | GotRepoCore (Result Http.Error String)
    | GotRepoSvg (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Click ->
            ( model
            , Cmd.batch
                [ Http.get
                    { url = "https://api.github.com/repos/elm/core"
                    , expect = Http.expectString GotRepoCore
                    }
                , Http.get
                    { url = "https://api.github.com/repos/elm/svg"
                    , expect = Http.expectString GotRepoSvg
                    }
                ]
            )

        GotRepoCore (Ok repo) ->
            ( { model | resultCore = repo }, Cmd.none )

        GotRepoCore (Err error) ->
            ( { model | resultCore = Debug.toString error }, Cmd.none )

        GotRepoSvg (Ok repo) ->
            ( { model | resultSvg = repo }, Cmd.none )

        GotRepoSvg (Err error) ->
            ( { model | resultSvg = Debug.toString error }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Click ] [ text "Get Repository Info" ]
        , h3 [] [ text "https://api.github.com/repos/elm/core" ]
        , p [] [ text model.resultCore ]
        , h3 [] [ text "https://api.github.com/repos/elm/svg" ]
        , p [] [ text model.resultSvg ]
        ]
