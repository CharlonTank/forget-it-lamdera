module Evergreen.V1.Types exposing (..)

import Browser
import Browser.Navigation
import Lamdera
import Set
import Url


type alias TravelId = Int


type alias ContainerId = Int


type alias ContainerMsg = 
    { id : ContainerId
    , opened : Bool
    , name : String
    , items : (List Item)
    }


type alias ObjectId = Int


type ObjectType
    = DayBefore
    | JustBefore


type alias Object = 
    { id : ObjectId
    , name : String
    , objectType : ObjectType
    }


type Item
    = Container ContainerMsg
    | Content Object


type alias Travel = 
    { id : TravelId
    , name : String
    , items : (List Item)
    }


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , travels : (List Travel)
    }


type alias BackendModel =
    { message : String
    , travels : (List Travel)
    }


type FrontendMsg
    = UrlClicked Browser.UrlRequest
    | UrlChanged Url.Url
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