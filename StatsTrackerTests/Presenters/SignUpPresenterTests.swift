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
    var navigationController: MockNavigationController!
    var authManager: MockSignedInAuthManager!
    
    var cancelPressedBool: Bool = false
    var transitionCalled: Bool = false
    
    override func setUp() {
        navigationController = MockNavigationController()
        vc = SignUpViewController.instantiate(.auth)
        let _ = navigationController.view
        let _ = vc.view
        authManager = MockSignedInAuthManager()
        sut = SignUpPresenter(vc: vc, delegate: self)
        sut.authManager = authManager
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        navigationController = nil
        vc = nil
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
        XCTAssertFalse(cancelPressedBool)
        sut.cancelPressed()
        XCTAssertTrue(cancelPressedBool)
    }
    
    func testOnAuthHandleChange() throws {
        XCTAssertFalse(transitionCalled)
        sut.onAuthHandleChange()
        XCTAssertTrue(transitionCalled)
    }
    
    func testDisplayError() throws {
        let authError = AuthError.unknown
        sut.displayError(with: authError)
        XCTAssertEqual(sut.vc.errorLabel.text, authError.errorDescription)
        
        let unknownError = NSError(domain: "", code: 0, userInfo: nil)
        sut.displayError(with: unknownError)
        XCTAssertEqual(sut.vc.errorLabel.text, unknownError.localizedDescription)
    }
}

//MARK: SignUpAndLoginPresenterDelegate Mock
extension SignUpPresenterTests: SignUpAndLoginPresenterDelegate {
    func cancelPressed() {
        self.cancelPressedBool = true
    }
    func transitionToTabs() {
        self.transitionCalled = true
    }
}
