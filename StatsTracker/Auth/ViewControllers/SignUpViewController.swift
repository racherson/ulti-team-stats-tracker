//
//  SignUpViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/10/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol SignUpPresenterProtocol where Self: Presenter {
    func cancelPressed()
    func signUpPressed(name: String?, email: String?, password: String?)
    func onViewWillDisappear()
}

class SignUpViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    var presenter: SignUpPresenterProtocol!
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.isEnabled = false
        signUpButton.setUp()
        Color.setGradient(view: view)

        // Hide error label
        errorLabel.alpha = 0
        errorLabel.textColor = .red
        
        // Handle the text field’s user input through delegate callbacks.
        teamNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        teamNameTextField.addTarget(self, action: #selector(textFieldIsNotEmpty), for: .allEditingEvents)
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
        guard let name = teamNameTextField.text, !name.isEmpty,
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
            else {
                signUpButton.isEnabled = false; return
        }
        
        // Enable sign up button if conditions are met
        signUpButton.isEnabled = true
    }
    
    @objc func cancelPressed() {
        presenter.cancelPressed()
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        // Create cleaned versions of the data
        let teamName = teamNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        presenter.signUpPressed(name: teamName, email: email, password: password)
    }
}

//MARK: UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == teamNameTextField {
            emailTextField.becomeFirstResponder()
        }
        
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        
        // Hide the keyboard.
        if textField == passwordTextField {
            textField.resignFirstResponder()
            signUpPressed(signUpButton)
        }
        
        return true
    }
}
