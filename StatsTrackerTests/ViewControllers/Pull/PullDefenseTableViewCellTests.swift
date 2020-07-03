//
//  PullDefenseTableViewCellTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 7/3/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class PullDefenseTableViewCellTests: XCTestCase {
    
    var sut: PullDefenseTableViewCell!
    var item: PlayerViewModelSpy!
    
    private var pullCount: Int = 0
    
    override func setUp() {
        sut = PullDefenseTableViewCell()
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
    
    func testPullPressed() throws {
        XCTAssertEqual(0, pullCount)
        XCTAssertEqual(0, item.pullCount)
        // When
        sut.pullPressed(UIButton())
        // Then
        XCTAssertEqual(1, pullCount)
        XCTAssertEqual(1, item.pullCount)
    }
}

//MARK: PullDefenseCellDelegate
extension PullDefenseTableViewCellTests: PullDefenseCellDelegate {
    func pull() {
        pullCount += 1
    }
}

