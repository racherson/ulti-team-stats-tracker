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
        let presenter = MockRosterPresenter()
        XCTAssertEqual(0, presenter.setArraysCalled)
        vc.presenter = presenter
        rosterCoordinator.rootVC = vc
        // When
        rosterCoordinator.reloadRoster()
        // Then
        XCTAssertEqual(1, presenter.setArraysCalled)
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
        let model = PlayerModel(name: "", gender: 0, id: "", roles: [])
        let viewModel = PlayerViewModel(model: model)
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
        let model = PlayerModel(name: "", gender: 0, id: "", roles: [])
        let vc = RosterViewController()
        let presenter = MockRosterPresenter()
        XCTAssertEqual(0, presenter.addPlayerCalled)
        vc.presenter = presenter
        rosterCoordinator.rootVC = vc
        // When
        rosterCoordinator.savePressed(player: model)
        // Then
        XCTAssertEqual(1, navigationController.dismissCallCount)
        XCTAssertEqual(1, presenter.addPlayerCalled)
    }
}

//MARK: MockRosterPresenter
class MockRosterPresenter: RosterPresenterProtocol {
    var addPlayerCalled: Int = 0
    var setArraysCalled: Int = 0
    
    func setGenderArrays() {
        setArraysCalled += 1
    }
    func onViewWillAppear() {}
    func addPressed() {}
    func addPlayer(_ player: PlayerModel) {
        addPlayerCalled += 1
    }
    func deletePlayer(at indexPath: IndexPath) {}
    func goToPlayerPage(at indexPath: IndexPath) {}
    func numberOfPlayersInSection(_ section: Int) -> Int { return 0 }
    func getPlayerName(at indexPath: IndexPath) -> String { return "" }
}
