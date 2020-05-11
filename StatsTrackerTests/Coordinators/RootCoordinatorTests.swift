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
    
    func testSetupWindow() throws {
        let window = WindowSpy()
        XCTAssertEqual(0, window.rootVCSetCount)
        XCTAssertEqual(0, window.makeKeyAndVisibleSetCount)
        // Given
        _ = RootCoordinator(navigationController: navigationController, window: window)
        // Then
        XCTAssertEqual(1, window.rootVCSetCount)
        XCTAssertEqual(1, window.makeKeyAndVisibleSetCount)
    }

    func testStartAuthCoordinator() throws {
        XCTAssertEqual(0, navigationController.presentCalledCount)
        XCTAssertEqual(0, navigationController.pushCallCount)
        // Given
        rootCoordinator.authManager = MockSignedOutAuthManager()
        // When
        rootCoordinator.start()
        // Then
        XCTAssertEqual(1, navigationController.pushCallCount)
        XCTAssertTrue(rootCoordinator.childCoordinators[0] is AuthCoordinator)
        XCTAssertEqual(1, navigationController.presentCalledCount)
        XCTAssertEqual(.fullScreen, navigationController.presentationStyle)
    }
    
    func testStartMainTabBarCoordinator() throws {
        XCTAssertEqual(0, navigationController.presentCalledCount)
        XCTAssertEqual(0, navigationController.pushCallCount)
        // Given
        rootCoordinator.authManager = MockSignedInAuthManager()
        // When
        rootCoordinator.start()
        // Then
        XCTAssertEqual(1, navigationController.pushCallCount)
        XCTAssertTrue(rootCoordinator.childCoordinators[0] is MainTabBarCoordinator)
        XCTAssertEqual(1, navigationController.presentCalledCount)
    }
    
    func testTransitionToTabs() throws {
        XCTAssertEqual(0, navigationController.dismissCallCount)
        XCTAssertEqual(0, navigationController.presentCalledCount)
        // When
        rootCoordinator.transitionToTabs()
        //Then
        XCTAssertEqual(1, navigationController.dismissCallCount)
        XCTAssertEqual(1, navigationController.presentCalledCount)
    }
    
    func testTransitionToHome() throws {
        XCTAssertEqual(0, navigationController.dismissCallCount)
        XCTAssertEqual(0, navigationController.presentCalledCount)
        // When
        rootCoordinator.transitionToHome()
        // Then
        XCTAssertEqual(1, navigationController.dismissCallCount)
        XCTAssertEqual(1, navigationController.presentCalledCount)
    }
}

//MARK: WindowSpy
class WindowSpy: UIWindow {
    var rootVCSetCount: Int = 0
    var makeKeyAndVisibleSetCount: Int = 0
    
    override var rootViewController: UIViewController? {
        didSet {
            rootVCSetCount += 1
        }
    }
    
    override func makeKeyAndVisible() {
        makeKeyAndVisibleSetCount += 1
    }
}
