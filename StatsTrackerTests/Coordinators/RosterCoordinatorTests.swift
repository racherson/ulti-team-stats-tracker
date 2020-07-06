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
        XCTAssertNil(navigationController.pushedController)
        // When
        rosterCoordinator.start()
        // Then
        XCTAssertEqual(1, navigationController.pushCallCount)
        XCTAssertTrue(navigationController.pushedController is RosterViewController)
        XCTAssertTrue(navigationController.navigationBar.prefersLargeTitles)
    }
    
    func testReloadRoster() throws {
        // Given
        let vc = RosterViewController()
        let presenter = RosterPresenterSpy()
        XCTAssertEqual(0, presenter.setViewModelCalled)
        vc.presenter = presenter
        rosterCoordinator.rootVC = vc
        // When
        rosterCoordinator.reloadRoster()
        // Then
        XCTAssertEqual(1, presenter.setViewModelCalled)
    }
    
    func testAddPressed() throws {
        XCTAssertEqual(0, navigationController.presentCalledCount)
        // When
        rosterCoordinator.addPressed()
        // Then
        XCTAssertEqual(1, navigationController.presentCalledCount)
    }
    
    func testGoToPlayerPage() throws {
        XCTAssertEqual(0, navigationController.pushCallCount)
        XCTAssertNil(navigationController.pushedController)
        // Given
        let viewModel = Instance.ViewModel.player()
        // When
        rosterCoordinator.goToPlayerPage(viewModel: viewModel)
        // Then
        XCTAssertEqual(1, navigationController.pushCallCount)
        XCTAssertTrue(navigationController.pushedController is PlayerDetailViewController)
    }
    
    func testCancelPressed() throws {
        XCTAssertEqual(0, navigationController.dismissCallCount)
        // When
        rosterCoordinator.cancelPressed()
        // Then
        XCTAssertEqual(1, navigationController.dismissCallCount)
    }
    
    func testSavePressed() throws {
        XCTAssertEqual(0, navigationController.dismissCallCount)
        // Given
        let model = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])
        let vc = RosterViewController()
        vc.viewModel = RosterCellViewModel(playerArray: [[], []], delegate: self)
        rosterCoordinator.rootVC = vc
        // When
        rosterCoordinator.savePressed(player: model)
        // Then
        XCTAssertEqual(1, navigationController.dismissCallCount)
    }
}

//MARK: RosterCellViewModelDelegate
extension RosterCoordinatorTests: RosterCellViewModelDelegate {
    func goToPlayerPage(viewModel: PlayerViewModel) { }
    func deletePlayer(_ player: PlayerModel) { }
    func updateView() { }
    func displayError(with: Error) { }
}
