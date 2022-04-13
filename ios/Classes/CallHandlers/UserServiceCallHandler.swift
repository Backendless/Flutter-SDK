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
        static let getCurrentUser = "Backendless.UserService.getCurrentUser"
        static let setCurrentUser = "Backendless.UserService.setCurrentUser"
        static let describeUserClass = "Backendless.UserService.describeUserClass"
        static let findById = "Backendless.UserService.findById"
        static let findByRole = "Backendless.UserService.findByRole"
        static let getUserRoles = "Backendless.UserService.getUserRoles"
        static let isValidLogin = "Backendless.UserService.isValidLogin"
        static let loggedInUser = "Backendless.UserService.loggedInUser"
        static let login = "Backendless.UserService.login"
        static let logout = "Backendless.UserService.logout"
        static let register = "Backendless.UserService.register"
        static let resendEmailConfirmation = "Backendless.UserService.resendEmailConfirmation"
        static let createEmailConfirmationURL = "Backendless.UserService.createEmailConfirmationURL"
        static let restorePassword = "Backendless.UserService.restorePassword"
        static let update = "Backendless.UserService.update"
        static let setUserToken = "Backendless.UserService.setUserToken"
        static let getUserToken = "Backendless.UserService.getUserToken"
        static let loginAsGuest = "Backendless.UserService.loginAsGuest"
        static let loginWithFacebook = "Backendless.UserService.loginWithFacebook"
        static let loginWithTwitter = "Backendless.UserService.loginWithTwitter"
        static let loginWithGoogle = "Backendless.UserService.loginWithGoogle"
        static let loginWithOauth1 = "Backendless.UserService.loginWithOauth1"
        static let loginWithOauth2 = "Backendless.UserService.loginWithOauth2"
        static let getAuthorizationUrlLink = "Backendless.UserService.getAuthorizationUrlLink";
    }
    
    private enum Args {
        static let identity = "identity"
        static let id = "id"
        static let login = "login"
        static let password = "password"
        static let stayLoggedIn = "stayLoggedIn"
        static let user = "user"
        static let email = "email"
        static let userToken = "userToken"
        static let accessToken = "accessToken"
        static let fieldsMappings = "fieldsMappings"
        static let authToken = "authToken"
        static let authTokenSecret = "authTokenSecret"
        static let guestUser = "guestUser"
        static let authProviderCode = "authProviderCode"
        static let currentUser = "currentUser"
        static let roleName = "roleName"
        static let queryBuilder = "queryBuilder"
        static let loadRoles = "loadRoles"
        static let scope = "scope";
    }
    
    // MARK: -
    // MARK: - FileService Reference
    private let userService = SwiftBackendlessSdkPlugin.backendless.userService
    
    // MARK: -
    // MARK: - Route Flutter Call
    func routeFlutterCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments: [String: Any] = call.arguments.flatMap(cast) ?? [:]
        
        switch call.method {
        case Methods.getCurrentUser:
            getCurrentUser(arguments, result)
        case Methods.setCurrentUser:
            setCurrentUser(arguments, result)
        case Methods.describeUserClass:
            describeUserClass(arguments, result)
        case Methods.findById:
            findById(arguments, result)
        case Methods.findByRole:
            findByRole(arguments, result )
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
        case Methods.createEmailConfirmationURL:
            createEmailConfirmationURL(arguments, result)
        case Methods.restorePassword:
            restorePassword(arguments, result)
        case Methods.update:
            update(arguments, result)
        case Methods.setUserToken:
            setUserToken(arguments, result)
        case Methods.getUserToken:
            getUserToken(arguments, result)
        case Methods.loginAsGuest:
            loginAsGuest(arguments, result)
        case Methods.loginWithOauth1:
            loginWithOauth1(arguments, result)
        case Methods.loginWithOauth2:
            loginWithOauth2(arguments, result)
        case Methods.getAuthorizationUrlLink:
            getAuthorizationUrlLink(arguments, result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: -
    // MARK: - Get current user
    private func getCurrentUser(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        let currentUser = userService.currentUser
        
        result(currentUser)
    }
    
    // MARK: -
    // MARK: - Set current user
    private func setCurrentUser(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let currentUser: BackendlessUser = arguments[Args.currentUser].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        userService.currentUser = currentUser
        let stayLoggedIn: Bool = (arguments[Args.stayLoggedIn].flatMap(cast) != nil);
        
        Backendless.shared.userService.stayLoggedIn = stayLoggedIn;
        result(nil)
    }
    
    // MARK: -
    // MARK: - Describe User Class
    private func describeUserClass(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        userService.describeUserClass(responseHandler: {
            result($0)
        }, errorHandler: {
            result(FlutterError($0))
        })
    }
    
    // MARK: -
    // MARK: - Find By ID
    private func findById(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let id: String = arguments[Args.id].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        Backendless.shared.data.of(BackendlessUser.self)
            .findById(objectId: id,
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
     // MARK: - Find by Role
     private func findByRole(_ arguments:[String: Any], _ result: @escaping FlutterResult){
        guard
            let roleName: String = arguments[Args.roleName].flatMap(cast)
        else {
          result(FlutterError.noRequiredArguments)

          return
        }
        let loadRoles: Bool = arguments[Args.loadRoles].flatMap(cast) ?? false
        let queryBuilder: DataQueryBuilder = arguments[Args.queryBuilder].flatMap(cast) ?? DataQueryBuilder()

        userService.findByRole( roleName: roleName, loadRoles: loadRoles, queryBuilder: queryBuilder,
         responseHandler: {
            result($0)
         },
         errorHandler: {
            result(FlutterError($0))
         })
     }

    // MARK: -
    // MARK: - Get User Roles
    private func getUserRoles(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        userService.getUserRoles(responseHandler: {
            result($0)
        }, errorHandler: {
            result(FlutterError($0))
        })
    }
    
    // MARK: -
    // MARK: - Is Valid Login
    private func isValidLogin(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        userService.isValidUserToken(responseHandler: {
            result($0)
        }, errorHandler: {
            result(FlutterError($0))
        })
    }
    
    // MARK: -
    // MARK: - Logged In User
    private func loggedInUser(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let user = userService.currentUser else {
            result("")
            
            return
        }
        
        result(user.objectId)
    }
    
    // MARK: -
    // MARK: - Login
    private func login(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard
            let login: String = arguments[Args.login].flatMap(cast),
            let password: String = arguments[Args.password].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        let stayLoggedIn = arguments[Args.stayLoggedIn].flatMap(cast) ?? false
        userService.stayLoggedIn = stayLoggedIn
        
        userService.login(identity: login, password: password,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - Logout
    private func logout(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        userService.logout(responseHandler: {
            result(nil)
        }, errorHandler: {
            result(FlutterError($0))
        })
    }
    
    // MARK: -
    // MARK: - Register
    private func register(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let user: BackendlessUser = arguments[Args.user].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        Locale.current.languageCode.map { user.setLocale(languageCode: $0) }

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
        guard let identity: String = arguments[Args.identity].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        userService.resendEmailConfirmation(identity: identity,
            responseHandler: {
                result(nil)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - Create Email Confirmation URL
    private func createEmailConfirmationURL(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let identity: String = arguments[Args.identity].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)

            return
        }
        
        userService.createEmailConfirmation(identity: identity,
            responseHandler: {
                result($0["confirmationURL"])
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - Restore Password
    private func restorePassword(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
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
    // MARK: - Update
    private func update(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
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
    
    // MARK: -
    // MARK: - Set User Token
    private func setUserToken(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let userToken: String = arguments[Args.userToken].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        userService.setUserToken(value: userToken)
        result(nil)
    }
    
    // MARK: -
    // MARK: - Get User Token
    private func getUserToken(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        let userToken = userService.getUserToken()
        
        result(userToken)
    }

    // MARK: -
    // MARK: - Login As Guest
    private func loginAsGuest(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        let stayLoggedIn: Bool? = arguments[Args.stayLoggedIn].flatMap(cast)

        if let stayLoggedIn = stayLoggedIn {
            userService.loginAsGuest(stayLoggedIn: stayLoggedIn,
                responseHandler: {
                    result($0)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
        } else {
            userService.loginAsGuest(responseHandler: {
                result($0)
            }, errorHandler: {
                result(FlutterError($0))
            })
        }
    }
    
    private func loginWithOauth1(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard
            let authProviderCode: String = arguments[Args.authProviderCode].flatMap(cast),
            let authToken: String = arguments[Args.authToken].flatMap(cast),
            let authTokenSecret: String = arguments[Args.authTokenSecret].flatMap(cast),
            let fieldsMappings: [String: String] = arguments[Args.fieldsMappings].flatMap(cast),
            let stayLoggedIn: Bool = arguments[Args.stayLoggedIn].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        let guestUser: BackendlessUser? = arguments[Args.guestUser].flatMap(cast)
        
        
        if let guestUser = guestUser {
            userService.loginWithOauth1(providerCode: authProviderCode, authToken: authToken, authTokenSecret: authTokenSecret, guestUser: guestUser, fieldsMapping: fieldsMappings, stayLoggedIn: stayLoggedIn, responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
        } else {
            userService.loginWithOauth1(providerCode: authProviderCode, authToken: authToken, tokenSecret: authTokenSecret, fieldsMapping: fieldsMappings, stayLoggedIn: stayLoggedIn, responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
        }
    }
    
    private func loginWithOauth2(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard
            let authProviderCode: String = arguments[Args.authProviderCode].flatMap(cast),
            let accessToken: String = arguments[Args.accessToken].flatMap(cast),
            let fieldsMappings: [String: String] = arguments[Args.fieldsMappings].flatMap(cast),
            let stayLoggedIn: Bool = arguments[Args.stayLoggedIn].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        let guestUser: BackendlessUser? = arguments[Args.guestUser].flatMap(cast)
        
        
        if let guestUser = guestUser {
            userService.loginWithOauth2(providerCode: authProviderCode, accessToken: accessToken, guestUser: guestUser, fieldsMapping: fieldsMappings, stayLoggedIn: stayLoggedIn, responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
        } else {
            userService.loginWithOauth2(providerCode: authProviderCode, accessToken: accessToken, fieldsMapping: fieldsMappings, stayLoggedIn: stayLoggedIn, responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
        }
    }

    private func getAuthorizationUrlLink(_ arguments: [String : Any], _ result: @escaping FlutterResult) {
        guard
            let authProviderCode: String = arguments[Args.authProviderCode].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)

            return
        }

        let fieldsMappings: [String: String]? = arguments[Args.fieldsMappings].flatMap(cast)
        
        let scope: [String]? = arguments[Args.scope].flatMap(cast)

        if fieldsMappings != nil && scope != nil {
            userService.getAuthorizationUrlLink(providerCode: authProviderCode, fieldsMappings: fieldsMappings!, scope: scope!, responseHandler: {
                result($0)
            },
                                                errorHandler: {
                result(FlutterError($0))
            })
        } else {
            if fieldsMappings != nil {
                userService.getAuthorizationUrlLink(providerCode: authProviderCode, fieldsMappings: fieldsMappings!, responseHandler: {
                    result($0)
                },
                                                    errorHandler: {
                    result(FlutterError($0))
                })
            } else {
                if scope != nil {
                    userService.getAuthorizationUrlLink(providerCode: authProviderCode, scope: scope!, responseHandler: {
                        result($0)
                    },
                                                        errorHandler: {
                        result(FlutterError($0))
                    })
                } else {
                    userService.getAuthorizationUrlLink(providerCode: authProviderCode, responseHandler: {
                        result($0)
                    },
                    errorHandler: {
                        result(FlutterError($0))
                    })
                }
            }
        }
    }
}
