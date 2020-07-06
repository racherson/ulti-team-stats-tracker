//
//  NoDiscTableViewCellTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 7/3/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class NoDiscTableViewCellTests: XCTestCase {
    
    var sut: NoDiscTableViewCell!
    var item: PlayerViewModelSpy!
    
    private var scorePressedCount: Int = 0
    private var catchDiscCount: Int = 0
    private var dropDiscCount: Int = 0
    
    override func setUp() {
        sut = NoDiscTableViewCell()
        item = PlayerViewModelSpy(model: Instance.getPlayerModel())
        sut.item = item
        sut.delegate = self
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        item = nil
        super.tearDown()
    }
    
    func testCatchPressed() throws {
        XCTAssertEqual(0, catchDiscCount)
        XCTAssertEqual(0, item.catchCalled)
        // Given
        sut.index = IndexPath(row: 0, section: 1)
        // When
        sut.catchPressed(UIButton())
        // Then
        XCTAssertEqual(1, catchDiscCount)
        XCTAssertEqual(1, item.catchCalled)
    }
    
    func testDropPressed() throws {
        XCTAssertEqual(0, dropDiscCount)
        XCTAssertEqual(0, item.dropCalled)
        // When
        sut.dropPressed(UIButton())
        // Then
        XCTAssertEqual(1, dropDiscCount)
        XCTAssertEqual(1, item.dropCalled)
    }
    
    func testScorePressed() throws {
        XCTAssertEqual(0, scorePressedCount)
        XCTAssertEqual(0, item.goalCalled)
        // When
        sut.scorePressed(UIButton())
        // Then
        XCTAssertEqual(1, scorePressedCount)
        XCTAssertEqual(1, item.goalCalled)
    }
}

//MARK: NoDiscCellDelegate
extension NoDiscTableViewCellTests: NoDiscCellDelegate {
    
    func scorePressed() {
        scorePressedCount += 1
    }
    
    func catchDisc(_ index: IndexPath) {
        catchDiscCount += 1
    }
    
    func dropDisc() {
        dropDiscCount += 1
    }
}
