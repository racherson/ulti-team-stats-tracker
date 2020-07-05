//
//  GameDataModelTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 7/5/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class GameDataModelTests: XCTestCase {
    
    func testRequiredInit() throws {
        // When
        let sut = GameDataModel(id: TestConstants.empty, tournament: TestConstants.tournamentName, opponent: TestConstants.teamName, finalScore: [Constants.ScoreModel.team: 15, Constants.ScoreModel.opponent: 10], points: [])
        // Then
        XCTAssertEqual(TestConstants.empty, sut.id)
        XCTAssertEqual(TestConstants.tournamentName, sut.tournament)
        XCTAssertEqual(TestConstants.teamName, sut.opponent)
        let score = ScoreModel(opponent: 10, team: 15)
        XCTAssertEqual(score.team, sut.finalScore.team)
        XCTAssertEqual(score.opponent, sut.finalScore.opponent)
        XCTAssertEqual(0, sut.points.count)
    }
    
    func testIntroInit() throws {
        // When
        let sut = GameDataModel(id: TestConstants.empty, tournament: TestConstants.tournamentName, opponent: TestConstants.teamName)
        // Then
        XCTAssertEqual(TestConstants.empty, sut.id)
        XCTAssertEqual(TestConstants.tournamentName, sut.tournament)
        XCTAssertEqual(TestConstants.teamName, sut.opponent)
        let score = ScoreModel(opponent: 0, team: 0)
        XCTAssertEqual(score.team, sut.finalScore.team)
        XCTAssertEqual(score.opponent, sut.finalScore.opponent)
        XCTAssertEqual(0, sut.points.count)
    }
    
    func testConvenienceInit_success() throws {
        // Given
        let data: [String : Any] = [
            Constants.GameModel.id: TestConstants.empty,
            Constants.GameModel.tournament: TestConstants.tournamentName,
            Constants.GameModel.opponent: TestConstants.teamName,
            Constants.GameModel.finalScore: [Constants.ScoreModel.team: 15, Constants.ScoreModel.opponent: 10],
            Constants.GameModel.points: [[
                Constants.PointModel.wind: 0,
                Constants.PointModel.scored: true,
                Constants.PointModel.type: 0
            ]]
        ]
        // When
        let sut = GameDataModel(documentData: data)
        // Then
        // Then
        XCTAssertEqual(TestConstants.empty, sut!.id)
        XCTAssertEqual(TestConstants.tournamentName, sut!.tournament)
        XCTAssertEqual(TestConstants.teamName, sut!.opponent)
        let score = ScoreModel(opponent: 10, team: 15)
        XCTAssertEqual(score.team, sut!.finalScore.team)
        XCTAssertEqual(score.opponent, sut!.finalScore.opponent)
        XCTAssertEqual(1, sut!.points.count)
        XCTAssertEqual(0, sut!.points[0].wind)
        XCTAssertEqual(0, sut!.points[0].type)
        XCTAssertTrue(sut!.points[0].scored)
    }
    
    func testConvenienceInit_failure() throws {
        // Given
        let data: [String : Any] = [
            Constants.GameModel.id: TestConstants.empty,
            Constants.GameModel.tournament: TestConstants.tournamentName,
            Constants.GameModel.opponent: TestConstants.teamName
        ]
        // When
        let sut = GameDataModel(documentData: data)
        // Then
        XCTAssertNil(sut)
    }
    
    func testDictionary() throws {
        // When
        let sut = GameDataModel(id: TestConstants.empty, tournament: TestConstants.tournamentName, opponent: TestConstants.teamName)
        let id = sut.dictionary[Constants.GameModel.id] as? String
        let tournament = sut.dictionary[Constants.GameModel.tournament] as? String
        let opponent = sut.dictionary[Constants.GameModel.opponent] as? String
        let finalScore = sut.dictionary[Constants.GameModel.finalScore] as? [String: Any]
        let points = sut.dictionary[Constants.GameModel.points] as? [[String: Any]]
        // Then
        XCTAssertEqual(TestConstants.empty, id)
        XCTAssertEqual(TestConstants.tournamentName, tournament)
        XCTAssertEqual(TestConstants.teamName, opponent)
        let score = ScoreModel()
        XCTAssertEqual(score.team, finalScore![Constants.ScoreModel.team] as! Int)
        XCTAssertEqual(score.opponent, finalScore![Constants.ScoreModel.opponent] as! Int)
        XCTAssertEqual(0, points!.count)
    }
    
    func testAddPoint_scored() throws {
        // Given
        let sut = GameDataModel(id: TestConstants.empty, tournament: TestConstants.tournamentName, opponent: TestConstants.teamName)
        XCTAssertEqual(0, sut.points.count)
        // When
        sut.addPoint(point: PointDataModel(wind: 0, scored: true, type: 0))
        // Then
        XCTAssertEqual(1, sut.points.count)
        XCTAssertEqual(1, sut.finalScore.team)
        XCTAssertEqual(0, sut.finalScore.opponent)
    }
    
    func testAddPoint_notScored() throws {
        // Given
        let sut = GameDataModel(id: TestConstants.empty, tournament: TestConstants.tournamentName, opponent: TestConstants.teamName)
        XCTAssertEqual(0, sut.points.count)
        // When
        sut.addPoint(point: PointDataModel(wind: 0, scored: false, type: 0))
        // Then
        XCTAssertEqual(1, sut.points.count)
        XCTAssertEqual(0, sut.finalScore.team)
        XCTAssertEqual(1, sut.finalScore.opponent)
    }
}
