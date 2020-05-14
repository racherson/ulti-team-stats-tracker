//
//  GamesPresenterTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 5/14/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class GamesPresenterTests: XCTestCase {
    
    var sut: GamesPresenter!
    var vc: GamesViewController!
    
    override func setUp() {
        vc = GamesViewController.instantiate(.games)
        sut = GamesPresenter(vc: vc, delegate: self)
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
        XCTAssertEqual(vc.navigationItem.title, Constants.Titles.gamesTitle)
    }
}

//MARK: GamesPresenterDelegate
extension GamesPresenterTests: GamesPresenterDelegate { }

