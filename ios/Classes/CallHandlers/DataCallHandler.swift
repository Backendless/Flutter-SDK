//
//  DataCallHandler.swift
//  Flutter-SDK
//
//  Created by Andrii Bodnar on 4/26/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import Foundation
import Flutter
import Backendless

class DataCallHandler: FlutterCallHandlerProtocol {
    
    // MARK: -
    // MARK: - Constants
    private enum Methods {
        static let addRelation = "Backendless.Data.of.addRelation"
        static let create = "Backendless.Data.of.create"
        static let deleteRelation = "Backendless.Data.of.deleteRelation"
        static let find = "Backendless.Data.of.find"
        static let findById = "Backendless.Data.of.findById"
        static let findFirst = "Backendless.Data.of.findFirst"
        static let findLast = "Backendless.Data.of.findLast"
        static let getObjectCount = "Backendless.Data.of.getObjectCount"
        static let loadRelations = "Backendless.Data.of.loadRelations"
        static let remove = "Backendless.Data.of.remove"
        static let save = "Backendless.Data.of.save"
        static let setRelation = "Backendless.Data.of.setRelation"
        static let update = "Backendless.Data.of.update"
        static let callStoredProcedure = "Backendless.Data.callStoredProcedure"
        static let describe = "Backendless.Data.describe"
        static let addListener = "Backendless.Data.RT.addListener"
        static let removeListener = "Backendless.Data.RT.removeListener"
    }
    
    private enum Args {
        static let tableName = "tableName"
        static let parent = "parent"
        static let children = "children"
        static let relationColumnName = "relationColumnName"
        static let whereClause = "whereClause"
        static let objects = "objects"
        static let id = "id"
        static let relations = "relations"
        static let relationsDepth = "relationsDepth"
        static let objectId = "objectId"
        static let entity = "entity"
        static let queryBuilder = "queryBuilder"
        static let event = "event"
        static let handle = "handle"
        static let changes = "changes"
    }
    
    private enum DataRTEvents {
        static let bulkUpdated = "RTDataEvent.BULK_UPDATED"
        static let bulkDeleted = "RTDataEvent.BULK_DELETED"
        static let created = "RTDataEvent.CREATED"
        static let updated = "RTDataEvent.UPDATED"
        static let deleted = "RTDataEvent.DELETED"
    }
    
    // MARK: -
    // MARK: - Cache Reference
    private let data = SwiftBackendlessSdkPlugin.backendless.data
    
    // MARK: -
    // MARK: - MethodChannel
    let methodChannel: FlutterMethodChannel
    
    // MARK: -
    // MARK: - NextHandle
    private var nextHandle: Int = 0
    
    // MARK: -
    // MARK: - Handlers
    private var subscriptions: [Int: RTSubscription] = [:]
    
    // MARK: -
    // MARK: - Init
    init(methodChannel: FlutterMethodChannel) {
        self.methodChannel = methodChannel
    }
    
