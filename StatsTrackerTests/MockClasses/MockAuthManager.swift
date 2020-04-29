//
//  MockAuthManager.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 4/28/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation
@testable import StatsTracker

class MockSignedOutAuthManager: AuthenticationManager {
    var currentUserUID: String? = nil
    var delegate: AuthManagerDelegate?
}

//MARK: MockSignedOutAuthManager Dummy
extension MockSignedOutAuthManager {
    func addAuthListener() {
        return
    }
    
    func removeAuthListener() {
        return
    }
    
    func createUser(_ teamName: String?, _ email: String?, _ password: String?) {
        return
    }
    
    func signIn(_ email: String?, _ password: String?) {
        return
    }
    
    func logout() {
        return
    }
}

class MockSignedInAuthManager: AuthenticationManager {
    var currentUserUID: String? = "12345"
    var delegate: AuthManagerDelegate?
}

//MARK: MockSignedInAuthManager Dummy
extension MockSignedInAuthManager {
    func addAuthListener() {
        return
    }
    
    func removeAuthListener() {
        return
    }
    
    func createUser(_ teamName: String?, _ email: String?, _ password: String?) {
        return
    }
    
    func signIn(_ email: String?, _ password: String?) {
        return
    }
    
    func logout() {
        return
    }
}
