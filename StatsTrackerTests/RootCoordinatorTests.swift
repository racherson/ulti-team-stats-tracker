//
//  RootCoordinatorTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class TeamProfileViewControllerTests: XCTestCase {
    
    var coordinator: RootCoordinator!
    
    override func setUp() {
        let navController = UINavigationController()
        coordinator = RootCoordinator(navigationController: navController)
        coordinator.start()
    }
    
    override func tearDown() {
        coordinator = nil
    }

    func testStart() throws {
        XCTAssertTrue(coordinator.navigationController.topViewController is RootViewController)
    }
    
}
