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

//MARK: LocalizedError, CustomStringConvertible
extension AuthError: LocalizedError, CustomStringConvertible {
    public var description: String {
        switch self {
        case .emptyFields:
            return getLocalizedString(Constants.Errors.emptyFieldsError)
        case .invalidEmail:
            return getLocalizedString(Constants.Errors.invalidEmailError)
        case .insecurePassword:
            return getLocalizedString(Constants.Errors.insecurePasswordError)
        case .signOut:
            return getLocalizedString(Constants.Errors.signOutError)
        case .signIn:
            return getLocalizedString(Constants.Errors.signInError)
        case .user:
            return getLocalizedString(Constants.Errors.userError)
        case .unknown:
            return getLocalizedString(Constants.Errors.unknown)
        }
    }
    
    func getLocalizedString(_ error: String) -> String {
        return String.localizedStringWithFormat(NSLocalizedString("%@", comment: "Error description"), error)
    }
}
