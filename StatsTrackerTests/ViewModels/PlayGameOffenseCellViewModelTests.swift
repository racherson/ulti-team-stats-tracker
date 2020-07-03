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
    
    func testConfigureTableViewCell_notPickedUp() {
        // Given
        let tableView = UITableView()
        tableView.register(PickUpDiscTableViewCell.self, forCellReuseIdentifier: "PickUpDiscTableViewCell")
        // When
        sut.hasDiscIndex = nil
        sut.pickedUp = false
        let indexPath = IndexPath(row: 0, section: 1)
        let cell = sut.tableView(tableView, cellForRowAt: indexPath) as? PickUpDiscTableViewCell
        // Then
        XCTAssertNotNil(cell)
    }
    
    func testConfigureTableViewCell_hasDisc() {
        // Given
        let tableView = UITableView()
        tableView.register(HasDiscTableViewCell.self, forCellReuseIdentifier: "HasDiscTableViewCell")
        // When
        let indexPath = IndexPath(row: 0, section: 1)
        sut.hasDiscIndex = indexPath
        sut.pickedUp = true
        let cell = sut.tableView(tableView, cellForRowAt: indexPath) as? HasDiscTableViewCell
        // Then
        XCTAssertNotNil(cell)
    }
    
    func testConfigureTableViewCell_noDisc() {
        // Given
        let tableView = UITableView()
        tableView.register(NoDiscTableViewCell.self, forCellReuseIdentifier: "NoDiscTableViewCell")
        // When
        sut.hasDiscIndex = nil
        sut.pickedUp = true
        let indexPath = IndexPath(row: 0, section: 1)
        let cell = sut.tableView(tableView, cellForRowAt: indexPath) as? NoDiscTableViewCell
        // Then
        XCTAssertNotNil(cell)
    }
    
    func testScorePressed_hasDisc() throws {
        XCTAssertEqual(0, nextPointCalled)
        // Given
        let model = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])
        let item = PlayerViewModelSpy(model: model)
        sut.items[1][0] = item
        // When
        sut.hasDiscIndex = IndexPath(row: 0, section: 1)
        sut.scorePressed()
        // Then
        XCTAssertEqual(1, nextPointCalled)
        XCTAssertNil(sut.hasDiscIndex)
        XCTAssertEqual(1, item.assistCalled)
    }
    
    func testScorePressed_noDisc() throws {
        XCTAssertEqual(0, nextPointCalled)
        // Given
        let model = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])
        let item = PlayerViewModelSpy(model: model)
        sut.items[1][0] = item
        // When
        sut.hasDiscIndex = nil
        sut.scorePressed()
        // Then
        XCTAssertEqual(1, nextPointCalled)
        XCTAssertNil(sut.hasDiscIndex)
        XCTAssertEqual(0, item.assistCalled)
    }
    
    func testCatchDisc_hasDisc() throws {
        XCTAssertEqual(0, reloadVCCalled)
        // Given
        let model1 = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])
        let model2 = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])
        let item1 = PlayerViewModelSpy(model: model1)
        let item2 = PlayerViewModelSpy(model: model2)
        sut.items[1][0] = item1 // throws disc
        sut.items[1].append(item2) // catching disc
        // When
        sut.hasDiscIndex = IndexPath(row: 0, section: 1)
        sut.catchDisc(IndexPath(row: 1, section: 1))
        // Then
        XCTAssertEqual(1, reloadVCCalled)
        XCTAssertTrue(sut.pickedUp)
        XCTAssertEqual(IndexPath(row: 1, section: 1), sut.hasDiscIndex)
        XCTAssertEqual(1, item1.completionCalled)
    }
    
    func testCatchDisc_noDisc() throws {
        XCTAssertEqual(0, reloadVCCalled)
        // Given
        let model1 = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])
        let model2 = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])
        let item1 = PlayerViewModelSpy(model: model1)
        let item2 = PlayerViewModelSpy(model: model2)
        sut.items[1][0] = item1 // throws disc
        sut.items[1].append(item2) // catching disc
        // When
        sut.hasDiscIndex = nil
        sut.catchDisc(IndexPath(row: 1, section: 1))
        // Then
        XCTAssertEqual(1, reloadVCCalled)
        XCTAssertTrue(sut.pickedUp)
        XCTAssertEqual(IndexPath(row: 1, section: 1), sut.hasDiscIndex)
        XCTAssertEqual(0, item1.completionCalled)
    }
    
    func testDropDisc() throws {
        XCTAssertEqual(0, flipPointCalled)
        // When
        sut.hasDiscIndex = IndexPath(row: 0, section: 1)
        sut.dropDisc()
        // Then
        XCTAssertEqual(1, flipPointCalled)
        XCTAssertNil(sut.hasDiscIndex)
    }
    
    func testPickUpDisc() throws {
        XCTAssertEqual(0, reloadVCCalled)
        XCTAssertNil(sut.hasDiscIndex)
        // When
        sut.pickUpPressed(IndexPath(row: 0, section: 1))
        // Then
        XCTAssertEqual(1, reloadVCCalled)
        XCTAssertTrue(sut.pickedUp)
        XCTAssertEqual(IndexPath(row: 0, section: 1), sut.hasDiscIndex)
    }
    
    func testTurnover() throws {
        XCTAssertEqual(0, flipPointCalled)
        // When
        sut.hasDiscIndex = IndexPath(row: 0, section: 1)
        sut.turnover()
        // Then
        XCTAssertEqual(1, flipPointCalled)
        XCTAssertNil(sut.hasDiscIndex)
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

//MARK: PlayerViewModelSpy
class PlayerViewModelSpy: PlayerViewModel {
    
    var assistCalled: Int = 0
    var completionCalled: Int = 0
    var catchCalled: Int = 0
    var dropCalled: Int = 0
    var goalCalled: Int = 0
    var throwawayCalled: Int = 0
    var dCount: Int = 0
    var callahanCount: Int = 0
    var pullCount: Int = 0
    
    override func addAssist() {
        assistCalled += 1
    }
    
    override func addCompletion() {
        completionCalled += 1
    }
    
    override func addCatch() {
        catchCalled += 1
    }
    
    override func addDrop() {
        dropCalled += 1
    }
    
    override func addGoal() {
        goalCalled += 1
    }
    
    override func addThrowaway() {
        throwawayCalled += 1
    }
    
    override func addD() {
        dCount += 1
    }
    
    override func addCallahan() {
        callahanCount += 1
    }
    
    override func addPull() {
        pullCount += 1
    }
}
