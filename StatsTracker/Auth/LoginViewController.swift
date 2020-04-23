//
//  LoginViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/10/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol LoginPresenterProtocol: class {
    func cancelPressed()
    func loginPressed(email: String?, password: String?)
    func transitionToTabs()
    func onViewWillAppear()
    func onviewWillDisappear()
}

class LoginViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    var presenter: LoginPresenter!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide error label
        errorLabel.alpha = 0
        
        // Add cancel button
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelPressed))
        self.navigationItem.leftBarButtonItem  = cancelButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.onViewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.onviewWillDisappear()
    }
    
    
    //MARK: Actions
    @objc func cancelPressed() {
        presenter.cancelPressed()
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        // Create cleaned versions of the data
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        presenter.loginPressed(email: email, password: password)
    }
    
    func showError(_ message: String) {
        // Set label text and make label visible
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func listenerResponse(user: NSObject?) {
        if user != nil {
          // User was authenticated, reset text fields
          self.emailTextField.text = nil
          self.passwordTextField.text = nil
          
          // Transition to MainTabBarController
          self.presenter.transitionToTabs()
        }
    }
}
