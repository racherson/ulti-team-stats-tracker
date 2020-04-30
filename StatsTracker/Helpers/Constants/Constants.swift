//
//  Constants.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/10/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Titles {
        static let teamProfileTitle = "Team Profile"
        static let rosterTitle = "Roster"
        static let pullTitle = "Pull"
        static let gamesTitle = "Games"
        static let settingsTitle = "Settings"
        static let logout = "Log Out"
        static let edit = "Edit Team Profile"
        static let defaultTeamName = "Team Name"
    }
    
    struct Errors {
        static let emptyFieldsError = "Please fill in all fields."
        static let insecurePasswordError = "Please make sure your password is at least 8 characters and contains both a special character and a number."
        static let invalidEmailError = "Invalid email format."
        static let userSavingError = "Error saving user data."
        static let settingCellError = "Unknown settings cell type."
        static func dequeueError(_ cell: String) -> String {
            return "The dequeued cell is not an instance of " + cell
        }
        static let logoutError = "Log Out Error"
        static let documentError = "Document does not exist"
        static func viewControllerError(_ vc: String) -> String {
            return "Current view controller is not an instance of " + vc
        }
        static let signInError = "Incorrect email or password."
        static let signOutError = "Error signing out user."
        static let userError = "Could not retreive user."
        static let unknown = "Something went wrong."
    }
    
    struct Alerts {
        static let logoutAlert = "Are you sure you want to log out?"
        static let dismiss = "Dismiss"
        static let cancel = "Cancel"
        static let confirm = "Confirm"
    }
    
    struct Empty {
        static let string = ""
        static let int = 0
        static let image = "defaultPhoto"
    }
}
