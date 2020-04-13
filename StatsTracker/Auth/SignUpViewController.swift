//
//  SignUpViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/10/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol SignUpAndLoginViewControllerDelegate {
    func cancelPressed()
}

class SignUpViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    var delegate: SignUpAndLoginViewControllerDelegate?
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide error label
        errorLabel.alpha = 0
        
        // Add cancel button
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelPressed))
        self.navigationItem.leftBarButtonItem  = cancelButton
    }
    
    
    //MARK: Actions
    @objc func cancelPressed() {
        delegate?.cancelPressed()
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        // Create cleaned versions of the data (optionals still)
        let teamName = teamNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Validate the fields
        if let validateError = AuthManager.validateFields(teamName, email, password) {
            showError(validateError)
        }
        else {
            
            // Create user, can unwrap fields because email and password have been validated
            if let creationError = AuthManager.createUser(teamName!, email!, password!) {
                showError(creationError)
            }
            else {
                // Transition to the tab bar controller
                self.transitionToTabs()
            }
        }
    }
    
    
    //MARK: Private Methods
    private func showError(_ message: String) {
        // Set label text and make label visible
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    private func transitionToTabs() {
        // Make tab bar controller the root view
        let tabVC = MainTabBarController()
        view.window?.rootViewController = tabVC
        view.window?.makeKeyAndVisible()
    }
    
}
