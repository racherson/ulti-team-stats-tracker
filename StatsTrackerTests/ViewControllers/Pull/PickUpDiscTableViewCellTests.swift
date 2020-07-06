//
//  PickUpDiscTableViewCellTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 7/3/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class PickUpDiscTableViewCellTests: XCTestCase {
    
    var sut: PickUpDiscTableViewCell!
    var item: PlayerViewModelSpy!
    
    private var catchDiscCount: Int = 0
    private var pickUpCount: Int = 0
    
    override func setUp() {
        sut = PickUpDiscTableViewCell()
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
    
    func testPickUpPressed() throws {
        XCTAssertEqual(0, pickUpCount)
        // Given
        sut.index = IndexPath(row: 0, section: 1)
        // When
        sut.pickUpPressed(UIButton())
        // Then
        XCTAssertEqual(1, pickUpCount)
    }
}

//MARK: PickUpDiscCellDelegate
extension PickUpDiscTableViewCellTests: PickUpDiscCellDelegate {
    func catchDisc(_ index: IndexPath) {
        catchDiscCount += 1
    }
    
    func pickUpPressed(_ index: IndexPath) {
        pickUpCount += 1
    }
}
