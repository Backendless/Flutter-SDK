//
//  DeviceRegistrationResult.swift
//  backendless_sdk
//
//  Created by Andrii Bodnar on 6/24/19.
//

import Foundation

class DeviceRegistrationResult: Codable {
    
    let deviceToken: String
    let channelRegistrations: [String: String]
    
    init(token: String, planeString: String) {
        self.deviceToken = token
        
        var channelRegistrations: [String: String] = [:]
        let splitterString = planeString.components(separatedBy: ",")
        splitterString.forEach {
            let splittedReg = $0.components(separatedBy: "::")
            let key = splittedReg[0]
            let value = splittedReg[1]
            channelRegistrations[key] = value
        }
        
        self.channelRegistrations = channelRegistrations
    }
}
