//
//  PlayGamePresenterTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 5/17/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
import ViewControllerPresentationSpy
@testable import StatsTracker

class PlayGamePresenterTests: XCTestCase {
    
    var sut: PlayGamePresenter!
    var vc: PlayGameViewControllerSpy!
    var dbManager: MockDBManager!
    var gameModel: GameDataModel!
    let selectedSection = 0
    let womenSection = Gender.women.rawValue + 1
    let menSection = Gender.men.rawValue + 1
    
    var endGameCount: Int = 0
    
    override func setUp() {
        vc = PlayGameViewControllerSpy()
        dbManager = MockDBManager()
        gameModel = GameDataModel(id: TestConstants.empty, tournament: TestConstants.empty, opponent: TestConstants.empty)
        sut = PlayGamePresenter(vc: vc, delegate: self, gameModel: gameModel, dbManager: dbManager)
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
        sut.playerModels = [[], [], []]
        for _ in 1...7 {
            sut.playerModels![selectedSection].append(PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: []))
        }
        // When
        sut.startPoint()
        // Then
        XCTAssertEqual(1, vc.showPlayPointCalled)
    }
    
    func testStartPoint_notFullLine() throws {
        let alertVerifier = AlertVerifier()
        
        // Given
        sut.playerModels = [[], [], []]
        for _ in 1...2 {
            sut.playerModels![selectedSection].append(PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: []))
        }
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
        sut.playerModels = [[], [], []]
        for _ in 1...2 {
            sut.playerModels![selectedSection].append(PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: []))
        }
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
        sut.playerModels = [[], [], []]
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
        sut.playerModels = [[], [], []]
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
        sut.playerModels = [[], [], []]
        for _ in 1...2 {
            sut.playerModels![selectedSection].append(PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: []))
        }
        sut.currentPointWind = .upwind
        sut.currentPointType = .offensive
        // When
        sut.nextPoint(scored: true)
        // Then
        XCTAssertEqual(0, sut.playerModels![selectedSection].count)
        XCTAssertEqual(2, sut.playerModels![1].count)
        XCTAssertEqual(1, vc.updateViewCalled)
        XCTAssertEqual(1, vc.showCallLineCalled)
    }
    
    func testNumberOfPlayersInSection_EmptyModels() throws {
        // When
        sut.playerModels = nil
        // Then
        XCTAssertEqual(Constants.Empty.int, sut.numberOfPlayersInSection(womenSection))
        XCTAssertEqual(Constants.Empty.int, sut.numberOfPlayersInSection(menSection))
    }
    
    func testNumberOfPlayersInSection_NonEmptySection() throws {
        // Given
        let women: [PlayerModel] = [PlayerModel(name: "Woman1", gender: Gender.women.rawValue, id: TestConstants.empty, roles: []),
                                    PlayerModel(name: "Woman2", gender: Gender.women.rawValue, id: TestConstants.empty, roles: [])]
        let men: [PlayerModel] = [PlayerModel(name: "Man", gender: Gender.men.rawValue, id: TestConstants.empty, roles: [])]
        // When
        sut.playerModels = [[], women, men]
        // Then
        XCTAssertEqual(0, sut.numberOfPlayersInSection(selectedSection))
        XCTAssertEqual(women.count, sut.numberOfPlayersInSection(womenSection))
        XCTAssertEqual(men.count, sut.numberOfPlayersInSection(menSection))
    }
    
    func testNumberOfPlayersInSection_OutOfBounds() throws {
        // Given
        let array1: [PlayerModel] = []
        let array2: [PlayerModel] = []
        let sectionGreaterThan = 2
        let sectionLessThan = -1
        // When
        sut.playerModels = [[], array1, array2]
        // Then
        XCTAssertEqual(Constants.Empty.int, sut.numberOfPlayersInSection(sectionGreaterThan))
        XCTAssertEqual(Constants.Empty.int, sut.numberOfPlayersInSection(sectionGreaterThan))
        XCTAssertEqual(Constants.Empty.int, sut.numberOfPlayersInSection(sectionLessThan))
        XCTAssertEqual(Constants.Empty.int, sut.numberOfPlayersInSection(sectionLessThan))
    }
    
    func testGetPlayerName() throws {
        // Given
        sut.playerModels = [[], [PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])], []]
        // When
        let name = sut.getPlayerName(at: IndexPath(row: 0, section: 1))
        // Then
        XCTAssertEqual(TestConstants.playerName, name)
    }
    
    func testGetPlayerName_OutOfBounds() throws {
        // Given
        sut.playerModels = [[], [PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])], []]
        // When
        let name = sut.getPlayerName(at: IndexPath(row: 1, section: womenSection))
        // Then
        XCTAssertEqual(TestConstants.empty, name)
    }
    
    func testSelectPlayer_Selecting() throws {
        // Given
        sut.playerModels = [[], [PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])], []]
        let indexPath = IndexPath(row: 0, section: womenSection)
        // When
        let newIndexPath = sut.selectPlayer(at: indexPath)
        // Then
        XCTAssertEqual(newIndexPath, IndexPath(row: 0, section: selectedSection))
    }
    
    func testSelectPlayer_Deselecting() throws {
        // Given
        sut.playerModels = [[PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])], [], []]
        let indexPath = IndexPath(row: 0, section: selectedSection)
        // When
        let newIndexPath = sut.selectPlayer(at: indexPath)
        // Then
        XCTAssertEqual(newIndexPath, IndexPath(row: 0, section: womenSection))
    }
    
    func testSelectPlayer_FullLine() throws {
        // Given
        sut.playerModels = [[], [PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])], []]
        for _ in 1...7 {
            sut.playerModels![selectedSection].append(PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: []))
        }
        let indexPath = IndexPath(row: 0, section: womenSection)
        // When
        let newIndexPath = sut.selectPlayer(at: indexPath)
        // Then
        XCTAssertNil(newIndexPath)
    }
    
    func testEndGame() throws {
        XCTAssertEqual(0, dbManager.setDataCalled)
        // Given
        let women: [PlayerModel] = [PlayerModel(name: "Woman1", gender: Gender.women.rawValue, id: TestConstants.empty, roles: []),
                                    PlayerModel(name: "Woman2", gender: Gender.women.rawValue, id: TestConstants.empty, roles: [])]
        let men: [PlayerModel] = [PlayerModel(name: "Man", gender: Gender.men.rawValue, id: TestConstants.empty, roles: [])]
        let numPlayers = 3
        // When
        sut.playerModels = [[], women, men]
        // When
        sut.endGame()
        // Then
        XCTAssertEqual(numPlayers + 1, dbManager.setDataCalled)
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
        XCTAssertNil(sut.playerModels)
        
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
        XCTAssertNotNil(sut.playerModels)
    }
    
    func testOnSuccessfulGet_PlayerModelSuccess() throws {
        XCTAssertEqual(0, vc.updateViewCalled)
        // Given
        sut.playerModels = [[], [], []]
        let womanModel = PlayerModel(name: "Woman", gender: Gender.women.rawValue, id: TestConstants.empty, roles: [])
        let manModel = PlayerModel(name: "Man", gender: Gender.men.rawValue, id: TestConstants.empty, roles: [])
        let data = [
            FirebaseKeys.CollectionPath.women: [womanModel.dictionary],
            FirebaseKeys.CollectionPath.men: [manModel.dictionary]
        ]
        // When
        sut.onSuccessfulGet(data)
        // Then
        XCTAssertEqual(0, sut.playerModels![selectedSection].count)
        XCTAssertEqual(1, sut.playerModels![womenSection].count)
        XCTAssertEqual(1, sut.playerModels![menSection].count)
        XCTAssertEqual(womanModel.name, sut.playerModels![womenSection][0].name)
        XCTAssertEqual(manModel.name, sut.playerModels![menSection][0].name)
        XCTAssertEqual(1, vc.updateViewCalled)
    }
    
    func testOnSuccessfulGet_PlayerModelFailure() throws {
        XCTAssertEqual(0, vc.updateViewCalled)
        // Given
        sut.playerModels = [[], [],[]]
        let playerDictionary = ["": ""]
        let data = [
            FirebaseKeys.CollectionPath.women: [playerDictionary],
            FirebaseKeys.CollectionPath.men: [playerDictionary]
        ]
        // When
        sut.onSuccessfulGet(data)
        // Then
        XCTAssertEqual(0, sut.playerModels![selectedSection].count)
        XCTAssertEqual(0, sut.playerModels![womenSection].count)
        XCTAssertEqual(0, sut.playerModels![menSection].count)
        XCTAssertEqual(1, vc.updateViewCalled)
    }
    
    func testOnSuccessfulSet() throws {
        let alertVerifier = AlertVerifier()
        
        // Given
        sut.playerModels = [[], [], []]
        // When
        sut.onSuccessfulSet()
        // Then
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
        sut.playerModels = [[], [], []]
        // When
        sut.onSuccessfulSet()
        // When
        try alertVerifier.executeAction(forButton: TestConstants.Alerts.okay)
        // Then
        XCTAssertEqual(1, endGameCount)
    }
}

//MARK: PlayGamePresenterDelegate
extension PlayGamePresenterTests: PlayGamePresenterDelegate {
    func endGame() {
        endGameCount += 1
    }
}

//MARK: RosterViewControllerSpy
class PlayGameViewControllerSpy: PlayGameViewController {
    var updateViewCalled: Int = 0
    var showPlayPointCalled: Int = 0
    var showCallLineCalled: Int = 0
    
    override func updateView() {
        updateViewCalled += 1
    }
    
    override func showPlayPoint() {
        showPlayPointCalled += 1
    }
    
    override func showCallLine() {
        showCallLineCalled += 1
    }
}
