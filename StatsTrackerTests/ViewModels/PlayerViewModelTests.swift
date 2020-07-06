//
//  PlayerViewModelTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 7/6/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class PlayerViewModelTests: XCTestCase {
    
    var sut: PlayerViewModel!
    
    override func setUp() {
        let model = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, points: 209, games: 33, completions: 132, throwaways: 13, catches: 128, drops: 2, goals: 8, assists: 3, ds: 14, pulls: 0, callahans: 0, roles: [0])
        sut = PlayerViewModel(model: model)
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testModelProperties() throws {
        XCTAssertEqual(TestConstants.playerName, sut.name)
        XCTAssertEqual(.women, sut.gender)
        XCTAssertEqual("209", sut.points)
        XCTAssertEqual("33", sut.games)
        XCTAssertEqual("132", sut.completions)
        XCTAssertEqual("13", sut.throwaways)
        XCTAssertEqual("128", sut.catches)
        XCTAssertEqual("2", sut.drops)
        XCTAssertEqual("8", sut.goals)
        XCTAssertEqual("3", sut.assists)
        XCTAssertEqual("14", sut.ds)
        XCTAssertEqual("0", sut.pulls)
        XCTAssertEqual("0", sut.callahans)
        XCTAssertEqual("Handler", sut.roles)
    }
    
    func testCalculatedStats_nonzero() throws {
        XCTAssertEqual("98.0", sut.catchingPercentage)
        XCTAssertEqual("91.0", sut.completionPercentage)
    }
    
    func testCalculatedStats_zero() throws {
        let sut = Instance.ViewModel.player()
        XCTAssertEqual("0", sut.catchingPercentage)
        XCTAssertEqual("0", sut.completionPercentage)
    }
    
    func testAddGame() throws {
        XCTAssertEqual(33, sut.model.games)
        // When
        sut.addGame()
        // Then
        XCTAssertEqual(34, sut.model.games)
    }
    
    func testAddPoint() throws {
        XCTAssertEqual(209, sut.model.points)
        // When
        sut.addPoint()
        // Then
        XCTAssertEqual(210, sut.model.points)
    }
    
    func testAddGoal() throws {
        XCTAssertEqual(8, sut.model.goals)
        XCTAssertEqual(128, sut.model.catches)
        // When
        sut.addGoal()
        // Then
        XCTAssertEqual(9, sut.model.goals)
        XCTAssertEqual(129, sut.model.catches)
    }
    
    func testAddAssist() throws {
        XCTAssertEqual(3, sut.model.assists)
        // When
        sut.addAssist()
        // Then
        XCTAssertEqual(4, sut.model.assists)
    }
    
    func testAddCatch() throws {
        XCTAssertEqual(128, sut.model.catches)
        // When
        sut.addCatch()
        // Then
        XCTAssertEqual(129, sut.model.catches)
    }
    
    func testAddDrop() throws {
        XCTAssertEqual(2, sut.model.drops)
        // When
        sut.addDrop()
        // Then
        XCTAssertEqual(3, sut.model.drops)
    }
    
    func testAddCompletion() throws {
        XCTAssertEqual(132, sut.model.completions)
        // When
        sut.addCompletion()
        // Then
        XCTAssertEqual(133, sut.model.completions)
    }
    
    func testAddThrowaway() throws {
        XCTAssertEqual(13, sut.model.throwaways)
        // When
        sut.addThrowaway()
        // Then
        XCTAssertEqual(14, sut.model.throwaways)
    }
    
    func testAddD() throws {
        XCTAssertEqual(14, sut.model.ds)
        // When
        sut.addD()
        // Then
        XCTAssertEqual(15, sut.model.ds)
    }
    
    func testAddPull() throws {
        XCTAssertEqual(0, sut.model.pulls)
        // When
        sut.addPull()
        // Then
        XCTAssertEqual(1, sut.model.pulls)
    }
    
    func testAddCallahan() throws {
        XCTAssertEqual(0, sut.model.callahans)
        XCTAssertEqual(8, sut.model.goals)
        XCTAssertEqual(128, sut.model.catches)
        // When
        sut.addCallahan()
        // Then
        XCTAssertEqual(1, sut.model.callahans)
        XCTAssertEqual(9, sut.model.goals)
        XCTAssertEqual(129, sut.model.catches)
    }
}
