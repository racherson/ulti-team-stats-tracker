//
//  GamesCoordinatorTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 4/28/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class GamesCoordinatorTests: XCTestCase {

    var gamesCoordinator: GamesCoordinator!
    var navigationController: MockNavigationController!
    
    override func setUp() {
        navigationController = MockNavigationController()
        gamesCoordinator = GamesCoordinator(navigationController: navigationController)
        super.setUp()
    }
    
    override func tearDown() {
        gamesCoordinator = nil
        navigationController = nil
        super.tearDown()
    }
    
    func testStart() throws {
        XCTAssertEqual(0, navigationController.pushCallCount)
        XCTAssertNil(navigationController.pushedController)
        // When
        gamesCoordinator.start()
        // Then
        XCTAssertEqual(1, navigationController.pushCallCount)
        XCTAssertTrue(navigationController.pushedController is GamesViewController)
        XCTAssertTrue(navigationController.navigationBar.prefersLargeTitles)
    }
    
    func testGoToGamePage() throws {
        XCTAssertEqual(0, navigationController.pushCallCount)
        XCTAssertNil(navigationController.pushedController)
        // Given
        let model = GameDataModel(id: TestConstants.empty, tournament: TestConstants.tournamentName, opponent: TestConstants.teamName)
        let viewModel = GameViewModel(model: model)
        // When
        gamesCoordinator.goToGamePage(viewModel: viewModel)
        // Then
        XCTAssertEqual(1, navigationController.pushCallCount)
        XCTAssertTrue(navigationController.pushedController is GameDetailViewController)
    }
}
