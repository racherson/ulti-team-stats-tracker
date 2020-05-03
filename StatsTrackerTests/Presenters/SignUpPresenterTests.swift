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
    var dbManager: MockDBManager!
    
    var cancelPressedBool: Int = 0
    var transitionCalled: Int = 0
    
    override func setUp() {
        vc = SignUpViewController.instantiate(.auth)
        let _ = vc.view
        authManager = MockSignedInAuthManager()
        dbManager = MockDBManager()
        sut = SignUpPresenter(vc: vc, delegate: self, authManager: authManager, dbManager: dbManager)
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        vc = nil
        authManager = nil
        dbManager = nil
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
    
    func testCancelPressed() throws {
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
        XCTAssertEqual(vc.errorLabel.text, authError.localizedDescription)
        
        let dbError = DBError.unknown
        sut.displayError(with: dbError)
        XCTAssertEqual(vc.errorLabel.text, dbError.localizedDescription)
        
        let unknownError = TestConstants.error
        sut.displayError(with: unknownError)
        XCTAssertEqual(vc.errorLabel.text, unknownError.localizedDescription)
    }
    
    func testOnCreateUserCompletion() throws {
        XCTAssertNil(dbManager.uid)
        XCTAssertEqual(0, dbManager.setDataCalled)
        sut.onCreateUserCompletion(uid: TestConstants.currentUID, data: ["": ""])
        XCTAssertEqual(dbManager.uid, TestConstants.currentUID)
        XCTAssertEqual(1, dbManager.setDataCalled)
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
