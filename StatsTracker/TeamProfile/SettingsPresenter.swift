//
//  SettingsPresenter.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/22/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol SettingsPresenterDelegate: class {
    func transitionToHome()
    func editPressed()
}

class SettingsPresenter: Presenter {
    
    //MARK: Properties
    weak var delegate: SettingsPresenterDelegate?
    let vc: SettingsViewController
    let authManager: AuthenticationManager
    
    //MARK: Initialization
    init(vc: SettingsViewController, delegate: SettingsPresenterDelegate?, authManager: AuthenticationManager) {
        self.vc = vc
        self.delegate = delegate
        self.authManager = authManager
    }
    
    func transitionToHome() {
        delegate?.transitionToHome()
    }
}

//MARK: SettingsPresenterProtocol
extension SettingsPresenter: SettingsPresenterProtocol {
    
    func onViewWillAppear() {
        vc.title = Constants.Titles.settingsTitle
    }

    func editPressed() {
        delegate?.editPressed()
    }
    
    func logoutPressed() {
        let logoutAlert = UIAlertController(title: Constants.Titles.logout, message: Constants.Alerts.logoutAlert, preferredStyle: UIAlertController.Style.alert)
        
        // Cancel action and dismiss
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) in logoutAlert.dismiss(animated: true, completion: nil) }))

        // Confirm action and logout
        logoutAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in self.logout() }))

        vc.present(logoutAlert, animated: true, completion: nil)
    }
    
    private func logout() {
        do {
            try authManager.logout()
            self.transitionToHome()
        } catch let err as AuthError {
            showErrorAlert(error: err)
        } catch {
            showErrorAlert(error: AuthError.unknown)
        }
    }
    
    private func showErrorAlert(error: AuthError) {
        // Error logging out, display alert
        let alertController = UIAlertController(title: Constants.Errors.logoutError, message:
            error.errorDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

        vc.present(alertController, animated: true, completion: nil)
    }
}
