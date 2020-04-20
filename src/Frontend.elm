module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Lamdera exposing (sendToBackend)
import List.Extra
import Set exposing (Set)
import Types exposing (..)
import Url


type alias Model =
    FrontendModel


app =
    Lamdera.frontend
        { init = init
        , onUrlRequest = UrlClicked
        , onUrlChange = UrlChanged
        , update = update
        , updateFromBackend = updateFromBackend
        , subscriptions = \m -> Sub.none
        , view = view
        }


init : Url.Url -> Nav.Key -> ( Model, Cmd FrontendMsg )
init url key =
    ( { key = key
      , clientId = ""
      , travels = [ Travel 1 "Seville" [ Container (ContainerMsg 1 False "Sac à dos" [ Content (Object 1 "Iphone" JustBefore) ]) ] ]
      }
    , sendToBackend ClientJoin
    )


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    case msg of
        UrlClicked urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Cmd.batch [ Nav.pushUrl model.key (Url.toString url) ]
                    )

                External url ->
                    ( model
                    , Nav.load url
                    )

        UrlChanged url ->
            ( model, Cmd.none )

        NoOpFrontendMsg ->
            ( model, Cmd.none )

        ToggleContainer travelId containerId ->
            toggleTravelContainer travelId containerId model


toggleTravelContainer : TravelId -> ContainerId -> Model -> ( Model, Cmd FrontendMsg )
toggleTravelContainer travelId containerId model =
    let
        travels =
            List.Extra.updateIf (\travel -> travel.id == travelId) (toggleContainer containerId) model.travels
    in
    ( model, Lamdera.sendToBackend (ToBackendToggleContainer travels) )



-- ({model | travels = (List.Extra.updateIf (\travel -> travel.id == travelId) (toggleContainer containerId) model.travels)}, (Lamdera.sendToBackend ) (ToBackendToggleContainer travels) )


toggleContainer : ContainerId -> Travel -> Travel
toggleContainer containerId travel =
    let
        newItems =
            List.Extra.updateIf
                (\item ->
                    case item of
                        Container container ->
                            container.id == containerId

                        Content _ ->
                            False
                )
                (\item ->
                    case item of
                        Container container ->
                            Container { container | opened = not container.opened }

                        Content _ ->
                            item
                )
                travel.items
    in
    { travel | items = newItems }


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        UpdateTravelsFromBackend travels clientId ->
            ( { model | travels = travels, clientId = clientId }, Cmd.none )

        NoOpToFrontend ->
            ( model, Cmd.none )



-- _ ->
--     (model, Cmd.none)


view : Model -> Browser.Document FrontendMsg
view model =
    { title = "Forget-it!"
    , body =
        [ h1 [] [ text <| "clientId = " ++ model.clientId ]
        , h1 [] [ text "Travels" ]
        , showTravels model.travels
        ]
    }


showTravels : List Travel -> Html FrontendMsg
showTravels travels =
    div [] (List.map showTravel travels)


showItems : TravelId -> List Item -> Html FrontendMsg
showItems travelId items =
    div [] (List.map (showItem travelId) items)


showTravel : Travel -> Html FrontendMsg
showTravel travel =
    div [] [ h2 [] [ text travel.name ], showItems travel.id travel.items ]


showItem : TravelId -> Item -> Html FrontendMsg
showItem travelId item =
    case item of
        Container container ->
            showContainer travelId container

        Content object ->
            showContent object


showContainer : TravelId -> ContainerMsg -> Html FrontendMsg
showContainer travelId container =
    div [ onClick <| ToggleContainer travelId container.id ]
        (h2 [] [ text container.name ]
            :: (if container.opened then
                    List.map (showItem travelId) container.items

                else
                    []
               )
        )


showContent : Object -> Html FrontendMsg
showContent object =
    div [] [ h3 [] [ text object.name ] ]
