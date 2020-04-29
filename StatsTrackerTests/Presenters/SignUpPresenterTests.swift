//
//  SignUpPresenterTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 4/28/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class SignUpPresenterTests: XCTestCase {
    
    var sut: SignUpPresenter!
    var vc: SignUpViewController!
    var authManager: MockSignedInAuthManager!
    
    var cancelPressedBool: Int = 0
    var transitionCalled: Int = 0
    
    override func setUp() {
        vc = SignUpViewController.instantiate(.auth)
        let _ = vc.view
        authManager = MockSignedInAuthManager()
        sut = SignUpPresenter(vc: vc, delegate: self)
        sut.authManager = authManager
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        vc = nil
        authManager = nil
        super.tearDown()
    }
    
    func testOnViewWillAppear() throws {
        XCTAssertEqual(0, authManager.addAuthListenerCalled)
        sut.onViewWillAppear()
        XCTAssertEqual(1, authManager.addAuthListenerCalled)
    }
    
    func testOnViewWillDisappear() throws {
        XCTAssertEqual(0, authManager.removeAuthListenerCalled)
        sut.onViewWillDisappear()
        XCTAssertEqual(1, authManager.removeAuthListenerCalled)
    }
    
    func testSignUpPressed() throws {
        XCTAssertEqual(0, authManager.createUserCalled)
        sut.signUpPressed(name: "", email: "", password: "")
        XCTAssertEqual(1, authManager.createUserCalled)
    }
    
    func testCancelCalled() throws {
        XCTAssertEqual(0, cancelPressedBool)
        sut.cancelPressed()
        XCTAssertEqual(1, cancelPressedBool)
    }
    
    func testOnAuthHandleChange() throws {
        XCTAssertEqual(0, transitionCalled)
        sut.onAuthHandleChange()
        XCTAssertEqual(1, transitionCalled)
    }
    
    func testDisplayError() throws {
        let authError = AuthError.unknown
        sut.displayError(with: authError)
        XCTAssertEqual(vc.errorLabel.text, authError.errorDescription)
        
        let unknownError = TestConstants.error
        sut.displayError(with: unknownError)
        XCTAssertEqual(vc.errorLabel.text, unknownError.localizedDescription)
    }
}

//MARK: SignUpAndLoginPresenterDelegate Mock
extension SignUpPresenterTests: SignUpAndLoginPresenterDelegate {
    func cancelPressed() {
        self.cancelPressedBool += 1
    }
    func transitionToTabs() {
        self.transitionCalled += 1
    }
}
