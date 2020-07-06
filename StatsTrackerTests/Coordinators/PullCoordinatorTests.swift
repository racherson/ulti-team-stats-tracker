//
//  PullCoordinatorTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 4/28/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
import ViewControllerPresentationSpy
@testable import StatsTracker

class PullCoordinatorTests: XCTestCase {
    
    var pullCoordinator: PullCoordinator!
    var navigationController: MockNavigationController!
    var lineNavigationController: MockNavigationController!
    var pullNavigationController: MockNavigationController!
    var vc: PlayGameViewController!
    var gameModel: GameDataModel!
    var viewModel: CallLineCellViewModel!
    
    private var endGameCalled: Int = 0
    private var reloadGamesCalled: Int = 0
    
    override func setUp() {
        navigationController = MockNavigationController()
        pullCoordinator = PullCoordinator(navigationController: navigationController)
        vc = PlayGameViewController.instantiate(.pull)
        lineNavigationController = MockNavigationController(rootViewController: vc)
        pullNavigationController = MockNavigationController(rootViewController: vc)
        gameModel = GameDataModel(id: TestConstants.empty, tournament: TestConstants.tournamentName, opponent: TestConstants.teamName)
        viewModel = CallLineCellViewModel(playerArray: [[], [], []], delegate: self)
        pullCoordinator.lineNavigationController = lineNavigationController
        pullCoordinator.pullNavigationController = pullNavigationController
        pullCoordinator.gameModel = gameModel
        pullCoordinator.lineViewModel = viewModel
        pullCoordinator.delegate = self
        super.setUp()
    }
    
