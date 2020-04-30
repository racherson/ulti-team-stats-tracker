//
//  AuthError.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/30/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

enum AuthError: Error {
    case emptyFields
    case invalidEmail
    case insecurePassword
    case signOut
    case signIn
    case unknown
    case user
}

extension AuthError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emptyFields:
            return Constants.Errors.emptyFieldsError
        case .invalidEmail:
            return Constants.Errors.invalidEmailError
        case .insecurePassword:
            return Constants.Errors.insecurePasswordError
        case .signOut:
            return Constants.Errors.signOutError
        case .signIn:
            return Constants.Errors.signInError
        case .user:
            return Constants.Errors.userError
        case .unknown:
            return Constants.Errors.unknown
        }
    }
}
