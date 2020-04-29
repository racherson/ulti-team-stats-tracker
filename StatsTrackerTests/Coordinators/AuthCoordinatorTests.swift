//
//  AuthCoordinatorTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 4/28/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class AuthCoordinatorTests: XCTestCase {

    var authCoordinator: AuthCoordinator!
    var navigationController: MockNavigationController!
    
    override func setUp() {
        navigationController = MockNavigationController()
        authCoordinator = AuthCoordinator(navigationController: navigationController)
        super.setUp()
    }
    
    override func tearDown() {
        authCoordinator = nil
        super.tearDown()
    }
    
    func testStart() throws {
        XCTAssertEqual(0, navigationController.pushCallCount)
        authCoordinator.start()
        XCTAssertEqual(1, navigationController.pushCallCount)
    }

    func testLoginPressed() throws {
        XCTAssertEqual(0, navigationController.pushCallCount)
        authCoordinator.loginPressed()
        XCTAssertEqual(1, navigationController.pushCallCount)
    }
    
    func testSignUpPressed() throws {
        XCTAssertEqual(0, navigationController.pushCallCount)
        authCoordinator.signUpPressed()
        XCTAssertEqual(1, navigationController.pushCallCount)
    }

    func testCancelPressed() throws {
        XCTAssertEqual(0, navigationController.popCallCount)
        authCoordinator.cancelPressed()
        XCTAssertEqual(1, navigationController.popCallCount)
    }
    
    func testTransitionToTabs() throws {
        let parentCoordinator = RootCoordinator(navigationController: navigationController, window: UIWindow())
        parentCoordinator.childCoordinators.append(authCoordinator)
        authCoordinator.parentCoordinator = parentCoordinator
        XCTAssertEqual(1, authCoordinator.parentCoordinator?.childCoordinators.count)
        authCoordinator.transitionToTabs()
        XCTAssertEqual(0, authCoordinator.parentCoordinator?.childCoordinators.count)
    }
}
