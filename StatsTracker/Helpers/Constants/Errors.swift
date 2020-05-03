//
//  Errors.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/2/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

extension Constants {
    
    struct Errors {
        static let emptyFieldsError = "Please fill in all fields."
        static let insecurePasswordError = "Please make sure your password is at least 8 characters and contains both a special character and a number."
        static let invalidEmailError = "Invalid email format."
        
        static let settingCellError = "Unknown settings cell type."
        static func dequeueError(_ cell: String) -> String {
            return "The dequeued cell is not an instance of " + cell
        }
        static func viewControllerError(_ vc: String) -> String {
            return "Current view controller is not an instance of " + vc
        }
        
        static let logoutErrorTitle = "Log Out Error"
        static let documentError = "Document does not exist"
        static let userSavingError = "Error saving user data."
        static let signInError = "Incorrect email or password."
        static let signOutError = "Error signing out user."
        static let documentErrorTitle = "Error retrieving data."
        static let userError = "Could not retreive user."
        static let unknown = "Something went wrong."
    }
}
