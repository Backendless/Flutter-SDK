//
//  MessagingCallHandler.swift
//  BackendlessSwiftPlugin
//
//  Created by Andrii Bodnar on 5/2/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import Foundation
import Flutter
import Backendless

class MessagingCallHandler: FlutterCallHandlerProtocol {
    
    // MARK: -
    // MARK: - Constants
    private enum Methods {
        static let cancel = "Backendless.Messaging.cancel"
        static let getDeviceRegistration = "Backendless.Messaging.getDeviceRegistration"
        static let getMessageStatus = "Backendless.Messaging.getMessageStatus"
        static let publish = "Backendless.Messaging.publish"
        static let pushWithTemplate = "Backendless.Messaging.pushWithTemplate"
        static let registerDevice = "Backendless.Messaging.registerDevice"
        static let sendEmail = "Backendless.Messaging.sendEmail"
        static let sendHTMLEmail = "Backendless.Messaging.sendHTMLEmail"
        static let sendTextEmail = "Backendless.Messaging.sendTextEmail"
        static let unregisterDevice = "Backendless.Messaging.unregisterDevice"
        static let subscribe = "Backendless.Messaging.subscribe"
        static let join = "Backendless.Messaging.Channel.join"
        static let leave = "Backendless.Messaging.Channel.leave"
        static let isJoined = "Backendless.Messaging.Channel.isJoined"
        static let addJoinListener = "Backendless.Messaging.Channel.addJoinListener"
        static let removeJoinListener = "Backendless.Messaging.Channel.removeMessageListener"
        static let addMessageListener = "Backendless.Messaging.Channel.addMessageListener"
        static let removeMessageListener = "Backendless.Messaging.Channel.removeMessageListener"
        static let removeAllMessageListeners = "Backendless.Messaging.Channel.removeAllMessageListeners"
        static let addCommandListener = "Backendless.Messaging.Channel.addCommandListener"
        static let removeCommandListener = "Backendless.Messaging.Channel.removeCommandListener"
        static let sendCommand = "Backendless.Messaging.Channel.sendCommand"
        static let addUserStatusListener = "Backendless.Messaging.Channel.addUserStatusListener"
        static let removeUserStatusListener = "Backendless.Messaging.Channel.removeUserStatusListener"
        static let removeUserStatusListeners = "Backendless.Messaging.Channel.removeUserStatusListeners"
        
        static let eventResponse = "Backendless.Messaging.Channel.EventResponse"
    }
    
    private enum Args {
        static let messageId = "messageId"
        static let message = "message"
        static let channelName = "channelName"
        static let publishOptions = "publishOptions"
        static let deliveryOptions = "deliveryOptions"
        static let templateName = "templateName"
        static let subject = "subject"
        static let recipients = "recipients"
        static let textMessage = "textMessage"
        static let htmlMessage = "htmlMessage"
        static let attachments = "attachments"
        static let messageBody = "messageBody"
        static let channels = "channels"
        static let handle = "handle"
        static let response = "response"
        static let expiration = "expiration"
        static let channelHandle = "channelHandle"
        static let selector = "selector"
        static let messageType = "messageType"
        static let type = "type"
        static let data = "data"
    }
    
    private enum MessageTypes {
        static let string = "String"
        static let info = "PublishMessageInfo"
    }
    
    // MARK: -
    // MARK: - Messaging Reference
    private let messaging = SwiftBackendlessSdkPlugin.backendless.messaging
    
    // MARK: -
    // MARK: - Channels
    private var channels: [Int: Channel] = [:]
    
    // MARK: -
    // MARK: - FlutterMessagingChannel
    private let messagingChannel: FlutterMethodChannel
    
    // MARK: -
    // MARK: -
    private var nextJoinHandle = 0
    private var joinSubscriptions: [Int: RTSubscription] = [:]
    
    private var nextMessageHandle = 0
    private var messageSubscriptions: [Int: RTSubscription] = [:]
    
