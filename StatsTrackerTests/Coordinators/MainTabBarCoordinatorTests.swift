//
//  MainTabBarCoordinatorTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 4/28/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class MainTabBarCoordinatorTests: XCTestCase {
    
    var tabBarCoordinator: MainTabBarCoordinator!
    var navigationController: MockNavigationController!
    
    override func setUp() {
        navigationController = MockNavigationController()
        tabBarCoordinator = MainTabBarCoordinator(navigationController: navigationController)
        super.setUp()
    }
    
    override func tearDown() {
        tabBarCoordinator = nil
        navigationController = nil
        super.tearDown()
    }
    
    func testStart() throws {
        XCTAssertEqual(0, navigationController.presentCalledCount)
        tabBarCoordinator.start()
        XCTAssertEqual(1, navigationController.presentCalledCount)
        XCTAssertEqual(.fullScreen, navigationController.presentationStyle)
    }
    
    func testTransitionToHome() throws {
        let parentCoordinator = RootCoordinator(navigationController: navigationController, window: UIWindow())
        parentCoordinator.childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.parentCoordinator = parentCoordinator
        XCTAssertEqual(1, tabBarCoordinator.parentCoordinator?.childCoordinators.count)
        tabBarCoordinator.transitionToHome()
        XCTAssertEqual(0, tabBarCoordinator.parentCoordinator?.childCoordinators.count)
    }
}
