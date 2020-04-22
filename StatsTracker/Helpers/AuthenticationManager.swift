//
//  AuthenticationManager.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/18/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

protocol AuthenticationManager {
    var currentUserUID: String? { get }
    
    func createUser(_ teamName: String?, _ email: String?, _ password: String?) throws
    func signIn(_ email: String?, _ password: String?) throws
    func logout() throws
}

enum AuthError: Error {
    case emptyFields
    case invalidEmail
    case insecurePassword
    case userCreation
    case userSaving
    case signOut
    case signIn
    case unknown
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
        case .userCreation:
            return Constants.Errors.userCreationError
        case .userSaving:
            return Constants.Errors.userSavingError
        case .signOut:
            return Constants.Errors.signOutError
        case .signIn:
            return Constants.Errors.signInError
        case .unknown:
            return Constants.Errors.unknown
        }
    }
}
