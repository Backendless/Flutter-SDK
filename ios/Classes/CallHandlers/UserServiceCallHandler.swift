//
//  UserServiceCallHandler.swift
//  backendless_sdk
//
//  Created by Andrii Bodnar on 5/27/19.
//

import Foundation
import Flutter
import Backendless

class UserServiceCallHandler: FlutterCallHandlerProtocol {
    
    // MARK: -
    // MARK: - Constants
    private enum Methods {
        static let assignRole = "Backendless.UserService.assignRole"
        static let currentUser = "Backendless.UserService.currentUser"
        static let describeUserClass = "Backendless.UserService.describeUserClass"
        static let findById = "Backendless.UserService.findById"
        static let getUserRoles = "Backendless.UserService.getUserRoles"
        static let isValidLogin = "Backendless.UserService.isValidLogin"
        static let loggedInUser = "Backendless.UserService.loggedInUser"
        static let login = "Backendless.UserService.login"
        static let logout = "Backendless.UserService.logout"
        static let register = "Backendless.UserService.register"
        static let resendEmailConfirmation = "Backendless.UserService.resendEmailConfirmation"
        static let restorePassword = "Backendless.UserService.restorePassword"
        static let unassignRole = "Backendless.UserService.unassignRole"
        static let update = "Backendless.UserService.update"
    }
    
    private enum Args {
        static let identity = "identity"
        static let roleName = "roleName"
        static let id = "id"
        static let login = "login"
        static let password = "password"
        static let stayLoggedIn = "stayLoggedIn"
        static let user = "user"
        static let email = "email"
    }
    
    // MARK: -
    // MARK: - FileService Reference
    private let userService = SwiftBackendlessSdkPlugin.backendless.userService
    
    // MARK: -
    // MARK: - Route Flutter Call
    func routeFlutterCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments: [String: Any] = call.arguments.flatMap(cast) ?? [:]
        
        switch call.method {
        case Methods.assignRole:
            assignRole(arguments, result)
        case Methods.currentUser:
            currentUser(arguments, result)
        case Methods.describeUserClass:
            describeUserClass(arguments, result)
        case Methods.findById:
            findById(arguments, result)
        case Methods.getUserRoles:
            getUserRoles(arguments, result)
        case Methods.isValidLogin:
            isValidLogin(arguments, result)
        case Methods.loggedInUser:
            loggedInUser(arguments, result)
        case Methods.login:
            login(arguments, result)
        case Methods.logout:
            logout(arguments, result)
        case Methods.register:
            register(arguments, result)
        case Methods.resendEmailConfirmation:
            resendEmailConfirmation(arguments, result)
        case Methods.restorePassword:
            restorePassword(arguments, result)
        case Methods.unassignRole:
            unassignRole(arguments, result)
        case Methods.update:
            update(arguments, result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: -
    // MARK: - Assign Role
    private func assignRole(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Assign Role")
        
        guard
            let identity: String = arguments[Args.identity].flatMap(cast),
            let roleName: String = arguments[Args.roleName].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        // TODO: -
        // TODO: - No such method in SDK
        
        result(FlutterMethodNotImplemented)
    }
    
    // MARK: -
    // MARK: - Current user
    private func currentUser(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Current User")
        
        let currentUser = userService.getCurrentUser()
        
        result(currentUser)
    }
    
    // MARK: -
    // MARK: - Describe User Class
    private func describeUserClass(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Describe User Class")
        
        userService.describeUserClass(responseHandler: {
            result($0)
        }, errorHandler: {
            result(FlutterError($0))
        })
    }
    
    // MARK: -
    // MARK: - Find By ID
    private func findById(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Find By ID")
        
        guard let id: String = arguments[Args.id].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        Backendless.shared.data.of(BackendlessUser.self).findById(objectId: id,
            responseHandler: { response in
                guard let user = response as? BackendlessUser else {
                    result(FlutterError(code: "", message: "Incorrect Data Type from API", details: nil))
                    
                    return
                }
                result(user)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - Get User Roles
    private func getUserRoles(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Get User Roles")
        
        userService.getUserRoles(responseHandler: {
            result($0)
        }, errorHandler: {
            result(FlutterError($0))
        })
    }
    
    // MARK: -
    // MARK: - Is Valid Login
    private func isValidLogin(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Is Valid Login")
        
        userService.isValidUserToken(responseHandler: {
            result($0)
        }, errorHandler: {
            result(FlutterError($0))
        })
    }
    
    // MARK: -
    // MARK: - Logged In User
    private func loggedInUser(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Logged In User")
        
        guard let user = userService.getCurrentUser() else {
            result("")
            
            return
        }
        
        result(user.objectId)
    }
    
    // MARK: -
    // MARK: - Login
    private func login(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Login")
        
        guard
            let login: String = arguments[Args.login].flatMap(cast),
            let password: String = arguments[Args.password].flatMap(cast),
            let stayLoggedIn: Bool? = arguments[Args.stayLoggedIn].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        userService.login(identity: login, password: password,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
        
        stayLoggedIn.map { userService.stayLoggedIn = $0 }
    }
    
    // MARK: -
    // MARK: - Logout
    private func logout(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Logout")
        
        userService.logout(responseHandler: {
            result(nil)
        }, errorHandler: {
            result(FlutterError($0))
        })
    }
    
    // MARK: -
    // MARK: - Register
    private func register(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Register")
        
        guard let user: BackendlessUser = arguments[Args.user].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        userService.registerUser(user: user,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - Resend Email Confirmation
    private func resendEmailConfirmation(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Resend Email Confirmation")
        
        guard let email: String = arguments[Args.email].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        // TODO: -
        // TODO: - No such method in SDK
        
        result(FlutterMethodNotImplemented)
    }
    
    // MARK: -
    // MARK: - Restore Password
    private func restorePassword(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Restore Password")
        
        guard let identity: String = arguments[Args.identity].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        userService.restorePassword(identity: identity, responseHandler: {
            result(nil)
        }, errorHandler: {
            result(FlutterError($0))
        })
    }
    
    // MARK: -
    // MARK: - Unassign Role
    private func unassignRole(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Unassign Role")
        
        guard
            let identity: String = arguments[Args.identity].flatMap(cast),
            let roleName: String = arguments[Args.roleName].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        // TODO: -
        // TODO: - No such method in SDK
        
        result(FlutterMethodNotImplemented)
    }
    
    // MARK: -
    // MARK: - Update
    private func update(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Register")
        
        guard let user: BackendlessUser = arguments[Args.user].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        userService.update(user: user,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    
}
