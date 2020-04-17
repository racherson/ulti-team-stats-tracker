//
//  FirebaseKeys.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/14/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

struct FirebaseKeys {
    
    struct CollectionPath {
        
        static let environment = "dev"
        
        static let publicData = "publicData"
        static let privateData = "privateData"
        
        static let users = "users"
    }
    
    struct Users {
        
        static let teamName = "teamname"
        static let email = "email"
        static let uid = "uid"
    }
}
