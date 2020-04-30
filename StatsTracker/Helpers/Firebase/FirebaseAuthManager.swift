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
    private var auth: Auth = Auth.auth()
    private var handle: AuthStateDidChangeListenerHandle?
    weak var delegate: AuthManagerDelegate?
    
    // This method creates a new user account and stores in Firestore.
    func createUser(_ teamName: String?, _ email: String?, _ password: String?) {

        do {
            try validateFields(teamName, email, password)
        } catch let error as AuthError {
            delegate?.displayError(with: error)
        } catch {
            delegate?.displayError(with: AuthError.unknown)
        }
        
        // Create the user
        auth.createUser(withEmail: email!, password: password!) { (result, err) in
            // Check for errors
            if err != nil {
                // There was an error creating the user
                self.delegate?.displayError(with: err!)
            }
            else {
                // User was created successfully, now store the user data (validated as not empty)
                let uid = result!.user.uid
                let userData = [
                    Constants.UserDataModel.teamName: teamName!,
                    Constants.UserDataModel.email: email!,
                    Constants.UserDataModel.imageURL: Constants.Empty.string
                ]
                
                let dbManager = FirestoreDBManager(uid: uid)
                dbManager.delegate = self
                dbManager.setData(data: userData)
            }
        }
    }
    
    // This method signs in a user stored in Firebase.
    func signIn(_ email: String?, _ password: String?) {
        
        do {
            try validateFields(email, password)
        } catch let error as AuthError {
            delegate?.displayError(with: error)
        } catch {
            delegate?.displayError(with: AuthError.unknown)
        }

        // Sign in the user
        auth.signIn(withEmail: email!, password: password!) { (result, err) in
            if err != nil {
                // Coudn't sign in
                self.delegate?.displayError(with: err!)
            }
            
            if result == nil {
                self.delegate?.displayError(with: AuthError.signIn)
            }
        }
    }
    
    // This method logs a user out of the app.
    func logout() {
        do {
            // Attempt to logout
            try auth.signOut()
            delegate?.logoutSuccessful = true
        } catch  {
            // Unable to logout
            delegate?.logoutSuccessful = false
            delegate?.displayError(with: AuthError.signOut)
        }
    }
    
    // This method adds a listener for changes in authentication from Firebase.
    func addAuthListener() {
        handle = auth.addStateDidChangeListener() { auth, user in
            // A user was authenticated
            if user != nil {
                self.delegate?.onAuthHandleChange()
            }
        }
    }
    
    // This method removes the authentication listener
    func removeAuthListener() {
        auth.removeStateDidChangeListener(handle!)
    }
}

//MARK: DatabaseManagerDelegate
extension FirebaseAuthManager: DatabaseManagerDelegate {
    func displayError(_ error: Error) {
        self.delegate?.displayError(with: error)
    }  
}

extension FirebaseAuthManager {
    
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
