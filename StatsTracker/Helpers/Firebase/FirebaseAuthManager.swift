//
//  FirebaseAuthManager.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/12/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

class FirebaseAuthManager {
    
    // This method creates a new user account and stores in Firestore. If everything works, this method returns nil. Otherwise it returns the error message.
    static func createUser(_ teamName: String, _ email: String, _ password: String) -> String? {
        
        var returnError: String? = nil
        
        if let validateError = validateFields(teamName, email, password) {
            return validateError
        }
        
        // Create the user
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            // Check for errors
            if err != nil {
                // There was an error creating the user
                returnError = Constants.Errors.userCreationError
            }
            else {
                // User was created successfully, now store the user data (validated as not empty)
                let uid = result!.user.uid
                let userData = [
                    FirebaseKeys.Users.teamName: teamName,
                    FirebaseKeys.Users.email: email,
                    FirebaseKeys.Users.uid: uid
                ]
                
                FirestoreReferenceManager.referenceForUserPublicData(uid: uid).setData(userData) { (error) in
                    if error != nil {
                        // Show error message
                        returnError = Constants.Errors.userSavingError
                    }
                }
            }
        }
        // Return creation/saving error, if any, otherwise nil
        return returnError
    }
    
    // This method signs in a user stored in Firebase. If everything works, this method returns nil. Otherwise it returns the error message.
    static func signIn(_ email: String, _ password: String) -> String? {
        
        var returnError: String? = nil
        
        if let validateError = validateFields(email, password) {
            return validateError
        }
        
        // Sign in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            if err != nil {
                // Coudn't sign in
                returnError = err!.localizedDescription
            }
        }
        // Return login error, if any, otherwise nil
        return returnError
    }
    
    // This method logs a user out of the app. If everything works, this method returns nil. Otherwise it returns the error message.
    static func logout() -> String? {
        var returnError: String? = nil
        
        do {
            // Attempt to logout
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            // Unable to logout
            returnError = signOutError.localizedDescription
        }
        // Return the error or nil
        return returnError
    }
    
    //MARK: Private Methods
    private static func isPasswordValid(_ password : String) -> Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[$@$#!%*?*])[A-Za-z\\d$@$#!%*?&]{8,}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
    
    private static func isEmailValid(_ email : String) -> Bool {
        let emailRegEx = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{1,4}$"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    // Check that the fields aren't empty. If everything is correct, this method returns nil. Otherwise it returns the error message.
    // Inputs: email, password
    private static func validateFields(_ email: String?, _ password: String?) -> String? {
        // Check that all fields are filled in
        if email == "" || password == "" {
            return Constants.Errors.emptyFieldsError
        }
        // Fields aren't empty, thus valid
        return nil
    }
    
    // Check the fields and validate for correctness. If everything is correct, this method returns nil. Otherwise it returns the error message.
    // Inputs: team name, email, password
    private static func validateFields(_ teamName: String?, _ email: String?, _ password: String?) -> String? {
        
        // Check that all fields are filled in
        if teamName == "" || email == "" || password == "" {
            return Constants.Errors.emptyFieldsError
        }
        
        // Check if email format is valid
        if isEmailValid(email!) == false {
            return Constants.Errors.invalidEmailError
        }
        
        // Check if the password is secure
        if isPasswordValid(password!) == false {
            // Password isn't secure enough
            return Constants.Errors.insecurePasswordError
        }
        
        // Fields aren't empty, thus valid
        return nil
    }
}
