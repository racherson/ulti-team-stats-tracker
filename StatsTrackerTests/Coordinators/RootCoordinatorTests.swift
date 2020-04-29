//
//  RootCoordinatorTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 4/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class RootCoordinatorTests: XCTestCase {
    
    var rootCoordinator: RootCoordinator!
    var navigationController: MockNavigationController!
    
    override func setUp() {
        navigationController = MockNavigationController()
        rootCoordinator = RootCoordinator(navigationController: navigationController, window: UIWindow())
        super.setUp()
    }
    
    override func tearDown() {
        rootCoordinator = nil
        navigationController = nil
        super.tearDown()
    }

    func testStartAuthCoordinator() throws {
        XCTAssertEqual(0, navigationController.presentCalledCount)
        rootCoordinator.authManager = MockSignedOutAuthManager()
        rootCoordinator.start()
        XCTAssertTrue(rootCoordinator.childCoordinators[0] is AuthCoordinator)
        XCTAssertEqual(1, navigationController.presentCalledCount)
        XCTAssertEqual(.fullScreen, navigationController.presentationStyle)
    }
    
    func testStartMainTabBarCoordinator() throws {
        XCTAssertEqual(0, navigationController.presentCalledCount)
        rootCoordinator.authManager = MockSignedInAuthManager()
        rootCoordinator.start()
        XCTAssertTrue(rootCoordinator.childCoordinators[0] is MainTabBarCoordinator)
        XCTAssertEqual(1, navigationController.presentCalledCount)
    }
    
    func testTransitionToTabs() throws {
        XCTAssertEqual(0, navigationController.dismissCallCount)
        XCTAssertEqual(0, navigationController.presentCalledCount)
        rootCoordinator.transitionToTabs()
        XCTAssertEqual(1, navigationController.dismissCallCount)
        XCTAssertEqual(1, navigationController.presentCalledCount)
    }
    
    func testTransitionToHome() throws {
        XCTAssertEqual(0, navigationController.dismissCallCount)
        XCTAssertEqual(0, navigationController.presentCalledCount)
        rootCoordinator.transitionToHome()
        XCTAssertEqual(1, navigationController.dismissCallCount)
        XCTAssertEqual(1, navigationController.presentCalledCount)
    }
    
}
