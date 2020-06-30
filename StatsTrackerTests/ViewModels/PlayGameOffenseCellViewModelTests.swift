//
//  PlayGameOffenseCellViewModelTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 6/25/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class PlayGameOffenseCellViewModelTests: XCTestCase {
    
    var sut: PlayGameOffenseCellViewModel!
    
    private let selectedSection = 0
    private let womenSection = Gender.women.rawValue + 1
    private let menSection = Gender.men.rawValue + 1
    
    private var nextPointCalled: Int = 0
    private var reloadVCCalled: Int = 0
    private var flipPointCalled: Int = 0
    
    override func setUp() {
        let playerArray = [[], [PlayerViewModel(model: PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: []))], []]
        sut = PlayGameOffenseCellViewModel(playerArray: playerArray, delegate: self)
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
    
    func testConfigureTableViewCell() {
        // Given
        let tableView = UITableView()
        tableView.register(NoDiscTableViewCell.self, forCellReuseIdentifier: "NoDiscTableViewCell")
        // When
        sut.hasDiscIndex = nil
        let indexPath = IndexPath(row: 0, section: 1)
        let cell = sut.tableView(tableView, cellForRowAt: indexPath) as! NoDiscTableViewCell
        // Then
        XCTAssertEqual(sut, cell.delegate)
    }
    
    func testScorePressed() throws {
        XCTAssertEqual(0, nextPointCalled)
        // When
        sut.scorePressed()
        // Then
        XCTAssertEqual(1, nextPointCalled)
    }
}

//MARK: PlayGameOffenseCellViewModelDelegate
extension PlayGameOffenseCellViewModelTests: PlayGameOffenseCellViewModelDelegate {
    func nextPoint(scored: Bool) {
        nextPointCalled += 1
    }
    
    func reloadVC() {
        reloadVCCalled += 1
    }
    
    func flipPointType() {
        flipPointCalled += 1
    }
}
