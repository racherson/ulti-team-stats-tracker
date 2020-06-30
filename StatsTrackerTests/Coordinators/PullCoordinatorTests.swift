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
    var gameModel: GameDataModel!
    var viewModel: CallLineCellViewModel!
    
    private var endGameCalled: Int = 0
    private var reloadGamesCalled: Int = 0
    
    override func setUp() {
        navigationController = MockNavigationController()
        pullCoordinator = PullCoordinator(navigationController: navigationController)
        let vc = PlayGameViewController.instantiate(.pull)
        vc.loadViewIfNeeded()
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
    }
    
    func testStartPoint() throws {
        pullCoordinator.lineViewModel = nil
        XCTAssertNil(pullCoordinator.lineViewModel)
        XCTAssertEqual(0, lineNavigationController.presentCalledCount)
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
    
    func testNextPoint_scoredTrueUpdateModel() throws {
        XCTAssertEqual(0, pullCoordinator.gameModel.finalScore.team)
        XCTAssertEqual(0, pullCoordinator.gameModel.finalScore.opponent)
        XCTAssertEqual(0, pullCoordinator.gameModel.points.count)
        // Given
        pullCoordinator.currentPointWind = .upwind
        pullCoordinator.currentPointType = .offensive
        pullCoordinator.lineViewModel = CallLineCellViewModel(playerArray: [[], [], []], delegate: self)
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
        pullCoordinator.currentPointWind = .downwind
        pullCoordinator.currentPointType = .defensive
        pullCoordinator.lineViewModel = CallLineCellViewModel(playerArray: [[], [], []], delegate: self)
        // When
        pullCoordinator.nextPoint(scored: false)
        // Then
        XCTAssertEqual(0, pullCoordinator.gameModel.finalScore.team)
        XCTAssertEqual(1, pullCoordinator.gameModel.finalScore.opponent)
        XCTAssertEqual(1, pullCoordinator.gameModel.points.count)
    }
    
    func testNextPoint_updateWind_upwind() throws {
        // Given
        pullCoordinator.currentPointWind = .upwind
        pullCoordinator.currentPointType = .offensive
        // When
        pullCoordinator.nextPoint(scored: true)
        // Then
        XCTAssertEqual(.downwind, pullCoordinator.currentPointWind)
    }
    
    func testNextPoint_updateWind_downwind() throws {
        // Given
        pullCoordinator.currentPointWind = .downwind
        pullCoordinator.currentPointType = .defensive
        // When
        pullCoordinator.nextPoint(scored: true)
        // Then
        XCTAssertEqual(.upwind, pullCoordinator.currentPointWind)
    }
    
    func testNextPoint_updateWind_crosswind() throws {
        // Given
        pullCoordinator.currentPointWind = .crosswind
        pullCoordinator.currentPointType = .offensive
        // When
        pullCoordinator.nextPoint(scored: true)
        // Then
        XCTAssertEqual(.crosswind, pullCoordinator.currentPointWind)
    }
    
    func testNextPoint_updatePoint_offense() throws {
        // Given
        pullCoordinator.currentPointType = .defensive
        pullCoordinator.currentPointWind = .downwind
        // When
        pullCoordinator.nextPoint(scored: false)
        // Then
        XCTAssertEqual(.offensive, pullCoordinator.currentPointType)
    }
    
    func testNextPoint_updatePoint_defense() throws {
        // Given
        pullCoordinator.currentPointType = .defensive
        pullCoordinator.currentPointWind = .downwind
        // When
        pullCoordinator.nextPoint(scored: true)
        // Then
        XCTAssertEqual(.defensive, pullCoordinator.currentPointType)
    }
    
    func testNextPoint_startPoint() throws {
        XCTAssertEqual(0, lineNavigationController.presentCalledCount)
        // Given
        pullCoordinator.currentPointType = .defensive
        pullCoordinator.currentPointWind = .downwind
        // When
        pullCoordinator.nextPoint(scored: true)
        // Then
        XCTAssertEqual(1, pullNavigationController.presentCalledCount)
        XCTAssertEqual(.fullScreen, pullNavigationController.presentationStyle)
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
