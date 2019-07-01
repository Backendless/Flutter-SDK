//
//  FlutterError+CustomErrors.swift
//  Flutter-SDK
//
//  Created by Andrii Bodnar on 4/30/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import Foundation
import Flutter
import Backendless

extension FlutterError {
    
    /// Handle absence of required arguments
    static var noRequiredArguments: FlutterError {
        return FlutterError(code: "", message: "No required arguments", details: nil)
    }
    
    /// Initialize Flutter Error from Backendless Fault Type
    convenience init(_ fault: Fault) {
        self.init(code: "\(fault.code)", message: fault.message, details: fault.userInfo)
    }
}
