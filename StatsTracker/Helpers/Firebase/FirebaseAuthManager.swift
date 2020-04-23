//
//  FirebaseAuthManager.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/12/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation
import FirebaseAuth

class FirebaseAuthManager: AuthenticationManager {
    
    //MARK: Properties
    private(set) var currentUserUID: String? = Auth.auth().currentUser?.uid
    private(set) var auth: Auth = Auth.auth()
    
    // This method creates a new user account and stores in Firestore. It throws an error if one occurs.
    func createUser(_ teamName: String?, _ email: String?, _ password: String?) throws {

        do {
            try validateFields(teamName, email, password)
        } catch let error as AuthError {
            throw error
        } catch {
            throw AuthError.unknown
        }
        
        var creationError: AuthError?
        
        // Create the user
        auth.createUser(withEmail: email!, password: password!) { (result, err) in
            // Check for errors
            if err != nil {
                // There was an error creating the user
                creationError = AuthError.userCreation
            }
            else {
                // User was created successfully, now store the user data (validated as not empty)
                let uid = result!.user.uid
                let userData = [
                    FirebaseKeys.Users.teamName: teamName!,
                    FirebaseKeys.Users.email: email!,
                    FirebaseKeys.Users.uid: uid,
                    FirebaseKeys.Users.imageURL: Constants.Empty.string
                ]
                
                FirestoreReferenceManager.referenceForUserPublicData(uid: uid).setData(userData) { (error) in
                    if error != nil {
                        // Show error message
                        creationError = AuthError.userSaving
                    }
                }
            }
        }
        
        // If there was an error in the creation process, throw it
        if creationError != nil {
            throw creationError!
        }
    }
    
    // This method signs in a user stored in Firebase. It throws an error if one occurs.
    func signIn(_ email: String?, _ password: String?) throws {
        
        do {
            try validateFields(email, password)
        } catch let error as AuthError {
            throw error
        } catch {
            throw AuthError.unknown
        }
        
        var signInError: AuthError?
        
        // Sign in the user
        auth.signIn(withEmail: email!, password: password!) { (result, err) in
            if err != nil || result == nil {
                // Coudn't sign in
                signInError = AuthError.signIn
            }
        }
        
        // If there was an error in the sign in process, throw it
        if signInError != nil {
            throw signInError!
        }
    }
    
    // This method logs a user out of the app. It throws an error if one occurs.
    func logout() throws {
        
        do {
            // Attempt to logout
            try auth.signOut()
        } catch  {
            // Unable to logout
            throw AuthError.signOut
        }
    }
    
    //MARK: Private Methods
    private func isPasswordValid(_ password : String) -> Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[$@$#!%*?*])[A-Za-z\\d$@$#!%*?&]{8,}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
    
    private func isEmailValid(_ email : String) -> Bool {
        let emailRegEx = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{1,4}$"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    // Check that the fields aren't empty. It throws an error if one occurs.
    // Inputs: email and password
    private func validateFields(_ email: String?, _ password: String?) throws {
        // Check that all fields are filled in
        if email == "" || password == "" {
            throw AuthError.emptyFields
        }
    }
    
    // Check the fields and validate for correctness. It throws an error if one occurs.
    // Inputs: team name, email, password
    private func validateFields(_ teamName: String?, _ email: String?, _ password: String?) throws {
        
        // Check that all fields are filled in
        if teamName == "" || email == "" || password == "" {
            throw AuthError.emptyFields
        }
        
        // Check if email format is valid
        if isEmailValid(email!) == false {
            throw AuthError.invalidEmail
        }
        
        // Check if the password is secure
        if isPasswordValid(password!) == false {
            // Password isn't secure enough
            throw AuthError.insecurePassword
        }
    }
}
