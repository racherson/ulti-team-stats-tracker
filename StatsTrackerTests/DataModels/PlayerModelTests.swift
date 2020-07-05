//
//  PlayerModelTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 7/5/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class PlayerModelTests: XCTestCase {

    func testRequiredInit() throws {
        // When
        let sut = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, points: 1, games: 1, completions: 1, throwaways: 1, catches: 1, drops: 1, goals: 1, assists: 1, ds: 1, pulls: 1, callahans: 1, roles: [0, 1])
        // Then
        XCTAssertEqual(TestConstants.playerName, sut.name)
        XCTAssertEqual(0, sut.gender)
        XCTAssertEqual(TestConstants.empty, sut.id)
        XCTAssertEqual(1, sut.points)
        XCTAssertEqual(1, sut.games)
        XCTAssertEqual(1, sut.completions)
        XCTAssertEqual(1, sut.throwaways)
        XCTAssertEqual(1, sut.catches)
        XCTAssertEqual(1, sut.drops)
        XCTAssertEqual(1, sut.goals)
        XCTAssertEqual(1, sut.assists)
        XCTAssertEqual(1, sut.ds)
        XCTAssertEqual(1, sut.pulls)
        XCTAssertEqual(1, sut.callahans)
        XCTAssertEqual(2, sut.roles.count)
    }
    
    func testIntroInit() throws {
        // When
        let sut = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])
        // Then
        XCTAssertEqual(TestConstants.playerName, sut.name)
        XCTAssertEqual(0, sut.gender)
        XCTAssertEqual(TestConstants.empty, sut.id)
        XCTAssertEqual(0, sut.points)
        XCTAssertEqual(0, sut.games)
        XCTAssertEqual(0, sut.completions)
        XCTAssertEqual(0, sut.throwaways)
        XCTAssertEqual(0, sut.catches)
        XCTAssertEqual(0, sut.drops)
        XCTAssertEqual(0, sut.goals)
        XCTAssertEqual(0, sut.assists)
        XCTAssertEqual(0, sut.ds)
        XCTAssertEqual(0, sut.pulls)
        XCTAssertEqual(0, sut.callahans)
        XCTAssertEqual(0, sut.roles.count)
    }
    
    func testConvenienceInit_success() throws {
        // Given
        let data: [String : Any] = [
            Constants.PlayerModel.name: TestConstants.playerName,
            Constants.PlayerModel.gender: Constants.Empty.int,
            Constants.PlayerModel.id: TestConstants.empty,
            Constants.PlayerModel.roles: [Constants.Empty.int]
        ]
        // When
        let sut = PlayerModel(documentData: data)
        // Then
        XCTAssertEqual(TestConstants.playerName, sut!.name)
        XCTAssertEqual(Constants.Empty.int, sut!.gender)
        XCTAssertEqual(TestConstants.empty, sut!.id)
        XCTAssertEqual([Constants.Empty.int], sut!.roles)
        XCTAssertEqual(Constants.Empty.int, sut!.points)
        XCTAssertEqual(Constants.Empty.int, sut!.games)
        XCTAssertEqual(Constants.Empty.int, sut!.completions)
        XCTAssertEqual(Constants.Empty.int, sut!.throwaways)
        XCTAssertEqual(Constants.Empty.int, sut!.catches)
        XCTAssertEqual(Constants.Empty.int, sut!.drops)
        XCTAssertEqual(Constants.Empty.int, sut!.goals)
        XCTAssertEqual(Constants.Empty.int, sut!.assists)
        XCTAssertEqual(Constants.Empty.int, sut!.ds)
        XCTAssertEqual(Constants.Empty.int, sut!.pulls)
        XCTAssertEqual(Constants.Empty.int, sut!.callahans)
    }
    
    func testConvenienceInit_failure() throws {
        // Given
        let data: [String : Any] = [
            Constants.PlayerModel.name: TestConstants.playerName,
            Constants.PlayerModel.gender: Constants.Empty.int
        ]
        // When
        let sut = PlayerModel(documentData: data)
        // Then
        XCTAssertNil(sut)
    }
    
    func testDictionary() throws {
        // When
        let sut = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])
        let name = sut.dictionary[Constants.PlayerModel.name] as? String
        let gender = sut.dictionary[Constants.PlayerModel.gender] as? Int
        let id = sut.dictionary[Constants.PlayerModel.id] as? String
        // Then
        XCTAssertEqual(TestConstants.playerName, name)
        XCTAssertEqual(0, gender)
        XCTAssertEqual(TestConstants.empty, id)
    }
    
    func testAddPoint() throws {
        // Given
        let sut = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])
        XCTAssertEqual(0, sut.points)
        // When
        sut.addPoint()
        // Then
        XCTAssertEqual(1, sut.points)
    }
    
    func testAddGame() throws {
        // Given
        let sut = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])
        XCTAssertEqual(0, sut.games)
        // When
        sut.addGame()
        // Then
        XCTAssertEqual(1, sut.games)
    }
    
    func testAddCompletion() throws {
        // Given
        let sut = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])
        XCTAssertEqual(0, sut.completions)
        // When
        sut.addCompletion()
        // Then
        XCTAssertEqual(1, sut.completions)
    }
    
    func testAddThrowaway() throws {
        // Given
        let sut = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])
        XCTAssertEqual(0, sut.throwaways)
        // When
        sut.addThrowaway()
        // Then
        XCTAssertEqual(1, sut.throwaways)
    }
    
    func testAddCatch() throws {
        // Given
        let sut = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])
        XCTAssertEqual(0, sut.catches)
        // When
        sut.addCatch()
        // Then
        XCTAssertEqual(1, sut.catches)
    }
    
    func testAddDrop() throws {
        // Given
        let sut = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])
        XCTAssertEqual(0, sut.drops)
        // When
        sut.addDrop()
        // Then
        XCTAssertEqual(1, sut.drops)
    }
    
    func testAddGoal() throws {
        // Given
        let sut = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])
        XCTAssertEqual(0, sut.goals)
        // When
        sut.addGoal()
        // Then
        XCTAssertEqual(1, sut.goals)
    }
    
    func testAddAssist() throws {
        // Given
        let sut = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])
        XCTAssertEqual(0, sut.assists)
        // When
        sut.addAssist()
        // Then
        XCTAssertEqual(1, sut.assists)
    }
    
    func testAddD() throws {
        // Given
        let sut = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])
        XCTAssertEqual(0, sut.ds)
        // When
        sut.addD()
        // Then
        XCTAssertEqual(1, sut.ds)
    }
    
    func testAddPull() throws {
        // Given
        let sut = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])
        XCTAssertEqual(0, sut.pulls)
        // When
        sut.addPull()
        // Then
        XCTAssertEqual(1, sut.pulls)
    }
    
    func testAddCallahan() throws {
        // Given
        let sut = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])
        XCTAssertEqual(0, sut.callahans)
        // When
        sut.addCallahan()
        // Then
        XCTAssertEqual(1, sut.callahans)
    }
}
