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
        navigationController = nil
        super.tearDown()
    }
    
    func testStart() throws {
        XCTAssertEqual(0, navigationController.pushCallCount)
        XCTAssertNil(navigationController.pushedController)
        // When
        authCoordinator.start()
        // Then
        XCTAssertEqual(1, navigationController.pushCallCount)
        XCTAssertTrue(navigationController.pushedController is HomeViewController)
    }

    func testLoginPressed() throws {
        XCTAssertEqual(0, navigationController.pushCallCount)
        XCTAssertNil(navigationController.pushedController)
        // When
        authCoordinator.loginPressed()
        // Then
        XCTAssertEqual(1, navigationController.pushCallCount)
        XCTAssertTrue(navigationController.pushedController is LoginViewController)
    }
    
    func testSignUpPressed() throws {
        XCTAssertEqual(0, navigationController.pushCallCount)
        XCTAssertNil(navigationController.pushedController)
        // When
        authCoordinator.signUpPressed()
        // Then
        XCTAssertEqual(1, navigationController.pushCallCount)
        XCTAssertTrue(navigationController.pushedController is SignUpViewController)
    }

    func testCancelPressed() throws {
        XCTAssertEqual(0, navigationController.popCallCount)
        // When
        authCoordinator.cancelPressed()
        // Then
        XCTAssertEqual(1, navigationController.popCallCount)
    }
    
    func testTransitionToTabs() throws {
        // Given
        let parentCoordinator = RootCoordinator(navigationController: navigationController, window: UIWindow())
        parentCoordinator.childCoordinators.append(authCoordinator)
        authCoordinator.parentCoordinator = parentCoordinator
        XCTAssertEqual(1, authCoordinator.parentCoordinator?.childCoordinators.count)
        // When
        authCoordinator.transitionToTabs()
        // Then
        XCTAssertEqual(0, authCoordinator.parentCoordinator?.childCoordinators.count)
    }
}
