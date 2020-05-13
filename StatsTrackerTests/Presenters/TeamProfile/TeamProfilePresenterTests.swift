//
//  TeamProfilePresenterTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 4/29/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
import ViewControllerPresentationSpy
@testable import StatsTracker

class TeamProfilePresenterTests: XCTestCase {
    
    var sut: TeamProfilePresenter!
    var vc: TeamProfileViewController!
    var authManager: MockSignedInAuthManager!
    var dbManager: MockDBManager!

    var settingsCalled: Int = 0

    override func setUp() {
        vc = TeamProfileViewController.instantiate(.team)
        let _ = vc.view
        authManager = MockSignedInAuthManager()
        dbManager = MockDBManager(authManager.currentUserUID)
        sut = TeamProfilePresenter(vc: vc, delegate: self, dbManager: dbManager)
        super.setUp()
    }

    override func tearDown() {
        sut = nil
        vc = nil
        authManager = nil
        dbManager = nil
        super.tearDown()
    }
    
    func testInitializeViewModel() throws {
        // Given sut init, then
        XCTAssertEqual(dbManager.uid, authManager.currentUserUID)
        XCTAssertEqual(1, dbManager.getDataCalled)
    }

    func testOnViewWillAppear() throws {
        // Given, sut view model is nil, when
        sut.onViewWillAppear()
        // Then
        XCTAssertTrue(vc.activityIndicator.isAnimating)
        
        // Given
        let viewModel = TeamProfileViewModel(team: TestConstants.teamName, email: TestConstants.email, image: TestConstants.teamImage!)
        sut.viewModel = viewModel
        // When
        sut.onViewWillAppear()
        // Then
        XCTAssertTrue(vc.activityIndicator.isHidden)
        XCTAssertEqual(vc.teamNameLabel.text, viewModel.teamName)
        XCTAssertEqual(vc.teamImage.image, viewModel.teamImage)
    }

    func testSettingsPressed() throws {
        XCTAssertEqual(0, settingsCalled)
        // Given
        sut.viewModel = TeamProfileViewModel(team: TestConstants.teamName, email: TestConstants.email, image: TestConstants.teamImage!)
        // When
        sut.settingsPressed()
        // Then
        XCTAssertEqual(1, settingsCalled)
    }
    
    func testDisplayDBError() throws {
        let alertVerifier = AlertVerifier()
        
        // Given
        let dbError = DBError.unknown
        // When
        sut.displayError(with: dbError)
        // Then
        alertVerifier.verify(
            title: Constants.Errors.documentErrorTitle,
            message: dbError.localizedDescription,
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
            title: Constants.Errors.documentErrorTitle,
            message: unknownError.localizedDescription,
            animated: true,
            actions: [
                .default(TestConstants.Alerts.dismiss)
            ],
            presentingViewController: vc
        )
    }
    
    // Presenter should receive an image url, but should give its VC a UIImage
    func testOnSuccessfulGet_UserModelSuccess() throws {
        // Given
        let data = [
            Constants.UserDataModel.imageURL: TestConstants.empty,
            Constants.UserDataModel.teamName: TestConstants.teamName,
            Constants.UserDataModel.email: TestConstants.email
        ]
        // When
        sut.onSuccessfulGet(data)
        // Then
        XCTAssertEqual(vc.teamNameLabel.text, TestConstants.teamName)
        XCTAssertEqual(vc.teamImage.image, TestConstants.teamImage)
        XCTAssertEqual(sut.viewModel?.email, TestConstants.email)
    }
    
    func testOnSuccessfulGet_UserModelFailure() throws {
        // Given
        let data = [String: Any]()
        // When
        sut.onSuccessfulGet(data)
        // Then
        XCTAssertEqual(vc.teamNameLabel.text, Constants.Empty.teamName)
        XCTAssertEqual(vc.teamImage.image, UIImage(named: Constants.Empty.image))
    }
}

//MARK: TeamProfilePresenterDelegate Mock
extension TeamProfilePresenterTests: TeamProfilePresenterDelegate {
    func settingsPressed(vm: TeamProfileViewModel) {
        self.settingsCalled += 1
    }
}
