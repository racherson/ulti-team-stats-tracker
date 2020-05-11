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
        sut = EditProfilePresenter(vc: vc, delegate: self, dbManager: dbManager)
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        vc = nil
        authManager = nil
        dbManager = nil
        super.tearDown()
    }
    
    func testSetDBManager() throws {
        // Given sut init, then
        XCTAssertEqual(dbManager.uid, authManager.currentUserUID)
    }
    
    func testOnViewWillAppear() throws {
        // Given
        let viewModel = TeamProfileViewModel(team: TestConstants.teamName, email: TestConstants.email, image: TestConstants.teamImage!)
        sut.viewModel = viewModel
        // When
        sut.onViewWillAppear()
        // Then
        XCTAssertEqual(vc.teamNameTextField.text, TestConstants.teamName)
        XCTAssertEqual(vc.teamPhotoImage.image, TestConstants.teamImage)
    }
    
    func testCancelPressed() throws {
        XCTAssertEqual(0, cancelPressedCount)
        // When
        sut.cancelPressed()
        // Then
        XCTAssertEqual(1, cancelPressedCount)
    }

    func testSavePressed() throws {
        XCTAssertNil(sut.viewModel)
        XCTAssertEqual(0, dbManager.storeImageDataCalled)
        // Given
        let vm = TeamProfileViewModel(team: TestConstants.teamName, email: TestConstants.email, image: TestConstants.teamImage!)
        // When
        sut.savePressed(vm: vm)
        // Then
        XCTAssertEqual(sut.viewModel.teamName, TestConstants.teamName)
        XCTAssertEqual(sut.viewModel.teamImage, TestConstants.teamImage!)
        XCTAssertEqual(sut.viewModel.email, TestConstants.email)
        XCTAssertEqual(1, dbManager.storeImageDataCalled)
    }
    
    func testDisplayDBError() throws {
        let alertVerifier = AlertVerifier()
        
        // Given
        let dbError = DBError.unknown
        // When
        sut.displayError(with: dbError)
        // Then
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
        
        // Given
        let unknownError = TestConstants.error
        // When
        sut.displayError(with: unknownError)
        // Then
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
        
        // Given
        let error = TestConstants.error
        sut.displayError(with: error)
        // When
        try alertVerifier.executeAction(forButton: TestConstants.Alerts.dismiss)
        // Then
        XCTAssertEqual(1, backToProfileCount)
    }
    
    func testStoreImageURL() throws {
        XCTAssertEqual(0, dbManager.setDataCalled)
        XCTAssertNil(dbManager.setDictionary)
        // Given
        let viewModel = TeamProfileViewModel(team: TestConstants.teamName, email: TestConstants.email, image: TestConstants.teamImage!)
        sut.viewModel = viewModel
        // When
        sut.storeImageURL(url: TestConstants.empty)
        // Then
        XCTAssertEqual(1, dbManager.setDataCalled)
        XCTAssertNotNil(dbManager.setDictionary)
        XCTAssertEqual(TestConstants.email, dbManager.setDictionary![Constants.UserDataModel.email] as! String)
        XCTAssertEqual(TestConstants.teamName, dbManager.setDictionary![Constants.UserDataModel.teamName] as! String)
        XCTAssertEqual(TestConstants.empty, dbManager.setDictionary![Constants.UserDataModel.imageURL] as! String)
    }
    
    func testOnSuccessfulSet() throws {
        XCTAssertEqual(0, savePressedCount)
        // Given
        let viewModel = TeamProfileViewModel(team: TestConstants.teamName, email: TestConstants.email, image: TestConstants.teamImage!)
        sut.viewModel = viewModel
        // When
        sut.onSuccessfulSet()
        // Then
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