    override func tearDown() {
        pullCoordinator = nil
        navigationController = nil
        lineNavigationController = nil
        pullNavigationController = nil
        vc = nil
        gameModel = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testStart() throws {
        XCTAssertEqual(0, navigationController.pushCallCount)
        XCTAssertNil(navigationController.pushedController)
        // When
        pullCoordinator.start()
        // Then
        XCTAssertEqual(1, navigationController.pushCallCount)
        XCTAssertTrue(navigationController.pushedController is PullViewController)
        XCTAssertTrue(navigationController.navigationBar.prefersLargeTitles)
    }
    
    func testStartGamePressed() throws {
        XCTAssertEqual(0, navigationController.presentCalledCount)
        // Given
        let game = GameDataModel(id: TestConstants.empty, tournament: TestConstants.empty, opponent: TestConstants.empty)
        let wind = WindDirection(rawValue: 0)!
        let point = PointType(rawValue: 0)!
        // When
        pullCoordinator.startGamePressed(gameModel: game, wind: wind, point: point)
        // Then
        XCTAssertEqual(1, navigationController.presentCalledCount)
        XCTAssertEqual(.fullScreen, navigationController.presentationStyle)
        XCTAssertTrue(pullNavigationController.topViewController is PlayGameViewController)
    }
    
    func testStartPoint() throws {
        pullCoordinator.lineViewModel = nil
        XCTAssertNil(pullCoordinator.lineViewModel)
        XCTAssertEqual(0, pullNavigationController.presentCalledCount)
        // Given
        let model = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])
        let vm = CallLineCellViewModel(playerArray: [[], [model], []], delegate: self)
        // When
        pullCoordinator.startPoint(vm: vm)
        // Then
        XCTAssertNotNil(pullCoordinator.lineViewModel)
        XCTAssertEqual(1, pullNavigationController.presentCalledCount)
        XCTAssertEqual(.fullScreen, pullNavigationController.presentationStyle)
    }
    
    func testEndGame() throws {
        let alertVerifier = AlertVerifier()
        
        // When
        lineNavigationController.pushViewController(vc, animated: false)
        pullCoordinator.endGame()
        // Then
        XCTAssertNotNil(lineNavigationController.topViewController)
        alertVerifier.verify(
            title: Constants.Alerts.endGameTitle,
            message: Constants.Alerts.successfulRecordAlert,
            animated: true,
            actions: [
                .default(Constants.Alerts.okay)
            ],
            presentingViewController: lineNavigationController.topViewController
        )
    }
    
    func testExecutingActionForOkayButton_shouldEndGame() throws {
        let alertVerifier = AlertVerifier()
        XCTAssertEqual(0, navigationController.dismissCallCount)
        XCTAssertEqual(0, reloadGamesCalled)
        
        // When
        lineNavigationController.pushViewController(vc, animated: false)
        pullCoordinator.endGame()
        // When
        try alertVerifier.executeAction(forButton: Constants.Alerts.okay)
        // Then
        XCTAssertEqual(1, navigationController.dismissCallCount)
        XCTAssertEqual(1, reloadGamesCalled)
    }
    
    func testPlayPoint_offense() throws {
        XCTAssertEqual(0, pullNavigationController.dismissCallCount)
        // Given
        setUpwindOffense()
        pullCoordinator.lineViewModel = Instance.ViewModel.callLineEmpty(delegate: self)
        // When
        pullCoordinator.playPoint()
        // Then
        XCTAssertTrue(vc.viewModel is PlayGameOffenseCellViewModel)
        XCTAssertEqual(1, pullNavigationController.dismissCallCount)
    }
    
    func testPlayPoint_defense() throws {
        // Given
        setDownwindDefense()
        pullCoordinator.lineViewModel = Instance.ViewModel.callLineEmpty(delegate: self)
        // When
        pullCoordinator.playPoint()
        // Then
        XCTAssertTrue(vc.viewModel is PlayGameDefenseCellViewModel)
    }
    
    func testNextPoint_scoredTrueUpdateModel() throws {
        XCTAssertEqual(0, pullCoordinator.gameModel.finalScore.team)
        XCTAssertEqual(0, pullCoordinator.gameModel.finalScore.opponent)
        XCTAssertEqual(0, pullCoordinator.gameModel.points.count)
        // Given
        setUpwindOffense()
        pullCoordinator.lineViewModel = Instance.ViewModel.callLineEmpty(delegate: self)
        // When
        pullCoordinator.nextPoint(scored: true)
        // Then
        XCTAssertEqual(1, pullCoordinator.gameModel.finalScore.team)
        XCTAssertEqual(0, pullCoordinator.gameModel.finalScore.opponent)
        XCTAssertEqual(1, pullCoordinator.gameModel.points.count)
    }
    
    func testNextPoint_scoredFalseUpdateModel() throws {
        XCTAssertEqual(0, pullCoordinator.gameModel.finalScore.team)
        XCTAssertEqual(0, pullCoordinator.gameModel.finalScore.opponent)
        XCTAssertEqual(0, pullCoordinator.gameModel.points.count)
        // Given
        setDownwindDefense()
        pullCoordinator.lineViewModel = Instance.ViewModel.callLineEmpty(delegate: self)
        // When
        pullCoordinator.nextPoint(scored: false)
        // Then
        XCTAssertEqual(0, pullCoordinator.gameModel.finalScore.team)
        XCTAssertEqual(1, pullCoordinator.gameModel.finalScore.opponent)
        XCTAssertEqual(1, pullCoordinator.gameModel.points.count)
    }
    
    func testNextPoint_updateWind_upwind() throws {
        // Given
        setUpwindOffense()
        // When
        pullCoordinator.nextPoint(scored: true)
        // Then
        XCTAssertEqual(.downwind, pullCoordinator.currentPointWind)
    }
    
    func testNextPoint_updateWind_downwind() throws {
        // Given
        setDownwindDefense()
        // When
        pullCoordinator.nextPoint(scored: true)
        // Then
        XCTAssertEqual(.upwind, pullCoordinator.currentPointWind)
    }
    
    func testNextPoint_updateWind_crosswind() throws {
        // Given
        pullCoordinator.currentPointWind = .crosswind
        pullCoordinator.currentPointType = .offensive
        pullCoordinator.startPointType = .offensive
        // When
        pullCoordinator.nextPoint(scored: true)
        // Then
        XCTAssertEqual(.crosswind, pullCoordinator.currentPointWind)
    }
    
    func testNextPoint_updatePoint_toOffense() throws {
        // Given
        setDownwindDefense()
        // When
        pullCoordinator.nextPoint(scored: false)
        // Then
        XCTAssertEqual(.offensive, pullCoordinator.currentPointType)
        XCTAssertEqual(.offensive, pullCoordinator.startPointType)
    }
    
    func testNextPoint_updatePoint_toDefense() throws {
        // Given
        setDownwindDefense()
        // When
        pullCoordinator.nextPoint(scored: true)
        // Then
        XCTAssertEqual(.defensive, pullCoordinator.currentPointType)
        XCTAssertEqual(.defensive, pullCoordinator.startPointType)
    }
    
    func testNextPoint_startPoint() throws {
        XCTAssertEqual(0, lineNavigationController.presentCalledCount)
        // Given
        setDownwindDefense()
        // When
        pullCoordinator.nextPoint(scored: true)
        // Then
        XCTAssertEqual(1, pullNavigationController.presentCalledCount)
        XCTAssertEqual(.fullScreen, pullNavigationController.presentationStyle)
    }
    
    func testFlipPointType_offense() throws {
        // Given
        pullCoordinator.startPointType = .defensive
        pullCoordinator.currentPointType = .offensive
        // When
        pullCoordinator.flipPointType()
        // Then
        XCTAssertEqual(.defensive, pullCoordinator.currentPointType)
        XCTAssertEqual(.defensive, pullCoordinator.startPointType)
        XCTAssertTrue(vc.viewModel is PlayGameDefenseCellViewModel)
    }
    
    func testFlipPointType_defense() throws {
        // Given
        pullCoordinator.startPointType = .defensive
        pullCoordinator.currentPointType = .defensive
        // When
        pullCoordinator.flipPointType()
        // Then
        XCTAssertEqual(.offensive, pullCoordinator.currentPointType)
        XCTAssertEqual(.defensive, pullCoordinator.startPointType)
        XCTAssertTrue(vc.viewModel is PlayGameOffenseCellViewModel)
    }
    
    func testDefensePressed_offense() throws {
        // Given
        pullCoordinator.startPointType = .defensive
        pullCoordinator.currentPointType = .offensive
        // When
        pullCoordinator.defensePressed()
        // Then
        XCTAssertEqual(.defensive, pullCoordinator.currentPointType)
        XCTAssertEqual(.defensive, pullCoordinator.startPointType)
        XCTAssertTrue(vc.viewModel is PlayGameDefenseCellViewModel)
    }
    
    func testDefensePressed_defense() throws {
        // Given
        pullCoordinator.startPointType = .defensive
        pullCoordinator.currentPointType = .defensive
        // When
        pullCoordinator.defensePressed()
        // Then
        XCTAssertEqual(.defensive, pullCoordinator.currentPointType)
        XCTAssertEqual(.defensive, pullCoordinator.startPointType)
    }
    
    func testOpponentScorePressed_offense() throws {
        XCTAssertEqual(0, pullCoordinator.gameModel.finalScore.team)
        XCTAssertEqual(0, pullCoordinator.gameModel.finalScore.opponent)
        XCTAssertEqual(0, pullCoordinator.gameModel.points.count)
        // Given
        pullCoordinator.currentPointWind = .upwind
        pullCoordinator.currentPointType = .offensive
        pullCoordinator.startPointType = .defensive
        pullCoordinator.lineViewModel = Instance.ViewModel.callLineEmpty(delegate: self)
        // When
        pullCoordinator.opponentScorePressed()
        // Then
        XCTAssertEqual(0, pullCoordinator.gameModel.finalScore.team)
        XCTAssertEqual(0, pullCoordinator.gameModel.finalScore.opponent)
        XCTAssertEqual(0, pullCoordinator.gameModel.points.count)
    }
    
    func testOpponentScorePressed_defense() throws {
        XCTAssertEqual(0, pullCoordinator.gameModel.finalScore.team)
        XCTAssertEqual(0, pullCoordinator.gameModel.finalScore.opponent)
        XCTAssertEqual(0, pullCoordinator.gameModel.points.count)
        // Given
        pullCoordinator.currentPointWind = .downwind
        pullCoordinator.currentPointType = .defensive
        pullCoordinator.startPointType = .defensive
        pullCoordinator.lineViewModel = Instance.ViewModel.callLineEmpty(delegate: self)
        // When
        pullCoordinator.opponentScorePressed()
        // Then
        XCTAssertEqual(0, pullCoordinator.gameModel.finalScore.team)
        XCTAssertEqual(1, pullCoordinator.gameModel.finalScore.opponent)
        XCTAssertEqual(1, pullCoordinator.gameModel.points.count)
    }
    
    //MARK: Private methods
    private func setUpwindOffense() {
        pullCoordinator.currentPointWind = .upwind
        pullCoordinator.startPointType = .offensive
        pullCoordinator.currentPointType = .offensive
    }
    
    private func setDownwindDefense() {
        pullCoordinator.currentPointWind = .downwind
        pullCoordinator.startPointType = .defensive
        pullCoordinator.currentPointType = .defensive
    }
}

//MARK: CallLineCellViewModelDelegate
extension PullCoordinatorTests: CallLineCellViewModelDelegate {
    func endGame(items: [[PlayerViewModel]]) {
        endGameCalled += 1
    }
}

//MARK: PullCoordinatorDelegate
extension PullCoordinatorTests: PullCoordinatorDelegate {
    func reloadGames() {
        reloadGamesCalled += 1
    }
}
