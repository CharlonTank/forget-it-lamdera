module Types exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Url exposing (Url)


type alias FrontendModel =
    { key : Key
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
    , travels : List Travel
    }


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | NoOpFrontendMsg
    | ToggleContainer TravelId ContainerId


type ToBackend
    = NoOpToBackend
    | ToBackendToggleContainer (List Travel)


type BackendMsg
    = NoOpBackendMsg


type ToFrontend
    = UpdateTravelsFromBackend (List Travel)
