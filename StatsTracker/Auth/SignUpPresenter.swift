//
//  SignUpPresenter.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/22/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol SignUpAndLoginPresenterDelegate: class {
    func cancelPressed()
    func transitionToTabs()
}

class SignUpPresenter: Presenter {

    //MARK: Properties
    weak var delegate: SignUpAndLoginPresenterDelegate?
    let vc: SignUpViewController
    let authManager: AuthenticationManager
    private var handle: AuthStateDidChangeListenerHandle?
    
    //MARK: Initialization
    init(vc: SignUpViewController, delegate: SignUpAndLoginPresenterDelegate?, authManager: AuthenticationManager) {
        self.vc = vc
        self.delegate = delegate
        self.authManager = authManager
    }
}

extension SignUpPresenter: SignUpPresenterProtocol {
    
    func cancelPressed() {
        delegate?.cancelPressed()
    }
    
    func transitionToTabs() {
        delegate?.transitionToTabs()
    }
    
    func onViewWillAppear() {
        // Listener for changes in authentication
        handle = authManager.auth.addStateDidChangeListener() { auth, user in
            self.vc.listenerResponse(user: user)
        }
    }
    
    func onviewWillDisappear() {
        authManager.auth.removeStateDidChangeListener(handle!)
    }
    
    func signUpPressed(name: String?, email: String?, password: String?) {
        // Attempt to create user
        do {
            try authManager.createUser(name, email, password)
        } catch let err as AuthError {
            self.vc.showError(err.errorDescription!)
        } catch {
            self.vc.showError(Constants.Errors.unknown)
        }
    }
}
