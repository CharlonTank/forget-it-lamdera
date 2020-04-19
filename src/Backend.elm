module Backend exposing (..)

import Html
import Lamdera exposing (ClientId, SessionId, sendToFrontend)
import Set exposing (Set)
import Types exposing (..)


type alias Model =
    BackendModel


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = \m -> Sub.none
        }


init : ( Model, Cmd BackendMsg )
init =
    ( { message = "Hello!"
      , clients = Set.empty
      , travels = [ Travel 1 "Seville" [ Container (ContainerMsg 1 False "Sac à dos" [ Content (Object 1 "Iphone" JustBefore) ]) ] ]
      }
    , Cmd.none
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        NoOpBackendMsg ->
            ( model, Cmd.none )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        NoOpToBackend ->
            ( model, Cmd.none )

        ClientJoin ->
            ( { model | clients = Set.insert clientId model.clients }
            , sendToFrontend clientId (UpdateTravelsFromBackend model.travels clientId)
            )

        ToBackendToggleContainer travels ->
            ( { model | travels = travels }, broadcast model.clients (UpdateTravelsFromBackend travels clientId) )


broadcast clients msg =
    clients
        |> Set.toList
        |> List.map (\clientId -> sendToFrontend clientId msg)
        |> Cmd.batch
