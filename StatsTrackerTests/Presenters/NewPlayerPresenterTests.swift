//
//  NewPlayerPresenterTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 5/11/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
import ViewControllerPresentationSpy
@testable import StatsTracker

class NewPlayerPresenterTests: XCTestCase {

    var sut: NewPlayerPresenter!
    var vc: NewPlayerViewController!
    var dbManager: MockDBManager!
    
    var cancelPressedCount: Int = 0
    var savePressedCount: Int = 0
    
    override func setUp() {
        vc = NewPlayerViewController.instantiate(.roster)
        let _ = vc.view
        dbManager = MockDBManager()
        sut = NewPlayerPresenter(vc: vc, delegate: self, dbManager: dbManager)
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        vc = nil
        dbManager = nil
        super.tearDown()
    }
    
    func testOnViewWillAppear() throws {
        XCTAssertEqual(vc.navigationItem.title, nil)
        // When
        sut.onViewWillAppear()
        // Then
        XCTAssertEqual(vc.navigationItem.title, Constants.Titles.newPlayerTitle)
    }
    
    func testCancelPressed() throws {
        XCTAssertEqual(0, cancelPressedCount)
        // When
        sut.cancelPressed()
        // Then
        XCTAssertEqual(1, cancelPressedCount)
    }
    
    func testSavePressed() throws {
        XCTAssertEqual(0, savePressedCount)
        XCTAssertNil(sut.model)
        // Given
        let name = "Woman"
        let model = PlayerModel(name: name, gender: Gender.women.rawValue, id: TestConstants.empty)
        // When
        sut.savePressed(model: model)
        // Then
        XCTAssertEqual(0, savePressedCount)
        XCTAssertNotNil(sut.model)
        XCTAssertEqual(name, sut.model?.name)
    }
    
    func testDisplaySavingError() throws {
        let alertVerifier = AlertVerifier()
        
        // When
        sut.displaySavingError()
        // Then
        alertVerifier.verify(
            title: Constants.Errors.userSavingError,
            message: Constants.Errors.userSavingError,
            animated: true,
            actions: [
                .default(TestConstants.Alerts.dismiss)
            ],
            presentingViewController: vc
        )
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
    
    func testOnSuccessfulSet_Model() throws {
        XCTAssertEqual(0, savePressedCount)
        // Given
        let model = PlayerModel(name: "Woman", gender: Gender.women.rawValue, id: TestConstants.empty)
        // When
        sut.model = model
        sut.onSuccessfulSet()
        // Then
        XCTAssertEqual(1, savePressedCount)
    }
    
    func testOnSuccessfulSet_NoModel() throws {
        let alertVerifier = AlertVerifier()
        XCTAssertNil(sut.model)
        // When
        sut.onSuccessfulSet()
        // Then
        alertVerifier.verify(
            title: Constants.Errors.userSavingError,
            message: Constants.Errors.userSavingError,
            animated: true,
            actions: [
                .default(TestConstants.Alerts.dismiss)
            ],
            presentingViewController: vc
        )
    }
}

extension NewPlayerPresenterTests: NewPlayerPresenterDelegate {
    func cancelPressed() {
        cancelPressedCount += 1
    }
    
    func savePressed(player: PlayerModel) {
        savePressedCount += 1
    }
}