    // MARK: -
    // MARK: - Route Flutter Call
    func routeFlutterCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard
            let arguments: [String: Any] = call.arguments.flatMap(cast),
            let tableName: String = arguments[Args.tableName].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        switch call.method {
        case Methods.addRelation:
            self.addRelation(tableName, arguments, result)
        case Methods.create:
            self.create(tableName, arguments, result)
        case Methods.deleteRelation:
            self.addRelation(tableName, arguments, result)
        case Methods.find:
            self.find(tableName, arguments, result)
        case Methods.findById:
            self.findById(tableName, arguments, result)
        case Methods.findFirst:
            self.findFirst(tableName, arguments: arguments, result)
        case Methods.findLast:
            self.findLast(tableName, arguments: arguments, result)
        case Methods.getObjectCount:
            self.getObjectCount(tableName, arguments, result)
        case Methods.loadRelations:
            self.loadRelations(tableName, arguments, result)
        case Methods.remove:
            self.remove(tableName, arguments, result)
        case Methods.save:
            self.save(tableName, arguments, result)
        case Methods.setRelation:
            self.setRelation(tableName, arguments, result)
        case Methods.update:
            self.update(tableName, arguments, result)
        case Methods.callStoredProcedure:
            self.callStoredProcedure(tableName, arguments, result)
        case Methods.describe:
            self.describe(tableName, result)
        case Methods.addListener:
            self.addListener(tableName, arguments, result)
        case Methods.removeListener:
            self.removeListener(tableName, arguments, result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: -
    // MARK: - AddRelation
    private func addRelation(_ tableName: String, _ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in addReliation")
        
        // TODO: -
        // TODO: - In fact parent is getting as dictionary
        // TODO: - Discuss about getting objectId from Flutter or parsing here
        
        guard
            let relationColumnName: String = arguments[Args.relationColumnName].flatMap(cast),
            let parent: String = arguments[Args.parent].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        let children: [String]? = arguments[Args.children].flatMap(cast)
        let whereClause: String? = arguments[Args.whereClause].flatMap(cast)
        
        let successHander = { (relations: Int) in
            result(relations)
        }
        let errorHandler = { (fault: Fault) in
            result(FlutterError(fault))
        }
        
        children.flatMap { [weak self] in
            self?.data.ofTable(tableName)
                .addRelation(columnName: relationColumnName, parentObjectId: parent, childrenObjectIds: $0, responseHandler: successHander, errorHandler: errorHandler)
        }
        
        whereClause.flatMap { [weak self] in
            self?.data.ofTable(tableName)
                .addRelation(columnName: relationColumnName, parentObjectId: parent, whereClause: $0, responseHandler: successHander, errorHandler: errorHandler)
        }
    }
    
    // MARK: -
    // MARK: - Create
    private func create(_ tableName: String, _ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in create")
        
        guard let entities: [[String: Any]] = arguments[Args.objects].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        data.ofTable(tableName)
            .createBulk(entities: entities,
                responseHandler: {
                    result($0)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
    }
    
    // MARK: -
    // MARK: - DeleteRelation
    private func deleteRelation(_ tableName: String, _ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in deleteReliation")
        
        guard
            let relationColumnName: String = arguments[Args.relationColumnName].flatMap(cast),
            let parent: String = arguments[Args.parent].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        let children: [String]? = arguments[Args.children].flatMap(cast)
        let whereClause: String? = arguments[Args.whereClause].flatMap(cast)
        
        let successHander = { (relations: Int) in
            result(relations)
        }
        let errorHandler = { (fault: Fault) in
            result(FlutterError(fault))
        }
        
        children.flatMap { [weak self] in
            self?.data
                .ofTable(tableName)
                .deleteRelation(columnName: relationColumnName, parentObjectId: parent, childrenObjectIds: $0, responseHandler: successHander, errorHandler: errorHandler)
        }
        
        whereClause.flatMap { [weak self] in
            self?.data
                .ofTable(tableName)
                .deleteRelation(columnName: relationColumnName, parentObjectId: parent, whereClause: $0, responseHandler: successHander, errorHandler: errorHandler)
        }
    }
    
    // MARK: -
    // MARK: - Find
    private func find(_ tableName: String, _ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in find")
        
        let queryBuilder: DataQueryBuilder? = arguments[Args.queryBuilder].flatMap(cast)
        
        if let queryBuilder = queryBuilder {
            data.ofTable(tableName)
                .find(queryBuilder: queryBuilder,
                    responseHandler: {
                        result($0)
                    },
                    errorHandler: {
                        result(FlutterError($0))
                    })
        } else {
            data.ofTable(tableName)
                .find(responseHandler: {
                    result($0)
                }, errorHandler: {
                    result(FlutterError($0))
                })
        }
        
    }
    
    // MARK: -
    // MARK: - FindById
    private func findById(_ tableName: String, _ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in find by id")
        
        guard let id: String = arguments[Args.id].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        let queryBuilder: DataQueryBuilder? = arguments[Args.queryBuilder].flatMap(cast)
        let relations: [String]? = arguments[Args.relations].flatMap(cast)
        let relationsDepth: Int? = arguments[Args.relationsDepth].flatMap(cast)
        
        if let queryBuilder = queryBuilder {
            relations.map { queryBuilder.setRelated(related: $0) }
            relationsDepth.map { queryBuilder.setRelationsDepth(relationsDepth: $0) }
            
            data.ofTable(tableName)
                .findById(objectId: id, queryBuilder: queryBuilder,
                    responseHandler: {
                        result($0)
                    },
                    errorHandler: {
                        result(FlutterError($0))
                    })
        } else {
            if relations != nil || relationsDepth != nil {
                let newQueryBuilder = DataQueryBuilder()
                relations.map { newQueryBuilder.setRelated(related: $0) }
                relationsDepth.map { newQueryBuilder.setRelationsDepth(relationsDepth: $0) }
                
                data.ofTable(tableName)
                    .findById(objectId: id, queryBuilder: newQueryBuilder,
                        responseHandler: {
                            result($0)
                        },
                        errorHandler: {
                            result(FlutterError($0))
                        })
            } else {
                data.ofTable(tableName)
                    .findById(objectId: id,
                        responseHandler: {
                            result($0)
                        },
                        errorHandler: {
                            result(FlutterError($0))
                        })
            }
        }
    }
    
    // MARK: -
    // MARK: - FindFirst
    private func findFirst(_ tableName: String, arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Find First")
        
        let relations: [String]? = arguments[Args.relations].flatMap(cast)
        let relationsDepth: Int? = arguments[Args.relationsDepth].flatMap(cast)
        
        if relations != nil || relationsDepth != nil {
            let queryBuilder = DataQueryBuilder()
            relations.map { queryBuilder.setRelated(related: $0) }
            relationsDepth.map { queryBuilder.setRelationsDepth(relationsDepth: $0) }
            
            data.ofTable(tableName)
                .findFirst(queryBuilder: queryBuilder,
                    responseHandler: {
                        result($0)
                    },
                    errorHandler: {
                        result(FlutterError($0))
                    })
        } else {
            data.ofTable(tableName)
                .findFirst(responseHandler: {
                    result($0)
                }, errorHandler: {
                    result(FlutterError($0))
                })
        }
    }
    
    // MARK: -
    // MARK: - FindLast
    private func findLast(_ tableName: String, arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Find Last")
        
        let relations: [String]? = arguments[Args.relations].flatMap(cast)
        let relationsDepth: Int? = arguments[Args.relationsDepth].flatMap(cast)
        
        if relations != nil || relationsDepth != nil {
            let queryBuilder = DataQueryBuilder()
            relations.map { queryBuilder.setRelated(related: $0) }
            relationsDepth.map { queryBuilder.setRelationsDepth(relationsDepth: $0) }
            
            data.ofTable(tableName)
                .findLast(queryBuilder: queryBuilder,
                    responseHandler: {
                        result($0)
                    },
                    errorHandler: {
                        result(FlutterError($0))
                    })
        } else {
            data.ofTable(tableName)
                .findLast(responseHandler: {
                    result($0)
                }, errorHandler: {
                    result(FlutterError($0))
                })
        }
    }
    
    // MARK: -
    // MARK: - Get Object Count
    private func getObjectCount(_ tableName: String, _ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Get Object Count")
        
        let queryBuilder: DataQueryBuilder? = arguments[Args.queryBuilder].flatMap(cast)
        
        if let queryBuilder = queryBuilder {
            data.ofTable(tableName)
                .getObjectCount(queryBuilder: queryBuilder,
                    responseHandler: {
                        result($0)
                    },
                    errorHandler: {
                        result(FlutterError($0))
                    })
        } else {
            data.ofTable(tableName)
                .getObjectCount(responseHandler: {
                    result($0)
                }, errorHandler: {
                    result(FlutterError($0))
                })
        }
    }
    
    // MARK: -
    // MARK: - Load Relations
    private func loadRelations(_ tableName: String, _ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Load Relations")
        
        // TODO: -
        // TODO: - How to parse LoadRelationsQueryBuilder
        
        guard
            let objectId: String = arguments[Args.objectId].flatMap(cast),
            let queryBuilder: LoadRelationsQueryBuilder = arguments[Args.queryBuilder].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        data.ofTable(tableName)
            .loadRelations(objectId: objectId, queryBuilder: queryBuilder,
                responseHandler: {
                    result($0)
                },
                errorHandler: {
                    result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - Remove
    private func remove(_ tableName: String, _ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Remove")
        
        guard let entity: [String: Any] = arguments[Args.entity].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        data.ofTable(tableName)
            .remove(entity: entity,
                responseHandler: {
                    result($0)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
    }
    
    // MARK: -
    // MARK: - Save
    private func save(_ tableName: String, _ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("Hello in save")
        
        guard let entity: [String: Any] = arguments[Args.entity].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        data.ofTable(tableName)
            .save(entity: entity,
                responseHandler: {
                    result($0)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
    }
    
    // MARK: -
    // MARK: - Set Relation
    private func setRelation(_ tableName: String, _ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Set Relation")
        
        // TODO: -
        // TODO: - In fact parent is getting as dictionary
        // TODO: - Discuss about getting objectId from Flutter or parsing here
        
        guard
            let relationColumnName: String = arguments[Args.relationColumnName].flatMap(cast),
            let parent: String = arguments[Args.parent].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        let children: [String]? = arguments[Args.children].flatMap(cast)
        let whereClause: String? = arguments[Args.whereClause].flatMap(cast)
        
        let successHander = { (relations: Int) in
            result(relations)
        }
        let errorHandler = { (fault: Fault) in
            result(FlutterError(fault))
        }
        
        if let children = children {
            data.ofTable(tableName)
                .setRelation(columnName: relationColumnName, parentObjectId: parent, childrenObjectIds: children, responseHandler: successHander, errorHandler: errorHandler)
        }
        
        if let whereClause = whereClause {
            data.ofTable(tableName)
                .setRelation(columnName: relationColumnName, parentObjectId: parent, whereClause: whereClause, responseHandler: successHander, errorHandler: errorHandler)
        }
    }
    
    // MARK: -
    // MARK: - Update
    private func update(_ tableName: String, _ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Update")
        
        guard let changes: [String: Any] = arguments[Args.changes].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        data.ofTable(tableName)
            .update(entity: changes,
                responseHandler: {
                    result($0)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
    }
    
    // MARK: -
    // MARK: - Call Stored Procedure
    private func callStoredProcedure(_ tableName: String, _ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Call Stored Procedure")
        
        result(FlutterMethodNotImplemented)
    }
    
    // MARK: -
    // MARK: - Describe
    private func describe(_ tableName: String, _ result: @escaping FlutterResult) {
        print("~~~> Hello in Describe")
        
        // TODO: -
        // TODO: - Change "classSimpleName" in Dart code to "tableName"
        
        data.describe(tableName: tableName,
            responseHandler: { (properties: [ObjectProperty]) in
                // TODO: - Need to check if it works correctly
                result(properties)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - Get View
    private func getView(_ tableName: String, _ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Get View")
        
        result(FlutterMethodNotImplemented)
    }
    
    // MARK: -
    // MARK: - Add Listener
    private func addListener(_ tableName: String, _ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Add Listener")
        
        // TODO: -
        // TODO: - Get events from Backendless
        // TODO: - Can't see events in Flutter
        
        guard let event: String = arguments[Args.event].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        let whereClause: String? = arguments[Args.whereClause].flatMap(cast)
        
        let currentHandle = nextHandle
        nextHandle += 1
        
        var subscription: RTSubscription?
        
        let errorHandler: (Fault) -> Void = { [weak self] in
            var args: [String: Any] = [:]
            args["handle"] = currentHandle
            args["fault"] = $0.message ?? ""
            
            self?.methodChannel.invokeMethod("Backendless.Data.RT.EventFault", arguments: args);
        }
        
        if event.contains("BULK") {
            
            let bulkEventHandler: (BulkEvent) -> Void = { [weak self] in
                var args: [String: Any] = [:]
                args["hanlde"] = currentHandle
                args["response"] = $0
                
                self?.methodChannel.invokeMethod("Backendless.Data.RT.EventResponse", arguments: args)
            }
            
            switch event {
            case DataRTEvents.bulkUpdated:
                if let whereClause = whereClause {
                    subscription = data.ofTable(tableName).rt.addBulkUpdateListener(whereClause: whereClause, responseHandler: bulkEventHandler, errorHandler: errorHandler)
                } else {
                    subscription = data.ofTable(tableName).rt.addBulkUpdateListener(responseHandler: bulkEventHandler, errorHandler: errorHandler)
                }
            case DataRTEvents.bulkDeleted:
                if let whereClause = whereClause {
                    subscription = data.ofTable(tableName).rt.addBulkDeleteListener(whereClause: whereClause, responseHandler: bulkEventHandler, errorHandler: errorHandler)
                } else {
                    subscription = data.ofTable(tableName).rt.addBulkDeleteListener(responseHandler: bulkEventHandler, errorHandler: errorHandler)
                }
            default:
                result(FlutterMethodNotImplemented)
                
                return
            }
        } else {
            
            let dataEventHandler: ([String: Any]) -> Void = { [weak self] in
                var args: [String: Any] = [:]
                args["handle"] = currentHandle
                args["response"] = $0
                
                self?.methodChannel.invokeMethod("Backendless.Data.RT.EventResponse", arguments: args)
            }
            
            switch event {
            case DataRTEvents.created:
                if let whereClause = whereClause {
                    subscription = data.ofTable(tableName).rt.addCreateListener(whereClause: whereClause, responseHandler: dataEventHandler, errorHandler: errorHandler)
                } else {
                    subscription = data.ofTable(tableName).rt.addCreateListener(responseHandler: dataEventHandler, errorHandler: errorHandler)
                }
            case DataRTEvents.updated:
                if let whereClause = whereClause {
                    subscription = data.ofTable(tableName).rt.addUpdateListener(whereClause: whereClause, responseHandler: dataEventHandler, errorHandler: errorHandler)
                } else {
                    subscription = data.ofTable(tableName).rt.addUpdateListener(responseHandler: dataEventHandler, errorHandler: errorHandler)
                }
            default:
                result(FlutterMethodNotImplemented)
                
                return
            }
        }
        
        subscription.map { [weak self] in
            self?.subscriptions[currentHandle] = $0
        }
    }
    
    // MARK: -
    // MARK: - Remove Listener
    private func removeListener(_ tableName: String, _ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let handle: Int = arguments[Args.handle].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        let subscription = subscriptions[handle]
        subscription?.stop()
        subscriptions.removeValue(forKey: handle)
        
        var args: [String: Any] = [:]
        args["handle"] = handle
        methodChannel.invokeMethod("Backendless.Data.RT.EventResponse", arguments: args)
    }
}
