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
        static let logout = "Logout"
        static let edit = "Edit"
    }
    
    struct Errors {
        
        static let emptyFieldsError = "Please fill in all fields."
        static let insecurePasswordError = "Please make sure your password is at least 8 characters and contains both a special character and a number."
        static let invalidEmailError = "Invalid email format."
        static let userCreationError = "Error creating user."
        static let userSavingError = "Error saving user data."
        static let settingCellError = "Unknown settings cell type."
        
    }
}
