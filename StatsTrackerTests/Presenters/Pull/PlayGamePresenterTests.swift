//
//  PlayGamePresenterTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 6/25/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
import ViewControllerPresentationSpy
@testable import StatsTracker

class PlayGamePresenterTests: XCTestCase {
    
    var sut: PlayGamePresenter!
    var vc: PlayGameViewController!
    var gameModel: GameDataModel!
    var dbManager: MockDBManager!
    
    private var startPointCalled: Int = 0
    private var endGameCalled: Int = 0
    
    override func setUp() {
        vc = PlayGameViewController.instantiate(.pull)
        gameModel = GameDataModel(id: TestConstants.empty, tournament: TestConstants.tournamentName, opponent: TestConstants.teamName)
        dbManager = MockDBManager()
        sut = PlayGamePresenter(vc: vc, delegate: self, gameModel: gameModel, dbManager: dbManager)
        vc.presenter = sut
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        vc = nil
        gameModel = nil
        dbManager = nil
        super.tearDown()
    }
    
    func testSetViewModel() throws {
        // Given sut init, then
        XCTAssertEqual(1, dbManager.getDataCalled)
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
    
    func testOnSuccessfulGet_PlayerModelSuccess() throws {
        XCTAssertEqual(0, startPointCalled)
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
        XCTAssertEqual(1, startPointCalled)
    }
    
    func testOnSuccessfulGet_PlayerModelFailure() throws {
        XCTAssertEqual(0, startPointCalled)
        // Given
        let playerDictionary = ["": ""]
        let data = [
            FirebaseKeys.CollectionPath.women: [playerDictionary],
            FirebaseKeys.CollectionPath.men: [playerDictionary]
        ]
        // When
        sut.onSuccessfulGet(data)
        // Then
        XCTAssertEqual(1, startPointCalled)
    }
    
    func testEndGame() throws {
        XCTAssertEqual(0, endGameCalled)
        XCTAssertEqual(0, dbManager.setDataCalled)
        // Given
        let model = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])
        let items = [[], [PlayerViewModel(model: model)], []]
        let numPlayers = 1
        // When
        sut.endGame(items: items)
        // Then
        XCTAssertEqual(1, endGameCalled)
        XCTAssertEqual(numPlayers + 1, dbManager.setDataCalled)
    }
}

//MARK: PlayGamePresenterDelegate
extension PlayGamePresenterTests: PlayGamePresenterDelegate {
    
    func startPoint(vm: CallLineCellViewModel) {
        startPointCalled += 1
    }
    
    func endGame() {
        endGameCalled += 1
    }
}
