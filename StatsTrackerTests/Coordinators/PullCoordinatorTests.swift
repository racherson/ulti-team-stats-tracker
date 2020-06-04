//
//  PullCoordinatorTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 4/28/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class PullCoordinatorTests: XCTestCase {

    var pullCoordinator: PullCoordinator!
    var navigationController: MockNavigationController!
    
    override func setUp() {
        navigationController = MockNavigationController()
        pullCoordinator = PullCoordinator(navigationController: navigationController)
        super.setUp()
    }
    
    override func tearDown() {
        pullCoordinator = nil
        navigationController = nil
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
        let game = GameDataModel(tournament: TestConstants.empty, opponent: TestConstants.empty)
        let wind = WindDirection(rawValue: 0)!
        let point = PointType(rawValue: 0)!
        // When
        pullCoordinator.startGamePressed(gameModel: game, wind: wind, point: point)
        // Then
        XCTAssertEqual(1, navigationController.presentCalledCount)
        XCTAssertEqual(.fullScreen, navigationController.presentationStyle)
    }
}
