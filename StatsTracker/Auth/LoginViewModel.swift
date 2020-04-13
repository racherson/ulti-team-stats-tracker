//
//  LoginViewModel.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/12/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation
import FirebaseAuth

class LoginViewModel {
    
    func validateFields(_ email: String?, _ password: String?) -> String? {
        // Validate text fields
        if email == "" || password == "" {
            return Constants.Errors.emptyFieldsError
        }
        // Fields aren't empty, thus valid
        return nil
    }
    
    func signIn(_ email: String, _ password: String) -> String? {
        
        var returnError: String? = nil
        
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
}
