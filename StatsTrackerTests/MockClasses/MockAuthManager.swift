//
//  MockAuthManager.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 4/28/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation
@testable import StatsTracker

class MockSignedInAuthManager: AuthenticationManager {
    
    //MARK: Properties
    var currentUserUID: String? = TestConstants.currentUID
    var delegate: AuthManagerDelegate?
    
    var addAuthListenerCalled: Int = 0
    var removeAuthListenerCalled: Int = 0
    var createUserCalled: Int = 0
    var signInCalled: Int = 0
    var logoutCalled: Int = 0
    
    //MARK: Methods
    func addAuthListener() {
        addAuthListenerCalled += 1
    }
    
    func removeAuthListener() {
        removeAuthListenerCalled += 1
    }
    
    func createUser(_ teamName: String?, _ email: String?, _ password: String?) {
        createUserCalled += 1
    }
    
    func signIn(_ email: String?, _ password: String?) {
        signInCalled += 1
    }
    
    func logout() {
        logoutCalled += 1
        delegate?.onSuccessfulLogout()
    }
}

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
