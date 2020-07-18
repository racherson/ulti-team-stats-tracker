//
//  LoginViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/10/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol LoginPresenterProtocol where Self: Presenter {
    func cancelPressed()
    func loginPressed(email: String?, password: String?)
    func onViewWillDisappear()
}

class LoginViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    var presenter: LoginPresenterProtocol!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.isEnabled = false
        loginButton.setUp()
        Color.setGradient(view: view)

        // Hide error label
        errorLabel.alpha = 0
        errorLabel.textColor = .red
        
        // Handle the text field’s user input through delegate callbacks.
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(textFieldIsNotEmpty), for: .allEditingEvents)
        passwordTextField.addTarget(self, action: #selector(textFieldIsNotEmpty), for: .allEditingEvents)
        
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
        presenter.onViewWillDisappear()
    }
    
    func showError(_ message: String) {
        // Set label text and make label visible
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    //MARK: Actions
    @objc func textFieldIsNotEmpty(sender: UITextField) {
        // Validate text fields are not empty
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
            else {
                loginButton.isEnabled = false; return
        }
        
        // Enable sign up button if conditions are met
        loginButton.isEnabled = true
    }
    
    @objc func cancelPressed() {
        presenter.cancelPressed()
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        // Create cleaned versions of the data
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        presenter.loginPressed(email: email, password: password)
    }
}

//MARK: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        
        // Hide the keyboard and login
        if textField == passwordTextField {
            textField.resignFirstResponder()
            loginPressed(loginButton)
        }
        
        return true
    }
}
