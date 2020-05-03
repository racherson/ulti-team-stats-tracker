//
//  SettingsPresenter.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/22/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol SettingsPresenterDelegate: AnyObject {
    func transitionToHome()
    func editPressed()
}

class SettingsPresenter: Presenter {
    
    //MARK: Properties
    weak var delegate: SettingsPresenterDelegate?
    weak var vc: SettingsViewController!
    var authManager: AuthenticationManager!
    
    //MARK: Initialization
    init(vc: SettingsViewController, delegate: SettingsPresenterDelegate?, authManager: AuthenticationManager) {
        self.vc = vc
        self.delegate = delegate
        self.authManager = authManager
        self.authManager.logoutDelegate = self
    }
    
    func transitionToHome() {
        delegate?.transitionToHome()
    }
    
    //MARK: Private methods
    private func logout() {
        authManager.logout()
    }
    
    private func showErrorAlert(error: String) {
        // Error logging out, display alert
        let alertController = UIAlertController(title: Constants.Errors.logoutErrorTitle, message:
            error, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constants.Alerts.dismiss, style: .default))

        vc.present(alertController, animated: true, completion: nil)
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
        logoutAlert.addAction(UIAlertAction(title: Constants.Alerts.cancel, style: .destructive, handler: { (action: UIAlertAction!) in logoutAlert.dismiss(animated: true, completion: nil) }))

        // Confirm action and logout
        logoutAlert.addAction(UIAlertAction(title: Constants.Alerts.confirm, style: .default, handler: { (action: UIAlertAction!) in self.logout() }))

        vc.present(logoutAlert, animated: true, completion: nil)
    }
}

//MARK: AuthManagerLogoutDelegate
extension SettingsPresenter: AuthManagerLogoutDelegate {
    
    func displayError(with error: Error) {
        self.showErrorAlert(error: error.localizedDescription)
    }
    
    func onSuccessfulLogout() {
        self.transitionToHome()
    }
}
