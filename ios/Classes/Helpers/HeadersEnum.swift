//
//  HeadersEnum.swift
//  backendless_sdk
//
//  Created by Andrii Bodnar on 8/14/19.
//

import Foundation

enum HeadersEnum: String, CaseIterable {
    case userToken = "user-token"
    case loggedIn = "logged-in"
    case sessionTimeout = "session-time-out"
    case appTypeName = "application-type"
    case apiVersion = "api-version"
    case uiState = "uiState"
    
    init?(index: Int) {
        if HeadersEnum.allCases.indices.contains(index) {
            self = HeadersEnum.allCases[index]
        } else {
            return nil
        }
    }
}
