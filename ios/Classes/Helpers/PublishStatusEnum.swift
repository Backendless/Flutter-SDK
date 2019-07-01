//
//  PublishStatusEnum.swift
//  backendless_sdk
//
//  Created by Andrii Bodnar on 6/19/19.
//

import Foundation

enum PublishStatusEnum: String {
    case failed
    case published
    case scheduled
    case cancelled
    case unknown
    
    var index: Int {
        switch self {
        case .failed:
            return 0
        case .published:
            return 1
        case .scheduled:
            return 2
        case .cancelled:
            return 3
        case .unknown:
            return 4
        }
    }
}
