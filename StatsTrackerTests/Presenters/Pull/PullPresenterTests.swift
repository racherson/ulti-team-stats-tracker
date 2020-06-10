//
//  PullPresenterTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 5/14/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class PullPresenterTests: XCTestCase {

    var sut: PullPresenter!
    var vc: PullViewController!
    
    var startGameCount: Int = 0
    
    override func setUp() {
        vc = PullViewController.instantiate(.pull)
        sut = PullPresenter(vc: vc, delegate: self)
        vc.presenter = sut
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        vc = nil
        super.tearDown()
    }
    
    func testOnViewWillAppear() throws {
        XCTAssertEqual(vc.navigationItem.title, nil)
        // When
        sut.onViewWillAppear()
        // Then
        XCTAssertEqual(vc.navigationItem.title, Constants.Titles.pullTitle)
    }
    
    func testStartGamePressed() throws {
        XCTAssertEqual(0, startGameCount)
        // Given
        let game = GameDataModel(id: TestConstants.empty, tournament: TestConstants.empty, opponent: TestConstants.empty)
        let wind = WindDirection(rawValue: 0)!
        let point = PointType(rawValue: 0)!
        // When
        sut.startGamePressed(gameModel: game, wind: wind, point: point)
        // Then
        XCTAssertEqual(1, startGameCount)
    }
}

//MARK: PullPresenterDelegate
extension PullPresenterTests: PullPresenterDelegate {
    func startGamePressed(gameModel: GameDataModel, wind: WindDirection, point: PointType) {
        startGameCount += 1
    }
}
