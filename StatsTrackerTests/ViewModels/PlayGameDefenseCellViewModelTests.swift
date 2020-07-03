//
//  PlayGameDefenseCellViewModelTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 7/2/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class PlayGameDefenseCellViewModelTests: XCTestCase {
    
    var sut: PlayGameDefenseCellViewModel!
    
    private let selectedSection = 0
    private let womenSection = Gender.women.rawValue + 1
    private let menSection = Gender.men.rawValue + 1
    
    private var nextPointCalled: Int = 0
    private var reloadVCCalled: Int = 0
    private var flipPointCalled: Int = 0
    
    override func setUp() {
        let playerArray = [[], [PlayerViewModel(model: PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: []))], []]
        sut = PlayGameDefenseCellViewModel(playerArray: playerArray, delegate: self, pulled: false)
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testInit() throws {
        XCTAssertEqual(3, sut.items.count)
        XCTAssertEqual(0, sut.items[0].count)
        XCTAssertEqual(1, sut.items[1].count)
        XCTAssertEqual(0, sut.items[2].count)
    }
    
    func testNumberOfPlayersInSection_NonEmptySection() throws {
        XCTAssertEqual(0, sut.tableView(UITableView(), numberOfRowsInSection: selectedSection))
        XCTAssertEqual(1, sut.tableView(UITableView(), numberOfRowsInSection: womenSection))
        XCTAssertEqual(0, sut.tableView(UITableView(), numberOfRowsInSection: menSection))
    }
    
    func testNumberOfPlayersInSection_OutOfBounds() throws {
        // Given
        let sectionGreaterThan = 2
        let sectionLessThan = -1
        // Then
        XCTAssertEqual(Constants.Empty.int, sut.tableView(UITableView(), numberOfRowsInSection: sectionGreaterThan))
        XCTAssertEqual(Constants.Empty.int, sut.tableView(UITableView(), numberOfRowsInSection: sectionLessThan))
    }
    
    func testConfigureTableViewCell_notPulled() {
        // Given
        let tableView = UITableView()
        tableView.register(PullDefenseTableViewCell.self, forCellReuseIdentifier: "PullDefenseTableViewCell")
        // When
        sut.pulled = false
        let indexPath = IndexPath(row: 0, section: 1)
        let cell = sut.tableView(tableView, cellForRowAt: indexPath) as? PullDefenseTableViewCell
        // Then
        XCTAssertNotNil(cell)
    }
    
    func testConfigureTableViewCell_pulled() {
        // Given
        let tableView = UITableView()
        tableView.register(DefenseTableViewCell.self, forCellReuseIdentifier: "DefenseTableViewCell")
        // When
        let indexPath = IndexPath(row: 0, section: 1)
        sut.pulled = true
        let cell = sut.tableView(tableView, cellForRowAt: indexPath) as? DefenseTableViewCell
        // Then
        XCTAssertNotNil(cell)
    }
    
    func testDPressed() throws {
        XCTAssertEqual(0, flipPointCalled)
        // When
        sut.dPressed()
        // Then
        XCTAssertEqual(1, flipPointCalled)
    }
    
    func testCallahanPressed() throws {
        XCTAssertEqual(0, nextPointCalled)
        // When
        sut.callahanPressed()
        // Then
        XCTAssertEqual(1, nextPointCalled)
    }
    
    func testPull() throws {
        XCTAssertEqual(0, reloadVCCalled)
        // When
        sut.pull()
        // Then
        XCTAssertEqual(1, reloadVCCalled)
        XCTAssertTrue(sut.pulled)
    }
}

//MARK: PlayGameDefenseCellViewModelDelegate
extension PlayGameDefenseCellViewModelTests: PlayGameDefenseCellViewModelDelegate {
    func nextPoint(scored: Bool) {
        nextPointCalled += 1
    }
    
    func flipPointType() {
        flipPointCalled += 1
    }
    
    func reloadVC() {
        reloadVCCalled += 1
    }
}
