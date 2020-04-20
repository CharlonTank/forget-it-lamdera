module Evergreen.Migrate.V2 exposing (..)

import Evergreen.V1.Types as Old
import Lamdera.Migrations exposing (..)
import List
import Set exposing (Set)
import Evergreen.V2.Types as New


frontendModel : Old.FrontendModel -> ModelMigration New.FrontendModel New.FrontendMsg
frontendModel old =
    ModelMigrated
        ( { key = old.key
          , travels =
                List.map
                    (\travel ->
                        { id = travel.id
                        , name = travel.name
                        , items =
                            List.map
                                (\item ->
                                    case item of
                                        Old.Container oldContainerMsg ->
                                            New.Container
                                                { id = oldContainerMsg.id
                                                , opened = oldContainerMsg.opened
                                                , name = oldContainerMsg.name
                                                , items = updateItems oldContainerMsg.items
                                                }

                                        Old.Content oldObject ->
                                            New.Content
                                                { id = oldObject.id
                                                , name = oldObject.name
                                                , objectType =
                                                    case oldObject.objectType of
                                                        Old.DayBefore ->
                                                            New.DayBefore

                                                        Old.JustBefore ->
                                                            New.JustBefore
                                                }
                                )
                                travel.items
                        }
                    )
                    old.travels
          , clientId = ""
          }
        , Cmd.none
        )


backendModel : Old.BackendModel -> ModelMigration New.BackendModel New.BackendMsg
backendModel old =
    ModelMigrated
        ( { message = old.message
          , travels =
                List.map
                    (\travel ->
                        { id = travel.id
                        , name = travel.name
                        , items = updateItems travel.items
                        }
                    )
                    old.travels
          , clients = Set.empty
          }
        , Cmd.none
        )


frontendMsg : Old.FrontendMsg -> MsgMigration New.FrontendMsg New.FrontendMsg
frontendMsg old =
    MsgUnchanged


updateItems : List Old.Item -> List New.Item
updateItems =
    List.map
        (\item ->
            case item of
                Old.Container oldContainerMsg ->
                    New.Container
                        { id = oldContainerMsg.id
                        , opened = oldContainerMsg.opened
                        , name = oldContainerMsg.name
                        , items = updateItems oldContainerMsg.items
                        }

                Old.Content oldObject ->
                    New.Content
                        { id = oldObject.id
                        , name = oldObject.name
                        , objectType =
                            case oldObject.objectType of
                                Old.DayBefore ->
                                    New.DayBefore

                                Old.JustBefore ->
                                    New.JustBefore
                        }
        )


toBackend : Old.ToBackend -> MsgMigration New.ToBackend New.BackendMsg
toBackend old =
    MsgUnchanged


backendMsg : Old.BackendMsg -> MsgMigration New.BackendMsg New.BackendMsg
backendMsg old =
    MsgUnchanged


toFrontend : Old.ToFrontend -> MsgMigration New.ToFrontend New.FrontendMsg
toFrontend old =
    case old of
        Old.NoOpToFrontend ->
            MsgOldValueIgnored
