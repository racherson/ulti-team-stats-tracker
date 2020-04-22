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
    var delegate: SignUpAndLoginViewControllerDelegate?
    var authManager: AuthenticationManager?
    private var handle: AuthStateDidChangeListenerHandle?
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
        
        // Listen for changes in authentication
        setAuthListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove auth listener
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    
    //MARK: Actions
    @objc func cancelPressed() {
        delegate?.cancelPressed()
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        // Create cleaned versions of the data
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Attempt to sign in the user
        do {
            try authManager?.signIn(email, password)
        } catch let err as AuthError {
            showError(err.errorDescription!)
        } catch {
            showError(Constants.Errors.unknown)
        }
    }
    
    
    //MARK: Private Methods
    private func showError(_ message: String) {
        // Set label text and make label visible
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    private func setAuthListener() {
        // Listener for changes in authentication
        handle = Auth.auth().addStateDidChangeListener() { auth, user in

          if user != nil {
            // User was authenticated, reset text fields
            self.emailTextField.text = nil
            self.passwordTextField.text = nil
            
            // Transition to MainTabBarController
            self.delegate?.transitionToTabs()
          }
        }
    }
}
