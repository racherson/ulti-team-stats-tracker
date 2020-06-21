//
//  RosterViewControllerTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 5/13/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class RosterViewControllerTests: XCTestCase {
    
    var sut: RosterViewController!
    var presenter: RosterPresenterSpy!
    
    var goToPlayerPageCalled: Int = 0
    
    override func setUp() {
        sut = RosterViewController.instantiate(.roster)
        let _ = sut.view
        presenter = RosterPresenterSpy()
        sut.presenter = presenter
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        presenter = nil
        super.tearDown()
    }
    
    func testViewWillAppear() throws {
        XCTAssertEqual(0, presenter.viewWillAppearCalled)
        // When
        sut.viewWillAppear(false)
        // Then
        XCTAssertEqual(1, presenter.viewWillAppearCalled)
    }
    
    func testUpdateWithViewModel() throws {
        XCTAssertNil(sut.viewModel)
        // Given
        let vm = RosterCellViewModel(playerArray: [[], []], delegate: self)
        // When
        sut.updateWithViewModel(vm: vm)
        // Then
        XCTAssertNotNil(sut.viewModel)
    }
    
    func testUpdateView() throws {
        // Given
        let tableView = TableViewSpy()
        sut.tableView = tableView
        // When
        sut.updateView()
        // Then
        XCTAssertTrue(tableView.reloadDataCalled)
    }
    
    func testAddPressed() throws {
        XCTAssertEqual(0, presenter.addPressedCount)
        // When
        sut.addPressed()
        // Then
        XCTAssertEqual(1, presenter.addPressedCount)
    }
    
    func testDidSelectRow() throws {
        XCTAssertEqual(0, goToPlayerPageCalled)
        // Given
        let indexPath = IndexPath(row: 0, section: 0)
        sut.viewModel = RosterCellViewModel(playerArray: [[PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])], []], delegate: self)
        // When
        sut.tableView(sut.tableView, didSelectRowAt: indexPath)
        // Then
        XCTAssertEqual(1, goToPlayerPageCalled)
    }
}

//MARK: RosterPresenterSpy
class RosterPresenterSpy: Presenter, RosterPresenterProtocol {
    
    var viewWillAppearCalled: Int = 0
    var addPressedCount: Int = 0
    
    func onViewWillAppear() {
        viewWillAppearCalled += 1
    }
    
    func addPressed() {
        addPressedCount += 1
    }
    
    func setViewModel() { }
}

//MARK: RosterCellViewModelDelegate
extension RosterViewControllerTests: RosterCellViewModelDelegate {
    func goToPlayerPage(viewModel: PlayerViewModel) {
        goToPlayerPageCalled += 1
    }
    func deletePlayer(_ player: PlayerModel) { }
    func updateView() { }
    func displayError(with: Error) { }
}
