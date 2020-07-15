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

//MARK: LocalizedError
extension AuthError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emptyFields:
            return NSLocalizedString(Constants.Errors.emptyFieldsError, comment: "Empty Fields Error")
        case .invalidEmail:
            return NSLocalizedString(Constants.Errors.invalidEmailError, comment: "Invalid Email Error")
        case .insecurePassword:
            return NSLocalizedString(Constants.Errors.insecurePasswordError, comment: "Insecure Password Error")
        case .signOut:
            return NSLocalizedString(Constants.Errors.signOutError, comment: "Sign Out Error")
        case .signIn:
            return NSLocalizedString(Constants.Errors.signInError, comment: "Sign In Error")
        case .user:
            return NSLocalizedString(Constants.Errors.userError, comment: "User Error")
        case .unknown:
            return NSLocalizedString(Constants.Errors.unknown, comment: "Unknown Error")
        }
    }
}
