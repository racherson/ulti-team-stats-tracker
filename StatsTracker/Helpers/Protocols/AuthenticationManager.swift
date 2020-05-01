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

//MARK: AuthManagerDelegate
protocol AuthManagerDelegate: AnyObject {
    func onSuccessfulLogout()
    func displayError(with error: Error)
    func onAuthHandleChange()
    func onCreateUserCompletion(uid: String, data: [String: Any])
}

extension AuthManagerDelegate {
    // Defaults
    func onSuccessfulLogout() { }
    func onAuthHandleChange() { }
    func onCreateUserCompletion(uid: String, data: [String: Any]) { }
}
