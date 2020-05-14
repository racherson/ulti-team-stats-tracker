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
}
