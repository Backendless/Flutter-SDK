//
//  UserStatusEnum.swift
//  backendless_sdk
//
//  Created by Andrii Bodnar on 6/25/19.
//

import Foundation

enum UserStatusEnum: String {
    case LISTING
    case CONNECTED
    case DISCONNECTED
    case USERUPDATE
    
    var index: Int {
        switch self {
        case .LISTING:
            return 0
        case .CONNECTED:
            return 1
        case .DISCONNECTED:
            return 2
        case .USERUPDATE:
            return 3
        }
    }
}
