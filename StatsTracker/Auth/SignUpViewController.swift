//
//  SignUpViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/10/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    weak var coordinator: AuthCoordinator?
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

    
    //MARK: Helpers
    func isPasswordValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?*])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    func isEmailValid(_ email : String) -> Bool {
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "^[A-Z0-9._%+-]+@[A-Z0-9.-]+.[A-Z]{2,}$")
        return emailTest.evaluate(with: email)
    }
    
    // Check the fields and validate for correctness. If everything is correct, this method returns nil. Otherwise it returns the error message.
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if teamNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return Constants.Errors.emptyFieldsError
        }
        
        // Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            return Constants.Errors.insecurePasswordError
        }
        
        // Check if email format is valid
        let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isEmailValid(cleanedEmail) == false {
            return Constants.Errors.invalidEmailError
        }
        
        return nil
    }
    
    func showError(_ message: String) {
        // Set label text and make label visible
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToTabs() {
        // Make tab bar controller the root view
        let tabVC = MainTabBarController()
        view.window?.rootViewController = tabVC
        view.window?.makeKeyAndVisible()
    }
    
    
    //MARK: Actions
    @objc func cancelPressed() {
        coordinator?.cancelPressed()
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            // There's something wrong with the fields, show error message
            showError(error!)
        }
        else {
            // Create cleaned versions of the data
            let teamName = teamNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                // Check for errors
                if err != nil {
                    // There was an error creating the user
                    // more detail found in err?.localizedDescription
                    self.showError(Constants.Errors.userCreationError)
                }
                else {
                    // User was created successfully, now store the team name
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["teamname":teamName, "uid":result!.user.uid]) { (error) in
                        if error != nil {
                            // Show error message
                            self.showError(Constants.Errors.userSavingError)
                        }
                    }
                    // Transition to the tab bar controller
                    self.transitionToTabs()
                }
            }
        }
    }
    

}
