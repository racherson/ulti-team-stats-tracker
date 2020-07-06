//
//  LoginPresenterTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 4/29/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class LoginPresenterTests: XCTestCase {
    
    var sut: LoginPresenter!
    var vc: LoginViewController!
    var authManager: MockSignedInAuthManager!
    
    private var cancelPressedCount: Int = 0
    private var transitionCalled: Int = 0
    
    override func setUp() {
        vc = LoginViewController.instantiate(.auth)
        let _ = vc.view
        authManager = MockSignedInAuthManager()
        sut = LoginPresenter(vc: vc, delegate: self, authManager: authManager)
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
    
    func testLoginPressed() throws {
        XCTAssertEqual(0, authManager.signInCalled)
        // When
        sut.loginPressed(email: TestConstants.email, password: TestConstants.empty)
        // Then
        XCTAssertEqual(1, authManager.signInCalled)
    }
    
    func testCancelCalled() throws {
        XCTAssertEqual(0, cancelPressedCount)
        // When
        sut.cancelPressed()
        // Then
        XCTAssertEqual(1, cancelPressedCount)
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
        let unknownError = TestConstants.error
        // When
        sut.displayError(with: unknownError)
        // Then
        XCTAssertEqual(vc.errorLabel.text, unknownError.localizedDescription)
    }
}

//MARK: SignUpAndLoginPresenterDelegate
extension LoginPresenterTests: SignUpAndLoginPresenterDelegate {
    func cancelPressed() {
        self.cancelPressedCount += 1
    }
    func transitionToTabs() {
        self.transitionCalled += 1
    }
}
