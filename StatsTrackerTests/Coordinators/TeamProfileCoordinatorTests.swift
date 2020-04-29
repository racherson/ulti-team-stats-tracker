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
    
    override func setUp() {
        navigationController = MockNavigationController()
        teamProfileCoordinator = TeamProfileCoordinator(navigationController: navigationController)
        super.setUp()
    }
    
    override func tearDown() {
        teamProfileCoordinator = nil
        navigationController = nil
        super.tearDown()
    }
    
    func testStart() throws {
        XCTAssertEqual(0, navigationController.pushCallCount)
        teamProfileCoordinator.start()
        XCTAssertEqual(1, navigationController.pushCallCount)
    }
    
    func testSettingsPressed() throws {
        XCTAssertEqual(0, navigationController.pushCallCount)
        teamProfileCoordinator.settingsPressed(vm: TeamProfileViewModel(team: "", image: UIImage()))
        XCTAssertEqual(1, navigationController.pushCallCount)
    }
    
    func testEditPressed() throws {
        XCTAssertEqual(0, navigationController.presentCalledCount)
        teamProfileCoordinator.editPressed()
        XCTAssertEqual(1, navigationController.presentCalledCount)
    }
    
    func testCancelPressed() throws {
        XCTAssertEqual(0, navigationController.dismissCallCount)
        teamProfileCoordinator.cancelPressed()
        XCTAssertEqual(1, navigationController.dismissCallCount)
    }
    
    func testSavePressed() throws {
        XCTAssertEqual(0, navigationController.dismissCallCount)
        XCTAssertEqual(0, navigationController.popCallCount)
        teamProfileCoordinator.start()
        teamProfileCoordinator.savePressed(newName: "", newImage: UIImage())
        XCTAssertEqual(1, navigationController.dismissCallCount)
        XCTAssertEqual(1, navigationController.popCallCount)
    }
}
