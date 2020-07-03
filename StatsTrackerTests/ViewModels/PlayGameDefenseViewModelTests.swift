//
//  PlayGameDefenseCellViewModelTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 7/2/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class PlayGameDefenseCellViewModelTests: XCTestCase {
    
    var sut: PlayGameOffenseCellViewModel!
    
    override func setUp() {
        let playerArray = [[], [PlayerViewModel(model: PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: []))], []]
        sut = PlayGameOffenseCellViewModel(playerArray: playerArray, delegate: self)
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

}
