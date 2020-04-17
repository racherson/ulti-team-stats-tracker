//
//  RootCoordinatorTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

// TESTING PATTERN
// GIVEN...WHEN...THEN

class TeamProfileViewControllerTests: XCTestCase {
    
    var coordinator: RootCoordinator!

    func testStart() throws {
        let navController = UINavigationController()
        coordinator = RootCoordinator(navigationController: navController)
        coordinator.start()
        XCTAssertTrue(navController.topViewController is RootViewController)
    }

}
