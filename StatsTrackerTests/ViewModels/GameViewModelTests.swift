//
//  GameViewModelTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 7/6/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class GameViewModelTests: XCTestCase {
    
    var sut: GameViewModel!
    
    override func setUp() {
        let model = Instance.getGameDataModel()
        model.addPoint(point: PointDataModel(wind: 0, scored: false, type: 0))
        model.addPoint(point: PointDataModel(wind: 1, scored: true, type: 0))
        model.addPoint(point: PointDataModel(wind: 0, scored: true, type: 1))
        sut = GameViewModel(model: model)
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testModelProperties() throws {
        XCTAssertEqual(TestConstants.tournamentName, sut.tournament)
        XCTAssertEqual(TestConstants.teamName, sut.opponent)
        XCTAssertEqual("2-1", sut.finalScore)
        XCTAssertTrue(sut.win)
    }
    
    func testCalculatedStats_nonzero() throws {
        XCTAssertEqual("1", sut.breaksFor)
        XCTAssertEqual("1", sut.breaksAgainst)
        XCTAssertEqual("50.0", sut.offensiveEfficiency)
    }
    
    func testCalculatedStats_zero() throws {
        let sut = GameViewModel(model: Instance.getGameDataModel())
        XCTAssertEqual("0", sut.breaksFor)
        XCTAssertEqual("0", sut.breaksAgainst)
        XCTAssertEqual("0", sut.offensiveEfficiency)
    }
}
