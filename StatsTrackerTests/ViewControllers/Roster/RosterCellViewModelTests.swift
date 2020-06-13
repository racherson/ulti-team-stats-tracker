//
//  RosterCellViewModelTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 6/11/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class RosterCellViewModelTests: XCTestCase {
    
    var sut: RosterCellViewModel!
    var vc: RosterViewControllerSpy!
    
    var goToPlayerPageCalled: Int = 0
    var deletePlayerCalled: Int = 0
    var updateViewCalled: Int = 0
    var displayErrorCalled: Int = 0
    
    override func setUp() {
        let playerArray = [[PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])], []]
        vc = RosterViewControllerSpy()
        sut = RosterCellViewModel(playerArray: playerArray, delegate: self)
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        vc = nil
        super.tearDown()
    }
    
    func testAddPlayerWoman() throws {
        XCTAssertEqual(1, sut.items[Gender.women.rawValue].count)
        XCTAssertEqual(0, updateViewCalled)
        // Given
        let model = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])
        // When
        sut.addPlayer(model)
        // Then
        XCTAssertEqual(2, sut.items[Gender.women.rawValue].count)
        XCTAssertEqual(1, updateViewCalled)
    }
    
    func testAddPlayerMan() throws {
        XCTAssertEqual(0, sut.items[Gender.men.rawValue].count)
        XCTAssertEqual(0, updateViewCalled)
        // Given
        let model = PlayerModel(name: TestConstants.playerName, gender: 1, id: TestConstants.empty, roles: [])
        // When
        sut.addPlayer(model)
        // Then
        XCTAssertEqual(1, sut.items[Gender.men.rawValue].count)
        XCTAssertEqual(1, updateViewCalled)
    }
    
    func testGoToPlayerPage() throws {
        XCTAssertEqual(0, goToPlayerPageCalled)
        // When
        let indexPath = IndexPath(row: 0, section: 0)
        sut.goToPlayerPage(at: indexPath)
        // Then
        XCTAssertEqual(1, goToPlayerPageCalled)
    }
    
    func testGoToPlayerPage_RowOutOfBounds() throws {
        XCTAssertEqual(0, goToPlayerPageCalled)
        XCTAssertEqual(0, displayErrorCalled)
        // When
        let indexPath = IndexPath(row: 2, section: 0)
        sut.goToPlayerPage(at: indexPath)
        // Then
        XCTAssertEqual(0, goToPlayerPageCalled)
        XCTAssertEqual(1, displayErrorCalled)
    }
    
    func testGoToPlayerPage_SectionOutOfBounds() throws {
        XCTAssertEqual(0, goToPlayerPageCalled)
        XCTAssertEqual(0, displayErrorCalled)
        // When
        let indexPath = IndexPath(row: 0, section: -1)
        sut.goToPlayerPage(at: indexPath)
        // Then
        XCTAssertEqual(0, goToPlayerPageCalled)
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
        let array1: [PlayerViewModel] = []
        let array2: [PlayerViewModel] = []
        // When
        sut.items = [array1, array2]
        let womenCount = sut.tableView(UITableView(), numberOfRowsInSection: Gender.women.rawValue)
        let menCount = sut.tableView(UITableView(), numberOfRowsInSection: Gender.men.rawValue)
        // Then
        XCTAssertEqual(0, womenCount)
        XCTAssertEqual(0, menCount)
    }
    
    func testNumberOfPlayersInSection_NonEmptySection() throws {
        // When
        let womenCount = sut.tableView(UITableView(), numberOfRowsInSection: Gender.women.rawValue)
        // Then
        XCTAssertEqual(1, womenCount)
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
        tableView.register(RosterTableViewCell.self, forCellReuseIdentifier: "RosterTableViewCell")
        // When
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView(tableView, cellForRowAt: indexPath)
            as! RosterTableViewCell
        // Then
        XCTAssertEqual(TestConstants.playerName, cell.textLabel?.text)
    }
    
    func testHeaderForSection_Nonempty() throws {
        // Given
        let section = Gender.women.rawValue
        // When
        let result = sut.tableView(UITableView(), titleForHeaderInSection: section)
        // Then
        XCTAssertEqual(result, Gender.women.description)
    }
    
    func testHeaderForSection_Empty() throws {
        // Given
        let section = Gender.men.rawValue
        // When
        let result = sut.tableView(UITableView(), titleForHeaderInSection: section)
        // Then
        XCTAssertNil(result)
    }
    
    func testDeletePlayer() throws {
        XCTAssertEqual(0, vc.updateViewCalled)
        XCTAssertEqual(0, deletePlayerCalled)
        // When
        let section = 0
        let indexPath = IndexPath(row: 0, section: section)
        sut.tableView(UITableView(), commit: .delete, forRowAt: indexPath)
        // Then
        XCTAssertEqual(1, updateViewCalled)
        XCTAssertEqual(1, deletePlayerCalled)
        XCTAssertEqual(0, sut.items[section].count)
    }
    
    func testDeletePlayer_SectionOutOfBounds() throws {
        XCTAssertEqual(0, vc.updateViewCalled)
        XCTAssertEqual(0, deletePlayerCalled)
        // When
        let section = 2
        let indexPath = IndexPath(row: 0, section: section)
        sut.tableView(UITableView(), commit: .delete, forRowAt: indexPath)
        // Then
        XCTAssertEqual(0, vc.updateViewCalled)
        XCTAssertEqual(0, deletePlayerCalled)
    }
    
    func testDeletePlayer_RowOutOfBounds() throws {
        XCTAssertEqual(0, vc.updateViewCalled)
        XCTAssertEqual(0, deletePlayerCalled)
        // When
        let section = 0
        let indexPath = IndexPath(row: -1, section: section)
        sut.tableView(UITableView(), commit: .delete, forRowAt: indexPath)
        // Then
        XCTAssertEqual(0, vc.updateViewCalled)
        XCTAssertEqual(0, deletePlayerCalled)
    }
}

//MARK: RosterCellViewModelDelegate
extension RosterCellViewModelTests: RosterCellViewModelDelegate {
    func deletePlayer(_ player: PlayerModel) {
        deletePlayerCalled += 1
    }
    
    func goToPlayerPage(viewModel: PlayerViewModel) {
        goToPlayerPageCalled += 1
    }
    
    func updateView() {
        updateViewCalled += 1
    }
    
    func displayError(with: Error) {
        displayErrorCalled += 1
    }
}
