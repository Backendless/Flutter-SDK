//
//  DataTypeEnum+Index.swift
//  backendless_sdk
//
//  Created by Andrii Bodnar on 6/19/19.
//

import Foundation
import Backendless

extension DataTypeEnum {
    var index: Int {
        switch self {
        case .UNKNOWN:
            return 0
        case .INT:
            return 1
        case .STRING:
            return 2
        case .BOOLEAN:
            return 3
        case .DATETIME:
            return 4
        case .DOUBLE:
            return 5
        case .RELATION:
            return 6
        case .COLLECTION:
            return 7
        case .RELATION_LIST:
            return 8
        case .STRING_ID:
            return 9
        case .TEXT:
            return 10
        }
    }
}
