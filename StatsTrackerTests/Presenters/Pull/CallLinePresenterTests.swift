//
//  CallLinePresenterTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 5/17/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
import ViewControllerPresentationSpy
@testable import StatsTracker

class CallLinePresenterTests: XCTestCase {
    
    var sut: CallLinePresenter!
    var vc: CallLineViewControllerSpy!
    var dbManager: MockDBManager!
    var gameModel: GameDataModel!
    
    private var endGameCount: Int = 0
    
    override func setUp() {
        vc = CallLineViewControllerSpy()
        dbManager = MockDBManager()
        gameModel = GameDataModel(id: TestConstants.empty, tournament: TestConstants.empty, opponent: TestConstants.empty)
        sut = CallLinePresenter(vc: vc, delegate: self, gameModel: gameModel, dbManager: dbManager)
        vc.presenter = sut
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        vc = nil
        dbManager = nil
        gameModel = nil
        super.tearDown()
    }
    
    func testOnViewWillAppear() throws {
        XCTAssertEqual(0, vc.showCallLineCalled)
        // When
        sut.onViewWillAppear()
        // Then
        XCTAssertEqual(1, vc.showCallLineCalled)
    }
    
    func testFetchRoster() throws {
        // Given sut init, then
        XCTAssertEqual(1, dbManager.getDataCalled)
    }
    
    func testStartPoint_fullLine() throws {
        XCTAssertEqual(0, vc.showPlayPointCalled)
        // Given
        vc.fullLineBool = true
        // When
        sut.startPoint()
        // Then
        XCTAssertEqual(1, vc.showPlayPointCalled)
    }
    
    func testStartPoint_notFullLine() throws {
        let alertVerifier = AlertVerifier()
        
        // Given
        vc.fullLineBool = false
        // When
        sut.startPoint()
        // Then
        alertVerifier.verify(
            title: Constants.Alerts.startGameTitle,
            message: Constants.Alerts.startGameAlert,
            animated: true,
            actions: [
                .destructive(TestConstants.Alerts.cancel),
                .default(TestConstants.Alerts.confirm),
            ],
            presentingViewController: vc
        )
    }
    
    func testExecutingActionForConfirmButton_shouldStartPoint() throws {
        let alertVerifier = AlertVerifier()
        XCTAssertEqual(0, vc.showPlayPointCalled)
        
        // Given
        vc.fullLineBool = false
        // When
        sut.startPoint()
        // When
        try alertVerifier.executeAction(forButton: TestConstants.Alerts.confirm)
        // Then
        XCTAssertEqual(1, vc.showPlayPointCalled)
    }
    
    func testNextPoint_scoredTrueUpdateModel() throws {
        XCTAssertEqual(0, sut.gameModel.finalScore.team)
        XCTAssertEqual(0, sut.gameModel.finalScore.opponent)
        XCTAssertEqual(0, sut.gameModel.points.count)
        // Given
        sut.currentPointWind = .upwind
        sut.currentPointType = .offensive
        sut.vc.viewModel = CallLineCellViewModel(playerArray: [[], [], []], delegate: self)
        // When
        sut.nextPoint(scored: true)
        // Then
        XCTAssertEqual(1, sut.gameModel.finalScore.team)
        XCTAssertEqual(0, sut.gameModel.finalScore.opponent)
        XCTAssertEqual(1, sut.gameModel.points.count)
    }
    
    func testNextPoint_scoredFalseUpdateModel() throws {
        XCTAssertEqual(0, sut.gameModel.finalScore.team)
        XCTAssertEqual(0, sut.gameModel.finalScore.opponent)
        XCTAssertEqual(0, sut.gameModel.points.count)
        // Given
        sut.currentPointWind = .downwind
        sut.currentPointType = .defensive
        sut.vc.viewModel = CallLineCellViewModel(playerArray: [[], [], []], delegate: self)
        // When
        sut.nextPoint(scored: false)
        // Then
        XCTAssertEqual(0, sut.gameModel.finalScore.team)
        XCTAssertEqual(1, sut.gameModel.finalScore.opponent)
        XCTAssertEqual(1, sut.gameModel.points.count)
    }
    
    func testNextPoint_updateView() throws {
        XCTAssertEqual(0, vc.updateViewCalled)
        XCTAssertEqual(0, vc.showCallLineCalled)
        // Given
        sut.currentPointWind = .upwind
        sut.currentPointType = .offensive
        sut.vc.viewModel = CallLineCellViewModel(playerArray: [[], [], []], delegate: self)
        // When
        sut.nextPoint(scored: true)
        // Then
        XCTAssertEqual(1, vc.updateViewCalled)
        XCTAssertEqual(1, vc.showCallLineCalled)
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
        XCTAssertNil(sut.vc.viewModel)
        
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
        XCTAssertNotNil(sut.vc.viewModel)
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
    
    func testEndGame() throws {
        let alertVerifier = AlertVerifier()
        XCTAssertEqual(0, dbManager.setDataCalled)
        
        // Given
        let model = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])
        let items = [[], [PlayerViewModel(model: model)], []]
        let numPlayers = 1
        // When
        sut.endGame(items: items)
        // Then
        XCTAssertEqual(numPlayers + 1, dbManager.setDataCalled)
        
        alertVerifier.verify(
            title: Constants.Alerts.endGameTitle,
            message: Constants.Alerts.successfulRecordAlert,
            animated: true,
            actions: [
                .default(TestConstants.Alerts.okay)
            ],
            presentingViewController: vc
        )
    }
    
    func testExecutingActionForConfirmButton_shouldEndGame() throws {
        let alertVerifier = AlertVerifier()
        XCTAssertEqual(0, endGameCount)
        
        // Given
        let model = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])
        let items = [[], [PlayerViewModel(model: model)], []]
        // When
        sut.endGame(items: items)
        // When
        try alertVerifier.executeAction(forButton: TestConstants.Alerts.okay)
        // Then
        XCTAssertEqual(1, endGameCount)
    }
}

//MARK: CallLinePresenterDelegate
extension CallLinePresenterTests: CallLinePresenterDelegate {
    func endGame() {
        endGameCount += 1
    }
}

extension CallLinePresenterTests: CallLineCellViewModelDelegate {
    func endGame(items: [[PlayerViewModel]]) { }
}

//MARK: CallLineViewControllerSpy
class CallLineViewControllerSpy: CallLineViewController {
    
    var updateViewCalled: Int = 0
    var showPlayPointCalled: Int = 0
    var showCallLineCalled: Int = 0
    var fullLineCalled: Int = 0
    var fullLineBool: Bool = false
    
    override func updateView() {
        updateViewCalled += 1
    }
    
    override func showPlayPoint() {
        showPlayPointCalled += 1
    }
    
    override func showCallLine() {
        showCallLineCalled += 1
    }
    
    override func fullLine() -> Bool {
        fullLineCalled += 1
        
        return fullLineBool ? true : false
    }
}
