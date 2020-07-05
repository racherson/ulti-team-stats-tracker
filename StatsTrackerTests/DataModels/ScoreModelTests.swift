//
//  ScoreModelTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 7/5/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class ScoreModelTests: XCTestCase {
    
    func testRequiredInit() throws {
        // When
        let sut = ScoreModel(opponent: 0, team: 0)
        // Then
        XCTAssertEqual(0, sut.opponent)
        XCTAssertEqual(0, sut.team)
    }
    
    func testConvenienceInit_success() throws {
        // Given
        let data: [String: Any] = [
            Constants.ScoreModel.team: 0,
            Constants.ScoreModel.opponent: 0
        ]
        // When
        let sut = ScoreModel(documentData: data)
        // Then
        XCTAssertEqual(0, sut!.opponent)
        XCTAssertEqual(0, sut!.team)
    }
    
    func testConvenienceInit_failure() throws {
        // Given
        let data: [String: Any] = [
            Constants.ScoreModel.team: "",
            Constants.ScoreModel.opponent: 0
        ]
        // When
        let sut = ScoreModel(documentData: data)
        // Then
        XCTAssertNil(sut)
    }
    
    func testDictionary() throws {
        // When
        let sut = ScoreModel(opponent: 0, team: 0)
        let opponent = sut.dictionary[Constants.ScoreModel.opponent] as! Int
        let team = sut.dictionary[Constants.ScoreModel.team] as! Int
        // Then
        XCTAssertEqual(0, opponent)
        XCTAssertEqual(0, team)
    }
    
    func testOpponentScored() throws {
        // Given
        let sut = ScoreModel(opponent: 0, team: 0)
        // When
        sut.opponentScored()
        // Then
        XCTAssertEqual(1, sut.opponent)
        XCTAssertEqual(0, sut.team)
    }
    
    func testTeamScored() throws {
        // Given
        let sut = ScoreModel(opponent: 0, team: 0)
        // When
        sut.teamScored()
        // Then
        XCTAssertEqual(0, sut.opponent)
        XCTAssertEqual(1, sut.team)
    }
}
