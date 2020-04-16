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
    }
    
    struct Errors {
        
        static let emptyFieldsError = "Please fill in all fields."
        static let insecurePasswordError = "Please make sure your password is at least 8 characters and contains both a special character and a number."
        static let invalidEmailError = "Invalid email format."
        static let userCreationError = "Error creating user."
        static let userSavingError = "Error saving user data."
        static let settingCellError = "Unknown settings cell type."
        static let dequeueError = "The dequeued cell is not an instance of SettingsTableViewCell."
        static let logoutError = "Log Out Error"
        
    }
    
    struct Alerts {
        
        static let logoutAlert = "Are you sure you want to log out?"
    }
}
