//
//  RosterCoordinatorTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 4/28/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class RosterCoordinatorTests: XCTestCase {

    var rosterCoordinator: RosterCoordinator!
    var navigationController: MockNavigationController!
    
    override func setUp() {
        navigationController = MockNavigationController()
        rosterCoordinator = RosterCoordinator(navigationController: navigationController)
        super.setUp()
    }
    
    override func tearDown() {
        rosterCoordinator = nil
        navigationController = nil
        super.tearDown()
    }
    
    func testStart() throws {
        XCTAssertEqual(0, navigationController.pushCallCount)
        rosterCoordinator.start()
        XCTAssertEqual(1, navigationController.pushCallCount)
    }
}
