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
    
    var addPressedCount: Int = 0
    var playerPageCount: Int = 0
    var vmName: String?
    var vmGender: Gender?
    
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
        XCTAssertEqual(0, playerPageCount)
        // Given
        let model = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])
        let viewModel = PlayerViewModel(model: model)
        // When
        sut.goToPlayerPage(viewModel: viewModel)
        // Then
        XCTAssertEqual(1, playerPageCount)
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
        sut.deletePlayer(PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: []))
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
        let womanModel = PlayerModel(name: "Woman", gender: Gender.women.rawValue, id: TestConstants.empty, roles: [])
        let manModel = PlayerModel(name: "Man", gender: Gender.men.rawValue, id: TestConstants.empty, roles: [])
        let data = [
            FirebaseKeys.CollectionPath.women: [womanModel.dictionary],
            FirebaseKeys.CollectionPath.men: [manModel.dictionary]
        ]
        // When
        sut.onSuccessfulGet(data)
        // Then
        XCTAssertEqual(1, vc.updateViewCalled)
        XCTAssertEqual(1, vc.viewModel.items[Gender.women.rawValue].count)
        XCTAssertEqual(1, vc.viewModel.items[Gender.men.rawValue].count)
        XCTAssertEqual(womanModel.name, vc.viewModel.items[Gender.women.rawValue][0].name)
        XCTAssertEqual(manModel.name, vc.viewModel.items[Gender.men.rawValue][0].name)
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
        XCTAssertEqual(0, vc.viewModel.items[Gender.women.rawValue].count)
        XCTAssertEqual(0, vc.viewModel.items[Gender.men.rawValue].count)
        XCTAssertEqual(1, vc.updateViewCalled)
    }
}

//MARK: RosterPresenterDelegate
extension RosterPresenterTests: RosterPresenterDelegate {
    func addPressed() {
        addPressedCount += 1
    }
    
    func goToPlayerPage(viewModel: PlayerViewModel) {
        playerPageCount += 1
        vmName = viewModel.name
        vmGender = viewModel.gender
    }
}

//MARK: RosterViewControllerSpy
class RosterViewControllerSpy: RosterViewController {
    var updateViewCalled: Int = 0
    
    override func updateWithViewModel(vm: RosterCellViewModel) {
        updateViewCalled += 1
        viewModel = vm
    }
}
