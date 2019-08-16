//
//  HeadersEnum.swift
//  backendless_sdk
//
//  Created by Andrii Bodnar on 8/14/19.
//

import Foundation

enum HeadersEnum: String, CaseIterable {
    case userToken = "USER_TOKEN_KEY"
    case loggedIn = "LOGGED_IN_KEY"
    case sessionTimeout = "SESSION_TIME_OUT_KEY"
    case appTypeName = "APP_TYPE_NAME"
    case apiVersion = "API_VERSION"
    case uiState = "UI_STATE"
    
    init?(index: Int) {
        if HeadersEnum.allCases.indices.contains(index) {
            self = HeadersEnum.allCases[index]
        } else {
            return nil
        }
    }
}
