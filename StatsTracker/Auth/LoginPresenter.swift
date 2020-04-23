//
//  LoginPresenter.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/22/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation
import FirebaseAuth

class LoginPresenter: Presenter {
    
    //MARK: Properties
    weak var delegate: SignUpAndLoginPresenterDelegate?
    let vc: LoginViewController
    let authManager: AuthenticationManager
    private var handle: AuthStateDidChangeListenerHandle?
    
    //MARK: Initialization
    init(vc: LoginViewController, delegate: SignUpAndLoginPresenterDelegate?, authManager: AuthenticationManager) {
        self.vc = vc
        self.delegate = delegate
        self.authManager = authManager
    }
}

extension LoginPresenter: LoginPresenterProtocol {
    
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
    
    func loginPressed(email: String?, password: String?) {
        // Attempt to sign in the user
        do {
            try authManager.signIn(email, password)
        } catch let err as AuthError {
            self.vc.showError(err.errorDescription!)
        } catch {
            self.vc.showError(Constants.Errors.unknown)
        }
    }
}
