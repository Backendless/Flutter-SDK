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
    }
    
    // MARK: -
    // MARK: - Cache Reference
    private let data = SwiftBackendlessSdkPlugin.backendless.data
    
    // MARK: -
    // MARK: - Router
    var callRouter: FlutterMethodCallHandler?
    
    // MARK: -
    // MARK: - Init
    init() {
        setupRouter()
    }
    
    private func setupRouter() {
        callRouter = { [weak self] (call, result) in
            guard
                let self = self,
                let arguments: [String: Any] = call.arguments.flatMap(cast),
                let tableName: String = arguments[Args.tableName].flatMap(cast)
            else { return }
            
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
                
            default:
                break
            }
        }
    }
    
    // MARK: -
    // MARK: - AddRelation
    private func addRelation(_ tableName: String, _ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in addReliation")
        
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
        
        // TODO: - QueryBuilder
            fatalError("QueryBuilder is using in this method. Need time for researching")
        //
        
        data.ofTable(tableName)
            .find(queryBuilder: DataQueryBuilder(),
                responseHandler: {
                    result($0)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
    }
    
    // MARK: -
    // MARK: - FindById
    private func findById(_ tableName: String, _ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in find by id")
        
        guard
            let id: String = arguments[Args.id].flatMap(cast),
            let relations: [String] = arguments[Args.relations].flatMap(cast),
            let relationsDepth: Int = arguments[Args.relationsDepth].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        data.ofTable(tableName)
            .findById(objectId: id,
                responseHandler: {
                    result($0)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
        
        // TODO: - QueryBuilder
        fatalError("QueryBuilder is using in this method. Need time for researching")
        //
        
        data.ofTable(tableName)
            .findById(objectId: id, queryBuilder: DataQueryBuilder(),
                responseHandler: {
                    result($0)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
    }
    
    // MARK: -
    // MARK: - FindFirst
    private func findFirst(_ tableName: String, arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Find First")
        
        data.ofTable(tableName)
            .findFirst(responseHandler: {
                    result($0)
                }, errorHandler: {
                    result(FlutterError($0))
                })
        
        // TODO: - QueryBuilder
        fatalError("QueryBuilder is using in this method. Need time for researching")
        //
        
        data.ofTable(tableName)
            .findFirst(queryBuilder: DataQueryBuilder(),
                responseHandler: {
                    result($0)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
    }
    
    // MARK: -
    // MARK: - FindLast
    private func findLast(_ tableName: String, arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Find Last")
        
        data.ofTable(tableName)
            .findLast(responseHandler: {
                result($0)
            }, errorHandler: {
                result(FlutterError($0))
            })
        
        // TODO: - QueryBuilder
        fatalError("QueryBuilder is using in this method. Need time for researching")
        //
        
        data.ofTable(tableName)
            .findLast(queryBuilder: DataQueryBuilder(),
                responseHandler: {
                    result($0)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
    }
    
    // MARK: -
    // MARK: - Get Object Count
    private func getObjectCount(_ tableName: String, _ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Get Object Count")
        
        data.ofTable(tableName)
            .getObjectCount(responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
        
        // TODO: - QueryBuilder
        fatalError("QueryBuilder is using in this method. Need time for researching")
        //
        
        data.ofTable(tableName)
            .getObjectCount(queryBuilder: DataQueryBuilder(),
                responseHandler: {
                    result($0)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
    }
    
    // MARK: -
    // MARK: - Load Relations
    private func loadRelations(_ tableName: String, _ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Load Relations")
        
        guard let objectId: String = arguments[Args.objectId].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        // TODO: - LoadRelationsQueryBuilder
        fatalError("LoadRelationsQueryBuilder is using in this method. Need time for researching")
        //
        
        data.ofTable(tableName)
            .loadRelations(objectId: objectId, queryBuilder: LoadRelationsQueryBuilder(tableName: tableName),
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
                .setRelation(columnName: relationColumnName, parentObjectId: parent, childrenObjectIds: $0, responseHandler: successHander, errorHandler: errorHandler)
        }
        
        whereClause.flatMap { [weak self] in
            self?.data.ofTable(tableName)
                .setRelation(columnName: relationColumnName, parentObjectId: parent, whereClause: $0, responseHandler: successHander, errorHandler: errorHandler)
        }
    }
    
    // MARK: -
    // MARK: - Update
    private func update(_ tableName: String, _ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Update")
        
        guard let entity: [String: Any] = arguments[Args.entity].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        data.ofTable(tableName)
            .update(entity: entity,
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
        
        // TODO: - СallStoredProcedure
        fatalError("СallStoredProcedure is not implemented in iOS SDK")
        //
    }
    
    // MARK: -
    // MARK: - Describe
    private func describe(_ tableName: String, _ result: @escaping FlutterResult) {
        print("~~~> Hello in Describe")
        
        data.describe(tableName: tableName,
            responseHandler: { (properties: [ObjectProperty]) in
                // TODO: - Need to check if it works correctly
                result(properties)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: - Get View
    private func getView(_ tableName: String, _ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Get View")
        
        // TODO: - GetView
        fatalError("GetView is not implemented in iOS SDK")
        //
    }
    
    
}
