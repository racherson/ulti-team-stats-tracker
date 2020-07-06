//
//  TeamProfileCoordinatorTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 4/28/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class TeamProfileCoordinatorTests: XCTestCase {

    var teamProfileCoordinator: TeamProfileCoordinator!
    var navigationController: MockNavigationController!
    
    private var transitionCalledCount: Int = 0
    
    override func setUp() {
        navigationController = MockNavigationController()
        teamProfileCoordinator = TeamProfileCoordinator(navigationController: navigationController)
        teamProfileCoordinator.delegate = self
        super.setUp()
    }
    
    override func tearDown() {
        teamProfileCoordinator = nil
        navigationController = nil
        super.tearDown()
    }
    
    func testStart() throws {
        XCTAssertEqual(0, navigationController.pushCallCount)
        XCTAssertNil(navigationController.pushedController)
        // When
        teamProfileCoordinator.start()
        // Then
        XCTAssertEqual(1, navigationController.pushCallCount)
        XCTAssertTrue(navigationController.pushedController is TeamProfileViewController)
        XCTAssertTrue(navigationController.navigationBar.prefersLargeTitles)
    }
    
    func testSettingsPressed() throws {
        XCTAssertEqual(0, navigationController.pushCallCount)
        // Given
        let vm = TeamProfileViewModel(team: TestConstants.teamName, email: TestConstants.email, image: UIImage())
        // When
        teamProfileCoordinator.settingsPressed(vm: vm)
        // Then
        XCTAssertEqual(1, navigationController.pushCallCount)
    }
    
    func testTransitionToHome() throws {
        XCTAssertEqual(0, transitionCalledCount)
        // When
        teamProfileCoordinator.transitionToHome()
        // Then
        XCTAssertEqual(1, transitionCalledCount)
    }
    
    func testEditPressed() throws {
        XCTAssertEqual(0, navigationController.presentCalledCount)
        // When
        teamProfileCoordinator.editPressed()
        // Then
        XCTAssertEqual(1, navigationController.presentCalledCount)
    }
    
    func testCancelPressed() throws {
        XCTAssertEqual(0, navigationController.dismissCallCount)
        // When
        teamProfileCoordinator.cancelPressed()
        // Then
        XCTAssertEqual(1, navigationController.dismissCallCount)
    }
    
    func testSavePressed() throws {
        XCTAssertEqual(0, navigationController.dismissCallCount)
        XCTAssertEqual(0, navigationController.popCallCount)
        // Given
        let vm = TeamProfileViewModel(team: TestConstants.teamName, email: TestConstants.email, image: UIImage())
        teamProfileCoordinator.start()
        // When
        teamProfileCoordinator.savePressed(vm: vm)
        // Then
        XCTAssertEqual(1, navigationController.dismissCallCount)
        XCTAssertEqual(1, navigationController.popCallCount)
    }
}

//MARK: TeamProfileCoordinatorDelegate
extension TeamProfileCoordinatorTests: TeamProfileCoordinatorDelegate {
    func transitionToHome() {
        transitionCalledCount += 1
    }
}
