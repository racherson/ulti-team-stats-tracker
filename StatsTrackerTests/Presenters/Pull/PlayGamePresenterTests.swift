//
//  PlayGamePresenterTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 5/17/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class PlayGamePresenterTests: XCTestCase {
    
    var sut: PlayGamePresenter!
    var vc: PlayGameViewController!
    
    override func setUp() {
        vc = PlayGameViewController.instantiate(.pull)
        sut = PlayGamePresenter(vc: vc, delegate: self)
        vc.presenter = sut
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        vc = nil
        super.tearDown()
    }
    
    func testOnViewWillAppear() throws {
    }
}

//MARK: PlayGamePresenterDelegate
extension PlayGamePresenterTests: PlayGamePresenterDelegate { }
