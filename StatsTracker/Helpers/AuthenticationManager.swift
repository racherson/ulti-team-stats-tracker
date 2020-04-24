//
//  AuthenticationManager.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/18/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

protocol AuthenticationManager {
    
    //MARK: Properties
    var currentUserUID: String? { get }
    var delegate: AuthManagerDelegate? { get set }
    
    //MARK: Methods
    func addAuthListener()
    func removeAuthListener()
    func createUser(_ teamName: String?, _ email: String?, _ password: String?)
    func signIn(_ email: String?, _ password: String?)
    func logout()
}

//MARK: Error Handling Protocols
protocol AuthManagerDelegate: class {
    var logoutSuccessful: Bool? { get set }
    func displayError(with error: Error)
    func onAuthHandleChange()
}

//MARK: AuthError
enum AuthError: Error {
    case emptyFields
    case invalidEmail
    case insecurePassword
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
        case .signOut:
            return Constants.Errors.signOutError
        case .signIn:
            return Constants.Errors.signInError
        case .unknown:
            return Constants.Errors.unknown
        }
    }
}
