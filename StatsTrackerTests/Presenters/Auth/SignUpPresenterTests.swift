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
        // When
        sut.onViewWillAppear()
        // Then
        XCTAssertEqual(1, authManager.addAuthListenerCalled)
    }
    
    func testOnViewWillDisappear() throws {
        XCTAssertEqual(0, authManager.removeAuthListenerCalled)
        // When
        sut.onViewWillDisappear()
        // Then
        XCTAssertEqual(1, authManager.removeAuthListenerCalled)
    }
    
    func testSignUpPressed() throws {
        XCTAssertEqual(0, authManager.createUserCalled)
        // When
        sut.signUpPressed(name: "", email: "", password: "")
        // Then
        XCTAssertEqual(1, authManager.createUserCalled)
    }
    
    func testCancelPressed() throws {
        XCTAssertEqual(0, cancelPressedBool)
        // When
        sut.cancelPressed()
        // Then
        XCTAssertEqual(1, cancelPressedBool)
    }
    
    func testOnAuthHandleChange() throws {
        XCTAssertEqual(0, transitionCalled)
        // When
        sut.onAuthHandleChange()
        // Then
        XCTAssertEqual(1, transitionCalled)
    }
    
    func testDisplayError() throws {
        // Given
        let authError = AuthError.unknown
        // When
        sut.displayError(with: authError)
        // Then
        XCTAssertEqual(vc.errorLabel.text, authError.localizedDescription)
        
        // Given
        let dbError = DBError.unknown
        // When
        sut.displayError(with: dbError)
        // Then
        XCTAssertEqual(vc.errorLabel.text, dbError.localizedDescription)
        
        // Given
        let unknownError = TestConstants.error
        // When
        sut.displayError(with: unknownError)
        // Then
        XCTAssertEqual(vc.errorLabel.text, unknownError.localizedDescription)
    }
    
    func testOnCreateUserCompletion() throws {
        XCTAssertNil(dbManager.uid)
        XCTAssertEqual(0, dbManager.setDataCalled)
        XCTAssertNil(dbManager.setDictionary)
        // When
        sut.onCreateUserCompletion(uid: TestConstants.currentUID, data: [Constants.UserDataModel.teamName: Constants.Empty.teamName])
        // Then
        XCTAssertEqual(dbManager.uid, TestConstants.currentUID)
        XCTAssertEqual(1, dbManager.setDataCalled)
        XCTAssertNotNil(dbManager.setDictionary)
        XCTAssertEqual(Constants.Empty.teamName, dbManager.setDictionary![Constants.UserDataModel.teamName] as! String)
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
