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
    
    var transitionCalled: Int = 0
    var editCalled: Int = 0
    
    override func setUp() {
        vc = SettingsViewController.instantiate(.team)
        let _ = vc.view
        authManager = MockSignedInAuthManager()
        sut = SettingsPresenter(vc: vc, delegate: self)
        authManager.delegate = sut
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
        XCTAssertEqual(vc.title, nil)
        sut.onViewWillAppear()
        XCTAssertEqual(vc.title, Constants.Titles.settingsTitle)
    }
    
    func testEditPressed() throws {
        XCTAssertEqual(0, editCalled)
        sut.editPressed()
        XCTAssertEqual(1, editCalled)
    }
    
    func testLogoutPressed() throws {
        let alertVerifier = AlertVerifier()
        sut.logoutPressed()
        
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
        sut.logoutPressed()
        
        try alertVerifier.executeAction(forButton: TestConstants.Alerts.confirm)
        XCTAssertEqual(1, authManager.logoutCalled)
        XCTAssertEqual(1, transitionCalled)
    }
    
    func testDisplayAuthError() throws {
        let alertVerifier = AlertVerifier()
        let authError = AuthError.unknown
        sut.displayError(with: authError)
        alertVerifier.verify(
            title: Constants.Errors.logoutError,
            message: authError.errorDescription,
            animated: true,
            actions: [
                .default(TestConstants.Alerts.dismiss)
            ],
            presentingViewController: vc
        )
    }
    
    func testDisplayUnknownError() throws {
        let alertVerifier = AlertVerifier()
        let unknownError = TestConstants.error
        sut.displayError(with: unknownError)
        alertVerifier.verify(
            title: Constants.Errors.logoutError,
            message: unknownError.localizedDescription,
            animated: true,
            actions: [
                .default(TestConstants.Alerts.dismiss)
            ],
            presentingViewController: vc
        )
    }
}

//MARK: SettingsPresenterDelegate Mock
extension SettingsPresenterTests: SettingsPresenterDelegate {
    func transitionToHome() {
        self.transitionCalled += 1
    }
    
    func editPressed() {
        self.editCalled += 1
    }
}
