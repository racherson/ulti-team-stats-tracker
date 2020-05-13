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
    
    func testNumberOfRowsInSection() throws {
        XCTAssertEqual(0, presenter.numberOfPlayersInSectionCalled)
        // When
        let _ = sut.tableView(UITableView(), numberOfRowsInSection: 0)
        // Then
        XCTAssertEqual(1, presenter.numberOfPlayersInSectionCalled)
    }
    
    func testTitleForHeaderInSection() throws {
        // Given
        let tableView = TableViewSpy()
        sut.tableView = tableView
        // When
        let womenTitle = sut.tableView(sut.tableView, titleForHeaderInSection: Gender.women.rawValue)
        let menTitle = sut.tableView(sut.tableView, titleForHeaderInSection: Gender.men.rawValue)
        let emptyTitle = sut.tableView(sut.tableView, titleForHeaderInSection: 2)
        // Then
        XCTAssertEqual(Constants.Titles.women, womenTitle)
        XCTAssertEqual(Constants.Titles.men, menTitle)
        XCTAssertNil(emptyTitle)
    }
    
    func testConfigureTableViewCell() {
        XCTAssertEqual(0, presenter.getPlayerNameCalled)
        // Given
        let tableView = sut.tableView
        // When
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView(tableView!, cellForRowAt: indexPath)
            as! RosterTableViewCell
        // Then
        XCTAssertEqual(TestConstants.playerName, cell.textLabel?.text)
        XCTAssertEqual(1, presenter.getPlayerNameCalled)
    }
    
    func testDidSelectRow() throws {
        XCTAssertEqual(0, presenter.goToPlayerPageCount)
        // Given
        let indexPath = IndexPath(row: 0, section: 0)
        // When
        sut.tableView(sut.tableView, didSelectRowAt: indexPath)
        // Then
        XCTAssertEqual(1, presenter.goToPlayerPageCount)
    }
    
    func testEditCell_Delete() throws {
        XCTAssertEqual(0, presenter.deletePlayerCount)
        // Given
        let indexPath = IndexPath(row: 0, section: 0)
        // When
        sut.tableView(sut.tableView, commit: .delete, forRowAt: indexPath)
        // Then
        XCTAssertEqual(1, presenter.deletePlayerCount)
    }
}

//MARK: TableViewSpy
class TableViewSpy: UITableView {
    
    var reloadDataCalled = false
    
    override func reloadData() {
         reloadDataCalled = true
    }
    
    override func numberOfRows(inSection section: Int) -> Int {
        return 1
    }
}

//MARK: RosterPresenterSpy
class RosterPresenterSpy: Presenter, RosterPresenterProtocol {
    
    var viewWillAppearCalled: Int = 0
    var addPressedCount: Int = 0
    var addPlayerCount: Int = 0
    var deletePlayerCount: Int = 0
    var goToPlayerPageCount: Int = 0
    var numberOfPlayersInSectionCalled: Int = 0
    var getPlayerNameCalled: Int = 0
    
    func onViewWillAppear() {
        viewWillAppearCalled += 1
    }
    
    func addPressed() {
        addPressedCount += 1
    }
    
    func addPlayer(_ player: PlayerModel) {
        addPlayerCount += 1
    }
    
    func deletePlayer(at indexPath: IndexPath) {
        deletePlayerCount += 1
    }
    
    func goToPlayerPage(at indexPath: IndexPath) {
        goToPlayerPageCount += 1
    }
    
    func numberOfPlayersInSection(_ section: Int) -> Int {
        numberOfPlayersInSectionCalled += 1
        return 1
    }
    
    func getPlayerName(at indexPath: IndexPath) -> String {
        getPlayerNameCalled += 1
        return TestConstants.playerName
    }
}
