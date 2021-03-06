//
//  SettingsPresenterTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 4/29/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
import ViewControllerPresentationSpy
@testable import StatsTracker

class SettingsPresenterTests: XCTestCase {

    var sut: SettingsPresenter!
    var vc: SettingsViewController!
    var authManager: MockSignedInAuthManager!
    
    private var transitionCalled: Int = 0
    private var editCalled: Int = 0
    
    override func setUp() {
        vc = SettingsViewController.instantiate(.team)
        let _ = vc.view
        authManager = MockSignedInAuthManager()
        sut = SettingsPresenter(vc: vc, delegate: self, authManager: authManager)
        authManager.logoutDelegate = sut
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        vc = nil
        authManager = nil
        super.tearDown()
    }
    
    func testOnViewWillAppear() throws {
        XCTAssertEqual(vc.navigationItem.title, nil)
        // When
        sut.onViewWillAppear()
        // Then
        XCTAssertEqual(vc.navigationItem.title, Constants.Titles.settingsTitle)
    }
    
    func testEditPressed() throws {
        XCTAssertEqual(0, editCalled)
        // When
        sut.editPressed()
        // Then
        XCTAssertEqual(1, editCalled)
    }
    
    func testLogoutPressed() throws {
        let alertVerifier = AlertVerifier()
        
        // When
        sut.logoutPressed()
        // Then
        alertVerifier.verify(
            title: Constants.Titles.logout,
            message: Constants.Alerts.logoutAlert,
            animated: true,
            actions: [
                .destructive(TestConstants.Alerts.cancel),
                .default(TestConstants.Alerts.confirm),
            ],
            presentingViewController: vc
        )
    }
    
    func testExecutingActionForConfirmButton_shouldLogout() throws {
        let alertVerifier = AlertVerifier()
        XCTAssertEqual(0, authManager.logoutCalled)
        XCTAssertEqual(0, transitionCalled)
        
        // Given
        sut.logoutPressed()
        // When
        try alertVerifier.executeAction(forButton: TestConstants.Alerts.confirm)
        // Then
        XCTAssertEqual(1, authManager.logoutCalled)
        XCTAssertEqual(1, transitionCalled)
    }
    
    func testDisplayAuthError() throws {
        let alertVerifier = AlertVerifier()
        
        // Given
        let authError = AuthError.unknown
        // When
        sut.displayError(with: authError)
        // Then
        alertVerifier.verify(
            title: Constants.Errors.logoutErrorTitle,
            message: authError.localizedDescription,
            animated: true,
            actions: [
                .default(TestConstants.Alerts.dismiss)
            ],
            presentingViewController: vc
        )
    }
    
    func testDisplayUnknownError() throws {
        let alertVerifier = AlertVerifier()
        
        // Given
        let unknownError = TestConstants.error
        // When
        sut.displayError(with: unknownError)
        // Then
        alertVerifier.verify(
            title: Constants.Errors.logoutErrorTitle,
            message: unknownError.localizedDescription,
            animated: true,
            actions: [
                .default(TestConstants.Alerts.dismiss)
            ],
            presentingViewController: vc
        )
    }
}

//MARK: SettingsPresenterDelegate
extension SettingsPresenterTests: SettingsPresenterDelegate {
    func transitionToHome() {
        self.transitionCalled += 1
    }
    
    func editPressed() {
        self.editCalled += 1
    }
}
