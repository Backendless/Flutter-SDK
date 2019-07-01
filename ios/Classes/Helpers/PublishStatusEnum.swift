//
//  PublishStatusEnum.swift
//  backendless_sdk
//
//  Created by Andrii Bodnar on 6/19/19.
//

import Foundation

enum PublishStatusEnum: String {
    case FAILED
    case PUBLISHED
    case SCHEDULED
    case CANCELLED
    case UNKNOWN
    
    var index: Int {
        switch self {
        case .FAILED:
            return 0
        case .PUBLISHED:
            return 1
        case .SCHEDULED:
            return 2
        case .CANCELLED:
            return 3
        case .UNKNOWN:
            return 4
        }
    }
}
