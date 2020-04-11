//
//  LoginViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/10/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    weak var coordinator: AuthCoordinator?
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
    
    
    //MARK: Actions
    @objc func cancelPressed() {
        coordinator?.cancelPressed()
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        // Validate text fields
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.showError(Constants.Errors.emptyFieldsError)
        }
        else {
            // Created cleaned versions of text fields
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Sign in the user
            Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
                if err != nil {
                    // Coudn't sign in
                    self.showError(err!.localizedDescription)
                }
                else {
                    // Signed in successfully
                    self.transitionToTabs()
                }
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
