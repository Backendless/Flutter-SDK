//
//  DeviceRegistrationResult.swift
//  backendless_sdk
//
//  Created by Andrii Bodnar on 6/24/19.
//

import Foundation

class DeviceRegistrationResult: Codable {
    
    let token: String
    let channelRegistrations: [String: String]
    
    init(token: String, planeString: String) {
        self.token = token
        
        channelRegistrations = [:]
    }
}