    private var nextCommandHandle = 0
    private var commandSubscriptions: [Int: RTSubscription] = [:]
    
    private var nextUserStatusHandle = 0
    private var userStatusSubscriptions: [Int: RTSubscription] = [:]
    
    // MARK: -
    // MARK: - Init
    init(messagingChannel: FlutterMethodChannel) {
        self.messagingChannel = messagingChannel
    }
    
    // MARK: -
    // MARK: - Route Flutter Call
    func routeFlutterCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments: [String: Any] = call.arguments.flatMap(cast) ?? [:]
        
        switch call.method {
        case Methods.cancel:
            cancel(arguments, result)
        case Methods.getDeviceRegistration:
            getDeviceRegistration(arguments, result)
        case Methods.getMessageStatus:
            getMessageStatus(arguments, result)
        case Methods.publish:
            publish(arguments, result)
        case Methods.pushWithTemplate:
            pushWithTemplate(arguments, result)
        case Methods.registerDevice:
            registerDevice(arguments, result)
        case Methods.sendEmail:
            sendEmail(arguments, result)
        case Methods.sendHTMLEmail:
            sendHTMLEmail(arguments, result)
        case Methods.sendTextEmail:
            sendTextEmail(arguments, result)
        case Methods.unregisterDevice:
            unregisterDevice(arguments, result)
        case Methods.subscribe:
            subscribe(arguments, result)
        case Methods.join:
            join(arguments, result)
        case Methods.leave:
            leave(arguments, result)
        case Methods.isJoined:
            isJoined(arguments, result)
        case Methods.addJoinListener:
            addJoinListener(arguments, result)
        case Methods.removeJoinListener:
            removeJoinListener(arguments, result)
        case Methods.addMessageListener:
            addMessageListener(arguments, result)
        case Methods.removeMessageListener:
            removeMessageListener(arguments, result)
        case Methods.removeAllMessageListeners:
            removeAllMessageListeners(arguments, result)
        case Methods.addCommandListener:
            addCommandListener(arguments, result)
        case Methods.removeCommandListener:
            removeCommandListener(arguments, result)
        case Methods.sendCommand:
            sendCommand(arguments, result)
        case Methods.addUserStatusListener:
            addUserStatusListener(arguments, result)
        case Methods.removeUserStatusListener:
            removeUserStatusListener(arguments, result)
        case Methods.removeUserStatusListeners:
            removeUserStatusListeners(arguments, result)
        
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: -
    // MARK: - Cancel +-
    private func cancel(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        
        // TODO: -
        // TODO: - Problem with sending MessageStatus to Flutter
        
        guard let messageId: String = arguments[Args.messageId].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        messaging.cancelScheduledMessage(messageId: messageId,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - GetDeviceRegistration ++
    private func getDeviceRegistration(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        messaging.getDeviceRegistrations(responseHandler: {
            result($0)
        }, errorHandler: {
            result(FlutterError($0))
        })
    }
    
    // MARK: -
    // MARK: - GetMessageStatus ++
    private func getMessageStatus(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let messageId: String = arguments[Args.messageId].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        messaging.getMessageStatus(messageId: messageId,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - Publish +-
    private func publish(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        
        // TODO: -
        // TODO: - Problem with sending MessageStatus to Flutter
        
        guard
            let channelName: String = arguments[Args.channelName].flatMap(cast),
            let message = arguments[Args.message]
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        let publishOptions: PublishOptions? = arguments[Args.publishOptions].flatMap(cast)
        let deliveryOptions: DeliveryOptions? = arguments[Args.deliveryOptions].flatMap(cast)
        
        if let publishOptions = publishOptions {
            if let deliveryOptions = deliveryOptions {
                messaging.publish(channelName: channelName, message: message, publishOptions: publishOptions, deliveryOptions: deliveryOptions,
                    responseHandler: {
                        result($0)
                    },
                    errorHandler: {
                        result(FlutterError($0))
                    })
            } else {
                messaging.publish(channelName: channelName, message: message, publishOptions: publishOptions,
                    responseHandler: {
                        result($0)
                    },
                    errorHandler: {
                        result(FlutterError($0))
                    })
            }
        } else {
            if let deliveryOptions = deliveryOptions {
                messaging.publish(channelName: channelName, message: message, deliveryOptions: deliveryOptions,
                    responseHandler: {
                        result($0)
                    },
                    errorHandler: {
                        result(FlutterError($0))
                    })
            } else {
                messaging.publish(channelName: channelName, message: message,
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
    // MARK: - PushWithTemplate
    private func pushWithTemplate(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let template: String = arguments[Args.templateName].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        messaging.pushWithTemplate(templateName: template,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - RegisterDevice
    private func registerDevice(_ arguments: [String: Any], _ result: @escaping FlutterResult) {

        // TODO: -
        // TODO: - Method without deviceToken in arguments will be added to SwiftSDK
        fatalError("Method without deviceToken in arguments will be added to SwiftSDK")
        
    }
    
    // MARK: -
    // MARK: - SendEmail ++
    private func sendEmail(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard
            let recipients: [String] = arguments[Args.recipients].flatMap(cast),
            let subject: String = arguments[Args.subject].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        let bodyParts = EmailBodyparts()
        bodyParts.textMessage = arguments[Args.textMessage].flatMap(cast)
        bodyParts.htmlMessage = arguments[Args.htmlMessage].flatMap(cast)
        
        let attachments: [String]? = arguments[Args.attachments].flatMap(cast)
        
        messaging.sendEmail(subject: subject, bodyparts: bodyParts, recipients: recipients, attachments: attachments,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - SendHTMLEmail ++
    private func sendHTMLEmail(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard
            let recipients: [String] = arguments[Args.recipients].flatMap(cast),
            let subject: String = arguments[Args.subject].flatMap(cast),
            let messageBody: String = arguments[Args.messageBody].flatMap(cast)
        else {
                result(FlutterError.noRequiredArguments)
                
                return
        }
        
        let bodyParts = EmailBodyparts()
        bodyParts.htmlMessage = messageBody
        
        messaging.sendEmail(subject: subject, bodyparts: bodyParts, recipients: recipients, attachments: nil,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - SendTextEmail ++
    private func sendTextEmail(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard
            let recipients: [String] = arguments[Args.recipients].flatMap(cast),
            let subject: String = arguments[Args.subject].flatMap(cast),
            let messageBody: String = arguments[Args.messageBody].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        let bodyParts = EmailBodyparts()
        bodyParts.textMessage = messageBody
        
        messaging.sendEmail(subject: subject, bodyparts: bodyParts, recipients: recipients, attachments: nil,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - UnregisterDevice
    private func unregisterDevice(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        let channels: [String]? = arguments[Args.channels].flatMap(cast)
        
        if let channels = channels {
            messaging.unregisterDevice(channels: channels,
                responseHandler: {
                    result($0 ? channels.count : 0)
                },
                errorHandler: {
                    result(FlutterError($0))
                })
        } else {
            messaging.unregisterDevice(responseHandler: {
                result($0 ? 1 : 0)
            }, errorHandler: {
                result(FlutterError($0))
            })
        }
    }
    
    // MARK: -
    // MARK: - Subscribe ++
    private func subscribe(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard
            let channelName: String = arguments[Args.channelName].flatMap(cast),
            let channelHandle: Int = arguments[Args.channelHandle].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        let channel = messaging.subscribe(channelName: channelName)
        channels[channelHandle] = channel
        
        result(nil)
    }
    
    // MARK: -
    // MARK: - Join ++
    private func join(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let channelHandle: Int = arguments[Args.channelHandle].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        channels[channelHandle]?.join()
        
        result(nil)
    }
    
    // MARK: -
    // MARK: - Leave ++
    private func leave(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let channelHandle: Int = arguments[Args.channelHandle].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        channels[channelHandle]?.leave()
        
        result(nil)
    }
    
    // MARK: -
    // MARK: - IsJoined ++
    private func isJoined(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let channelHandle: Int = arguments[Args.channelHandle].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        if let channel = channels[channelHandle] {
            result(channel.isJoined)
        }
        
        result(false)
    }
    
    // MARK: -
    // MARK: - AddJoinListener
    private func addJoinListener(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let channelHandle: Int = arguments[Args.channelHandle].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        let currentJoinHandle = nextJoinHandle
        nextJoinHandle += 1
        
        let subscription = channels[channelHandle]?.addConnectListener(responseHandler: { [weak self] in
            var callbackArgs: [String: Any] = [:]
            callbackArgs["handle"] = currentJoinHandle
            self?.messagingChannel.invokeMethod("Backendless.Messaging.Channel.Join.EventResponse", arguments: callbackArgs)
        }, errorHandler: {
            result(FlutterError($0))
        })
        
        if let newSubscription = subscription {
            joinSubscriptions[currentJoinHandle] = newSubscription
            result(currentJoinHandle)
        } else {
            result(nil)
        }
    }
    
    
    // MARK: -
    // MARK: - RemoveJoinListener
    private func removeJoinListener(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let channelHandle: Int = arguments[Args.channelHandle].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        joinSubscriptions[channelHandle]?.stop()
        joinSubscriptions.removeValue(forKey: channelHandle)
    }
    
    // MARK: -
    // MARK: - AddMessageListener
    private func addMessageListener(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard
            let channelHandle: Int = arguments[Args.channelHandle].flatMap(cast),
            let messageType: String = arguments[Args.messageType].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        let selector: String? = arguments[Args.selector].flatMap(cast)
        
        let currentMessageHandle = nextMessageHandle
        nextMessageHandle += 1
        
        var subscription: RTSubscription?
        
        let successHandler: (Any) -> Void = { [weak self] (response) in
            let callbackArgs: [String: Any] = [
                "handle": currentMessageHandle,
                "response": response
            ]
            
            self?.messagingChannel.invokeMethod("Backendless.Messaging.Channel.Message.EventResponse", arguments: callbackArgs)
        }
        
        let errorHandler: (Fault) -> Void = { [weak self] (fault) in
            let callbackArgs: [String: Any] = [
                "handle": currentMessageHandle,
                "fault": fault.message ?? ""
            ]
            self?.messagingChannel.invokeMethod("Backendless.Messaging.Channel.Message.EventFault", arguments: callbackArgs)
        }
        
        switch messageType {
        case MessageTypes.string:
            if let selector = selector {
                subscription = channels[channelHandle]?.addStringMessageListener(selector: selector, responseHandler: successHandler, errorHandler: errorHandler)
            } else {
                subscription = channels[channelHandle]?.addStringMessageListener(responseHandler: successHandler, errorHandler: errorHandler)
            }
        case MessageTypes.info:
            if let selector = selector {
                subscription = channels[channelHandle]?.addMessageListener(selector: selector, responseHandler: successHandler, errorHandler: errorHandler)
            } else {
                subscription = channels[channelHandle]?.addMessageListener(responseHandler: successHandler, errorHandler: errorHandler)
            }
        default:
            result(nil)
            return
        }
        
        if let newSubscription = subscription {
            messageSubscriptions[currentMessageHandle] = newSubscription
            result(currentMessageHandle)
        } else {
            result(nil)
        }
    }
    
    // MARK: -
    // MARK: - RemoveMessageListener
    private func removeMessageListener(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let channelHandle: Int = arguments[Args.channelHandle].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        messageSubscriptions[channelHandle]?.stop()
        messageSubscriptions.removeValue(forKey: channelHandle)
    }
    
    // MARK: -
    // MARK: - RemoveAllMessageListeners
    private func removeAllMessageListeners(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        
        // TODO: -
        // TODO: - Updated Flutter implementation will handle listener filtering
        result(FlutterMethodNotImplemented)
    }
    
    // MARK: -
    // MARK: - AddCommandListener
    private func addCommandListener(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let channelHandle: Int = arguments[Args.channelHandle].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        let currentCommandHandle = nextCommandHandle
        nextCommandHandle += 1
        
        let successHandler: (CommandObject) -> Void = { [weak self] (command) in
            let callbackArgs: [String: Any] = [
                "handle": currentCommandHandle,
                "response": command
            ]
            self?.messagingChannel.invokeMethod("Backendless.Messaging.Channel.Command.EventResponse", arguments: callbackArgs)
        }
        
        let errorHandler: (Fault) -> Void = { [weak self] (fault) in
            let callbackArgs: [String: Any] = [
                "handle": currentCommandHandle,
                "fault": fault.message ?? ""
            ]
            self?.messagingChannel.invokeMethod("Backendless.Messaging.Channel.Command.EventFault", arguments: callbackArgs)
        }
        
        let subscription = channels[channelHandle]?.addCommandListener(responseHandler: successHandler, errorHandler: errorHandler)
        
        if let newSubscription = subscription {
            commandSubscriptions[currentCommandHandle] = newSubscription
            result(currentCommandHandle)
        } else {
            result(nil)
        }
    }
    
    // MARK: -
    // MARK: - RemoveCommandListener
    private func removeCommandListener(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let channelHandle: Int = arguments[Args.channelHandle].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        commandSubscriptions[channelHandle]?.stop()
        commandSubscriptions.removeValue(forKey: channelHandle)
    }
    
    // MARK: -
    // MARK: - SendCommand
    private func sendCommand(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard
            let channelHandle: Int = arguments[Args.channelHandle].flatMap(cast),
            let commandType: String = arguments[Args.type].flatMap(cast)
        else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        guard let channelName = channels[channelHandle]?.channelName else {
            result(FlutterError(code: "", message: "No such channeld", details: nil))
            
            return
        }
        
        messaging.sendCommand(commandType: commandType, channelName: channelName, data: arguments[Args.data],
            responseHandler: {
                result(nil)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - AddUserStatusListener
    private func addUserStatusListener(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let channelHandle: Int = arguments[Args.channelHandle].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        let currentUserStatusHandle = nextUserStatusHandle
        nextUserStatusHandle += 1
        
        let successHandler: (UserStatus) -> Void = { [weak self] (status) in
            let callbackArgs: [String: Any] = [
                "handle": currentUserStatusHandle,
                "response": status
            ]
            self?.messagingChannel.invokeMethod("Backendless.Messaging.Channel.UserStatus.EventResponse", arguments: callbackArgs)
        }
        
        let errorHandler: (Fault) -> Void = { [weak self] (fault) in
            let callbackArgs: [String: Any] = [
                "handle": currentUserStatusHandle,
                "fault": fault.message ?? ""
            ]
            self?.messagingChannel.invokeMethod("Backendless.Messaging.Channel.UserStatus.EventFault", arguments: callbackArgs)
        }
        
        let subscription = channels[channelHandle]?.addUserStatusListener(responseHandler: successHandler, errorHandler: errorHandler)
        
        if let newSubscription = subscription {
            userStatusSubscriptions[currentUserStatusHandle] = newSubscription
            result(currentUserStatusHandle)
        } else {
            result(nil)
        }
    }
    
    // MARK: -
    // MARK: - RemoveUserStatusListener
    private func removeUserStatusListener(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        guard let channelHandle: Int = arguments[Args.channelHandle].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        userStatusSubscriptions[channelHandle]?.stop()
        userStatusSubscriptions.removeValue(forKey: channelHandle)
    }
    
    // MARK: -
    // MARK: - RemoveUserStatusListeners
    private func removeUserStatusListeners(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        
        // TODO: -
        // TODO: - Updated Flutter implementation will handle listener filtering
        result(FlutterMethodNotImplemented)
    }
    
    
   
}

