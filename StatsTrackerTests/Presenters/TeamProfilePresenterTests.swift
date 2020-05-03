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
        dbManager = MockDBManager()
        sut = TeamProfilePresenter(vc: vc, delegate: self, authManager: authManager, dbManager: dbManager)
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
        XCTAssertEqual(dbManager.uid, authManager.currentUserUID)
        XCTAssertEqual(1, dbManager.getDataCalled)
    }

    func testOnViewWillAppear() throws {
        sut.onViewWillAppear()
        XCTAssertTrue(vc.activityIndicator.isAnimating)
        sut.viewModel = TeamProfileViewModel(team: TestConstants.teamName, image: TestConstants.teamImage!)
        sut.onViewWillAppear()
        XCTAssertTrue(vc.activityIndicator.isHidden)
        XCTAssertEqual(vc.teamNameLabel.text, TestConstants.teamName)
        XCTAssertEqual(vc.teamImage.image, TestConstants.teamImage)
    }

    func testSettingsPressed() throws {
        XCTAssertEqual(0, settingsCalled)
        sut.viewModel = TeamProfileViewModel(team: TestConstants.teamName, image: TestConstants.teamImage!)
        sut.settingsPressed()
        XCTAssertEqual(1, settingsCalled)
    }
    
    func testDisplayDBError() throws {
        let alertVerifier = AlertVerifier()
        let dbError = DBError.unknown
        sut.displayError(with: dbError)
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
        let unknownError = TestConstants.error
        sut.displayError(with: unknownError)
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
    
    func testNewData() throws {
        // Presenter should receive an image url, but should give its VC a UIImage
        sut.newData([
            Constants.UserDataModel.imageURL: TestConstants.empty,
            Constants.UserDataModel.teamName: TestConstants.teamName
        ])
        XCTAssertEqual(vc.teamNameLabel.text, TestConstants.teamName)
        XCTAssertEqual(vc.teamImage.image, TestConstants.teamImage)
    }
}

//MARK: TeamProfilePresenterDelegate Mock
extension TeamProfilePresenterTests: TeamProfilePresenterDelegate {
    func settingsPressed(vm: TeamProfileViewModel) {
        self.settingsCalled += 1
    }
}
