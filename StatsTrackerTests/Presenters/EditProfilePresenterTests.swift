//
//  EditProfilePresenterTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 4/29/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
import ViewControllerPresentationSpy
@testable import StatsTracker

class EditProfilePresenterTests: XCTestCase {

    var sut: EditProfilePresenter!
    var vc: EditProfileViewController!
    var authManager: MockSignedInAuthManager!
    var dbManager: MockDBManager!
    
    var cancelPressedCount: Int = 0
    var savePressedCount: Int = 0
    var backToProfileCount: Int = 0
    
    override func setUp() {
        vc = EditProfileViewController.instantiate(.team)
        let _ = vc.view
        authManager = MockSignedInAuthManager()
        dbManager = MockDBManager(authManager.currentUserUID)
        sut = EditProfilePresenter(vc: vc, delegate: self, authManager: authManager, dbManager: dbManager)
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        vc = nil
        authManager = nil
        super.tearDown()
    }
    
    func testSetDBManager() throws {
        XCTAssertEqual(dbManager.uid, authManager.currentUserUID)
    }
    
    func testOnViewWillAppear() throws {
        sut.viewModel = TeamProfileViewModel(team: TestConstants.teamName, image: TestConstants.teamImage!)
        sut.onViewWillAppear()
        XCTAssertEqual(vc.teamNameTextField.text, TestConstants.teamName)
        XCTAssertEqual(vc.teamPhotoImage.image, TestConstants.teamImage)
    }
    
    func testCancelPressed() throws {
        XCTAssertEqual(0, cancelPressedCount)
        sut.cancelPressed()
        XCTAssertEqual(1, cancelPressedCount)
    }

    func testSavePressed() throws {
        XCTAssertNil(sut.viewModel)
        XCTAssertEqual(0, dbManager.storeImageDataCalled)
        let vm = TeamProfileViewModel(team: TestConstants.teamName, image: TestConstants.teamImage!)
        sut.savePressed(vm: vm)
        XCTAssertEqual(sut.viewModel.teamName, TestConstants.teamName)
        XCTAssertEqual(sut.viewModel.teamImage, TestConstants.teamImage!)
        XCTAssertEqual(1, dbManager.storeImageDataCalled)
    }
    
    func testDisplayDBError() throws {
        let alertVerifier = AlertVerifier()
        let dbError = DBError.unknown
        sut.displayError(with: dbError)
        alertVerifier.verify(
            title: Constants.Errors.userSavingError,
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
            title: Constants.Errors.userSavingError,
            message: unknownError.localizedDescription,
            animated: true,
            actions: [
                .default(TestConstants.Alerts.dismiss)
            ],
            presentingViewController: vc
        )
    }
    
    func testExecutingActionForDismissButton_shouldBackToProfile() throws {
        let alertVerifier = AlertVerifier()
        XCTAssertEqual(0, backToProfileCount)
        sut.displayError(with: TestConstants.error)
        
        try alertVerifier.executeAction(forButton: TestConstants.Alerts.dismiss)
        XCTAssertEqual(1, backToProfileCount)
    }
    
    func testStoreImageURL() throws {
        XCTAssertEqual(0, dbManager.updateDataCalled)
        sut.viewModel = TeamProfileViewModel(team: TestConstants.teamName, image: TestConstants.teamImage!)
        sut.storeImageURL(url: TestConstants.empty)
        XCTAssertEqual(1, dbManager.updateDataCalled)
    }
    
    func testNewData() throws {
        XCTAssertEqual(0, savePressedCount)
        sut.viewModel = TeamProfileViewModel(team: TestConstants.teamName, image: TestConstants.teamImage!)
        sut.newData(nil)
        XCTAssertFalse(vc.activityIndicator.isAnimating)
        XCTAssertEqual(1, savePressedCount)
    }
}

//MARK: EditProfilePresenterDelegate Mock
extension EditProfilePresenterTests: EditProfilePresenterDelegate {
    func backToProfile() {
        self.backToProfileCount += 1
    }
    
    func cancelPressed() {
        self.cancelPressedCount += 1
    }
    
    func savePressed(vm: TeamProfileViewModel) {
        self.savePressedCount += 1
    }
}
