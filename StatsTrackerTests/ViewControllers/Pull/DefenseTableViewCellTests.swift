//
//  DefenseTableViewCellTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 7/3/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class DefenseTableViewCellTests: XCTestCase {
    
    var sut: DefenseTableViewCell!
    var item: PlayerViewModelSpy!
    
    private var dCount: Int = 0
    private var callahanCount: Int = 0
    
    override func setUp() {
        sut = DefenseTableViewCell()
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
    
    func testDPressed() throws {
        XCTAssertEqual(0, dCount)
        XCTAssertEqual(0, item.dCount)
        // When
        sut.dPressed(UIButton())
        // Then
        XCTAssertEqual(1, dCount)
        XCTAssertEqual(1, item.dCount)
    }
    
    func testCallahanPressed() throws {
        XCTAssertEqual(0, callahanCount)
        XCTAssertEqual(0, item.callahanCount)
        // When
        sut.callahanPressed(UIButton())
        // Then
        XCTAssertEqual(1, callahanCount)
        XCTAssertEqual(1, item.callahanCount)
    }
}

//MARK: DefenseCellDelegate
extension DefenseTableViewCellTests: DefenseCellDelegate {
    func dPressed() {
        dCount += 1
    }
    
    func callahanPressed() {
        callahanCount += 1
    }
}
