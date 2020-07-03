//
//  HasDiscTableViewCellTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 7/3/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class HasDiscTableViewCellTests: XCTestCase {
    
    var sut: HasDiscTableViewCell!
    var item: PlayerViewModelSpy!
    
    private var turnoverCount: Int = 0
    
    override func setUp() {
        sut = HasDiscTableViewCell()
        let model = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])
        item = PlayerViewModelSpy(model: model)
        sut.item = item
        sut.delegate = self
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        item = nil
        super.tearDown()
    }
    
    func testThrowawayPressed() throws {
        XCTAssertEqual(0, turnoverCount)
        XCTAssertEqual(0, item.throwawayCalled)
        // When
        sut.throwawayPressed(UIButton())
        // Then
        XCTAssertEqual(1, turnoverCount)
        XCTAssertEqual(1, item.throwawayCalled)
    }
}

//MARK: HasDiscCellDelegate
extension HasDiscTableViewCellTests: HasDiscCellDelegate {
    func turnover() {
        turnoverCount += 1
    }
}
