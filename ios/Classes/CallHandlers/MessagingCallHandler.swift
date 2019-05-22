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
        static let refreshDeviceToken = "Backendless.Messaging.refreshDeviceToken"
        static let registerDevice = "Backendless.Messaging.registerDevice"
        static let sendEmail = "Backendless.Messaging.sendEmail"
        static let sendHTMLEmail = "Backendless.Messaging.sendHTMLEmail"
        static let sendTextEmail = "Backendless.Messaging.sendTextEmail"
        static let unregisterDevice = "Backendless.Messaging.unregisterDevice"
        static let join = "Backendless.Messaging.Channel.join"
        static let leave = "Backendless.Messaging.Channel.leave"
        static let isJoined = "Backendless.Messaging.Channel.isJoined"
        static let addMessageListener = "Backendless.Messaging.Channel.addMessageListener"
        
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
    }
    
    // MARK: -
    // MARK: - Messaging Reference
    private let messaging = SwiftBackendlessSdkPlugin.backendless.messaging
    
    // MARK: -
    // MARK: - Channels
    private var channels: [String: Channel] = [:]
    
    // MARK: -
    // MARK: - FlutterMessagingChannel
    private let messagingChannel: FlutterMethodChannel
    
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
            self.cancel(arguments, result)
        case Methods.getDeviceRegistration:
            self.getDeviceRegistration(arguments, result)
        case Methods.getMessageStatus:
            self.getMessageStatus(arguments, result)
        case Methods.publish:
            self.publish(arguments, result)
        case Methods.pushWithTemplate:
            self.pushWithTemplate(arguments, result)
        case Methods.refreshDeviceToken:
            self.refreshDeviceToken(arguments, result)
        case Methods.registerDevice:
            self.registerDevice(arguments, result)
        case Methods.sendEmail:
            self.sendEmail(arguments, result)
        case Methods.sendHTMLEmail:
            self.sendHTMLEmail(arguments, result)
        case Methods.sendTextEmail:
            self.sendTextEmail(arguments, result)
        case Methods.unregisterDevice:
            self.unregisterDevice(arguments, result)
        case Methods.join:
            self.join(arguments, result)
        case Methods.leave:
            self.leave(arguments, result)
        case Methods.isJoined:
            self.isJoined(arguments, result)
        case Methods.addMessageListener:
            self.addMessageListener(arguments, result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: -
    // MARK: - Cancel
    private func cancel(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Cancel")
        
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
    // MARK: - GetDeviceRegistration
    private func getDeviceRegistration(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Get Device Registration")
        
        messaging.getDeviceRegistrations(responseHandler: {
            result($0)
        }, errorHandler: {
            result(FlutterError($0))
        })
    }
    
    // MARK: -
    // MARK: - GetMessageStatus
    private func getMessageStatus(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Get Message Status")
        
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
    // MARK: - Publish
    private func publish(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Publish")
        
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
        print("~~~> Hello in Push With Template")
        
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
    // MARK: - RefreshDeviceToken
    private func refreshDeviceToken(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Refresh Device Token")
        
        // TODO: -
        // TODO: - RefreshDeviceToken not implemented in iOS SDK
        fatalError("RefreshDeviceToken not implemented in iOS SDK")
    }
    
    // MARK: -
    // MARK: - RegisterDevice
    private func registerDevice(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Register Device")
        
        // TODO: -
        // TODO: - Method without deviceToken in arguments will be added to SwiftSDK
        fatalError("Method without deviceToken in arguments will be added to SwiftSDK")
        
        let channels: [String]? = arguments[Args.channels].flatMap(cast)
        let expiration: Date? = arguments[Args.expiration].flatMap(cast)
        
        if let channels = channels {
            if let expiration = expiration {
                messaging.registerDevice(channels: channels, expiration: expiration,
                    responseHandler: {
                        // TODO: - Get string from SDK
                        // TODO: - Have to send DeviceRegistrationResult to Flutter
                        result($0)
                    },
                    errorHandler: {
                        result(FlutterError($0))
                    })
            } else {
                messaging.registerDevice(channels: channels, responseHandler: {
                    
                    result($0)
                }, errorHandler: {
                    result(FlutterError($0))
                })
            }
        } else {
            if let expiration = expiration {
                messaging.registerDevice(expiration: expiration,
                    responseHandler: {
                        // TODO: - Get string from SDK
                        // TODO: - Have to send DeviceRegistrationResult to Flutter
                        result($0)
                    },
                    errorHandler: {
                        result(FlutterError($0))
                    })
            } else {
                messaging.registerDevice(responseHandler: {
                    // TODO: - Get string from SDK
                    // TODO: - Have to send DeviceRegistrationResult to Flutter
                    result($0)
                }, errorHandler: {
                    result(FlutterError($0))
                })
            }
        }
        
        
        
        
        
        
        
        
    }
    
    // MARK: -
    // MARK: - SendEmail
    private func sendEmail(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Send Email")
        
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
        
        // TODO: -
        // TODO: - MessageStatus
        messaging.sendEmail(subject: subject, bodyparts: bodyParts, recipients: recipients, attachments: attachments,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - SendHTMLEmail
    private func sendHTMLEmail(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Send HTML Email")
        
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
        
        // TODO: -
        // TODO: - MessageStatus
        messaging.sendEmail(subject: subject, bodyparts: bodyParts, recipients: recipients, attachments: nil,
            responseHandler: {
                result($0)
            },
            errorHandler: {
                result(FlutterError($0))
            })
    }
    
    // MARK: -
    // MARK: - SendTextEmail
    private func sendTextEmail(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Send Text Email")
        
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
        
        // TODO: -
        // TODO: - MessageStatus
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
        print("~~~> Hello in Unregister Device")
        
        let channels: [String]? = arguments[Args.channels].flatMap(cast)
        
        if let channels = channels {
            // TODO: -
            // TODO: - No such method in iOS SDK
            fatalError("No such method in iOS ")
        } else {
            messaging.unregisterDevice(responseHandler: {
                result($0)
            }, errorHandler: {
                result(FlutterError($0))
            })
        }
    }
    
    // MARK: -
    // MARK: - Join
    private func join(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Join")
        
        guard let channelName: String = arguments[Args.channelName].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        if let existChannel = channels[channelName] {
            existChannel.join()
        } else {
            let newChannel = messaging.subscribe(channelName: channelName)
            channels[channelName] = newChannel
        }
        
        result(nil)
    }
    
    // MARK: -
    // MARK: - Leave
    private func leave(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Leave")
        
        guard let channelName: String = arguments[Args.channelName].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        channels[channelName]?.leave()
        
        result(nil)
    }
    
    // MARK: -
    // MARK: - IsJoined
    private func isJoined(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Is Joined")
        
        guard let channelName: String = arguments[Args.channelName].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        if let channel = channels[channelName] {
            result(channel.isJoined)
        } else {
            let error = FlutterError(code: "", message: "No such channel", details: nil)
            result(error)
        }
    }
    
    // MARK: -
    // MARK: - AddMessageListener
    private func addMessageListener(_ arguments: [String: Any], _ result: @escaping FlutterResult) {
        print("~~~> Hello in Add Message Listener")
        
        guard let channelName: String = arguments[Args.channelName].flatMap(cast) else {
            result(FlutterError.noRequiredArguments)
            
            return
        }
        
        if let channel = channels[channelName] {
            
            let responseHandler: (String) -> Void = { [weak self] (response) in
                guard let self = self else { return }
                
                var arguments: [String: Any] = [:]
                arguments[Args.handle] = 0
                arguments[Args.response] = response
                
                self.messagingChannel.invokeMethod(Methods.eventResponse, arguments: arguments)
            }
            
            // TODO: - Add listener
        }
    }
   
}

