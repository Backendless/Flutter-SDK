//
//  Functions.swift
//  Flutter-SDK
//
//  Created by Andrii Bodnar on 4/26/19.
//  Copyright © 2019 Andrii Bodnar. All rights reserved.
//

import Foundation

public func cast<Value, Result>(_ value: Value) -> Result? {
    return value as? Result
}
