//
//  SignUpPresenter.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/22/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

protocol SignUpAndLoginPresenterDelegate: AnyObject {
    func cancelPressed()
    func transitionToTabs()
}

class SignUpPresenter: Presenter {

    //MARK: Properties
    weak var delegate: SignUpAndLoginPresenterDelegate?
    weak var vc: SignUpViewController!
    var authManager: AuthenticationManager!
    var dbManager: DatabaseManager!
    
    //MARK: Initialization
    init(vc: SignUpViewController, delegate: SignUpAndLoginPresenterDelegate?,
         authManager: AuthenticationManager, dbManager: DatabaseManager) {
        self.vc = vc
        self.delegate = delegate
        self.authManager = authManager
        self.dbManager = dbManager
        self.authManager.createUserDelegate = self
        self.dbManager.setDataDelegate = self
    }
    
    func onViewWillAppear() {
        // Listener for changes in authentication
        authManager.addAuthListener()
    }
    
    //MARK: Private methods
    private func transitionToTabs() {
        delegate?.transitionToTabs()
    }
}

//MARK: SignUpPresenterProtocol
extension SignUpPresenter: SignUpPresenterProtocol {
    
    func cancelPressed() {
        delegate?.cancelPressed()
    }
    
    func onViewWillDisappear() {
        // Remove the listener
        authManager.removeAuthListener()
    }
    
    func signUpPressed(name: String?, email: String?, password: String?) {
        // Attempt to create user
        authManager.createUser(name, email, password)
    }
}

//MARK: AuthManagerCreateUserDelegate
extension SignUpPresenter: AuthManagerCreateUserDelegate {

    func displayError(with error: Error) {
        self.vc.showError(error.localizedDescription)
    }
    
    func onAuthHandleChange() {
        transitionToTabs()
    }
    
    func onCreateUserCompletion(uid: String, data: [String : Any]) {
        // Store the new user data with current user uid
        dbManager.uid = uid
        dbManager.setData(data: data, collection: .profile)
    }
}

//MARK: DatabaseManagerGetDataDelegate
extension SignUpPresenter: DatabaseManagerSetDataDelegate {
    func onSuccessfulSet() { }
}
