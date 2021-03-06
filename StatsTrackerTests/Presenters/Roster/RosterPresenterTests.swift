//
//  RosterPresenterTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 5/10/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
import ViewControllerPresentationSpy
@testable import StatsTracker

class RosterPresenterTests: XCTestCase {

    var sut: RosterPresenter!
    var vc: RosterViewControllerSpy!
    var dbManager: MockDBManager!
    
    private var addPressedCount: Int = 0
    private var goToPlayerPageCount: Int = 0
    
    private var vmName: String?
    private var vmGender: Gender?
    
    override func setUp() {
        vc = RosterViewControllerSpy()
        dbManager = MockDBManager()
        sut = RosterPresenter(vc: vc, delegate: self, dbManager: dbManager)
        vc.presenter = sut
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
        XCTAssertEqual(vc.navigationItem.title, Constants.Titles.rosterTitle)
    }
    
    func testSetViewModel() throws {
        // Given sut init, then
        XCTAssertEqual(1, dbManager.getDataCalled)
    }
    
    func testGoToPlayerPage() throws {
        XCTAssertEqual(0, goToPlayerPageCount)
        // Given
        let viewModel = Instance.ViewModel.player()
        // When
        sut.goToPlayerPage(viewModel: viewModel)
        // Then
        XCTAssertEqual(1, goToPlayerPageCount)
    }
    
    func testAddPressed() throws {
        XCTAssertEqual(0, addPressedCount)
        // When
        sut.addPressed()
        // Then
        XCTAssertEqual(1, addPressedCount)
    }
    
    func testDeletePlayer() throws {
        XCTAssertEqual(0, dbManager.deleteDataCalled)
        // When
        sut.deletePlayer(Instance.getPlayerModel())
        // Then
        XCTAssertEqual(1, dbManager.deleteDataCalled)
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
        XCTAssertNil(vc.viewModel)
        
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
        XCTAssertNotNil(vc.viewModel)
    }
    
    func testOnSuccessfulGet_PlayerModelSuccess() throws {
        XCTAssertEqual(0, vc.updateViewCalled)
        // Given
        vc.viewModel = nil
        let womanModel = Instance.getPlayerModel(.women)
        let manModel = Instance.getPlayerModel(.men)
        let data = [
            FirebaseKeys.CollectionPath.women: [womanModel.dictionary],
            FirebaseKeys.CollectionPath.men: [manModel.dictionary]
        ]
        // When
        sut.onSuccessfulGet(data)
        // Then
        XCTAssertEqual(1, vc.updateViewCalled)
    }
    
    func testOnSuccessfulGet_PlayerModelFailure() throws {
        XCTAssertEqual(0, vc.updateViewCalled)
        // Given
        let playerDictionary = ["": ""]
        let data = [
            FirebaseKeys.CollectionPath.women: [playerDictionary],
            FirebaseKeys.CollectionPath.men: [playerDictionary]
        ]
        // When
        sut.onSuccessfulGet(data)
        // Then
        XCTAssertEqual(1, vc.updateViewCalled)
    }
}

//MARK: RosterPresenterDelegate
extension RosterPresenterTests: RosterPresenterDelegate {
    func addPressed() {
        addPressedCount += 1
    }
    
    func goToPlayerPage(viewModel: PlayerViewModel) {
        goToPlayerPageCount += 1
        vmName = viewModel.name
        vmGender = viewModel.gender
    }
}

//MARK: RosterViewControllerSpy
class RosterViewControllerSpy: RosterViewController {
    var updateViewCalled: Int = 0
    
    override func updateWithViewModel(vm: RosterCellViewModelProtocol) {
        updateViewCalled += 1
        viewModel = vm
    }
}
