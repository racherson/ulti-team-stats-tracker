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
    var loginDelegate: AuthManagerLoginDelegate? { get set }
    var createUserDelegate: AuthManagerCreateUserDelegate? { get set }
    var logoutDelegate: AuthManagerLogoutDelegate? { get set }
    
    //MARK: Methods
    func addAuthListener()
    func removeAuthListener()
    func createUser(_ teamName: String?, _ email: String?, _ password: String?)
    func signIn(_ email: String?, _ password: String?)
    func logout()
}

//MARK: AuthManagerLogoutDelegate
protocol AuthManagerLogoutDelegate: AnyObject {
    func displayError(with error: Error)
    func onSuccessfulLogout()
}

//MARK: AuthManagerCreateUserDelegate
protocol AuthManagerCreateUserDelegate: AnyObject {
    func displayError(with error: Error)
    func onCreateUserCompletion(uid: String, data: [String: Any])
    func onAuthHandleChange()
}

//MARK: AuthManagerLoginDelegate
protocol AuthManagerLoginDelegate: AnyObject {
    func displayError(with error: Error)
    func onAuthHandleChange()
}
