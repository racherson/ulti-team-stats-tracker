//
//  GamesCellViewModelTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 6/13/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class GamesCellViewModelTests: XCTestCase {
    
    var sut: GamesCellViewModel!
    var vc: GamesViewControllerSpy!
    
    var goToGamePageCalled: Int = 0
    var updateViewCalled: Int = 0
    var displayErrorCalled: Int = 0
    
    override func setUp() {
        let gameArray = [[GameDataModel(id: TestConstants.empty, tournament: TestConstants.tournamentName, opponent: TestConstants.teamName)]]
        vc = GamesViewControllerSpy()
        sut = GamesCellViewModel(gameArray: gameArray, delegate: self)
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        vc = nil
        super.tearDown()
    }
    
    func testInit() throws {
        XCTAssertEqual(1, sut.items.count)
        XCTAssertEqual(1, sut.items[0].count)
    }
    
    func testGoToGamePage() throws {
        XCTAssertEqual(0, goToGamePageCalled)
        // When
        let indexPath = IndexPath(row: 0, section: 0)
        sut.goToGamePage(at: indexPath)
        // Then
        XCTAssertEqual(1, goToGamePageCalled)
    }
    
    func testGoToPlayerPage_RowOutOfBounds() throws {
        XCTAssertEqual(0, goToGamePageCalled)
        XCTAssertEqual(0, displayErrorCalled)
        // When
        let indexPath = IndexPath(row: 2, section: 0)
        sut.goToGamePage(at: indexPath)
        // Then
        XCTAssertEqual(0, goToGamePageCalled)
        XCTAssertEqual(1, displayErrorCalled)
    }
    
    func testGoToPlayerPage_SectionOutOfBounds() throws {
        XCTAssertEqual(0, goToGamePageCalled)
        XCTAssertEqual(0, displayErrorCalled)
        // When
        let indexPath = IndexPath(row: 0, section: -1)
        sut.goToGamePage(at: indexPath)
        // Then
        XCTAssertEqual(0, goToGamePageCalled)
        XCTAssertEqual(1, displayErrorCalled)
    }
    
    func testNumberOfRowsInSection() throws {
        // When
        let rows = sut.tableView(UITableView(), numberOfRowsInSection: 0)
        // Then
        XCTAssertEqual(1, rows)
    }
    
    func testNumberOfPlayersInSection_EmptySection() throws {
        // Given
        let array: [GameViewModel] = []
        // When
        sut.items = [array]
        let count = sut.tableView(UITableView(), numberOfRowsInSection: 0)
        // Then
        XCTAssertEqual(0, count)
    }
    
    func testNumberOfPlayersInSection_NonEmptySection() throws {
        // When
        let count = sut.tableView(UITableView(), numberOfRowsInSection: Gender.women.rawValue)
        // Then
        XCTAssertEqual(1, count)
    }
    
    func testNumberOfPlayersInSection_OutOfBounds() throws {
        // Given
        let sectionGreaterThan = 2
        let sectionLessThan = -1
        // When
        let count1 = sut.tableView(UITableView(), numberOfRowsInSection: sectionGreaterThan)
        let count2 = sut.tableView(UITableView(), numberOfRowsInSection: sectionLessThan)
        // Then
        XCTAssertEqual(0, count1)
        XCTAssertEqual(0, count2)
    }
    
    func testConfigureTableViewCell() {
        // Given
        let tableView = UITableView()
        tableView.register(GamesTableViewCell.self, forCellReuseIdentifier: "GamesTableViewCell")
        // When
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView(tableView, cellForRowAt: indexPath)
            as! GamesTableViewCell
        // Then
        XCTAssertEqual(TestConstants.teamName, cell.textLabel?.text)
    }
    
    func testHeaderForSection_Nonempty() throws {
        // When
        let result = sut.tableView(UITableView(), titleForHeaderInSection: 0)
        // Then
        XCTAssertEqual(result, TestConstants.tournamentName)
    }
    
    func testHeaderForSection_Empty() throws {
        // When
        let result = sut.tableView(UITableView(), titleForHeaderInSection: 1)
        // Then
        XCTAssertNil(result)
    }
}

//MARK: GamesCellViewModelDelegate
extension GamesCellViewModelTests: GamesCellViewModelDelegate {
    func goToGamePage(viewModel: GameViewModel) {
        goToGamePageCalled += 1
    }
    
    func updateView() {
        updateViewCalled += 1
    }
    
    func displayError(with: Error) {
        displayErrorCalled += 1
    }
}
