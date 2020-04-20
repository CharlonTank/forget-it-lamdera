module Types exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Lamdera exposing (ClientId, SessionId, sendToFrontend)
import Set exposing (Set)
import Url exposing (Url)


type alias FrontendModel =
    { key : Key
    , clientId : String
    , travels : List Travel
    }


type alias Travel =
    { id : TravelId
    , name : String
    , items : List Item
    }


type Item
    = Container ContainerMsg
    | Content Object


type alias ContainerMsg =
    { id : ContainerId
    , opened : Bool
    , name : String
    , items : List Item
    }



-- type ContainerStatus
--     = Opened
--     | Closed


type alias Object =
    { id : ObjectId
    , name : String
    , objectType : ObjectType
    }


type ObjectType
    = DayBefore
    | JustBefore


type alias ContainerId =
    Int


type alias ObjectId =
    Int


type alias TravelId =
    Int


type alias BackendModel =
    { message : String
    , clients : Set ClientId
    , travels : List Travel
    }


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | NoOpFrontendMsg
    | ToggleContainer TravelId ContainerId


type ToBackend
    = NoOpToBackend
    | ClientJoin
    | ToBackendToggleContainer (List Travel)


type BackendMsg
    = NoOpBackendMsg


type ToFrontend
    = NoOpToFrontend
    | UpdateTravelsFromBackend (List Travel) String
