//
//  PlayGameViewControllerTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 5/17/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class PlayGameViewControllerTests: XCTestCase {
    
    var sut: PlayGameViewController!
    var presenter: PlayGamePresenterSpy!
    
    override func setUp() {
        sut = PlayGameViewController.instantiate(.pull)
        let _ = sut.view
        presenter = PlayGamePresenterSpy()
        sut.presenter = presenter
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        presenter = nil
        super.tearDown()
    }
    
    func testViewWillAppear() throws {
        XCTAssertEqual(0, presenter.viewWillAppearCalled)
        // When
        sut.viewWillAppear(false)
        // Then
        XCTAssertEqual(1, presenter.viewWillAppearCalled)
    }
}

//MARK: PlayGamePresenterSpy
class PlayGamePresenterSpy: Presenter, PlayGamePresenterProtocol {
    
    var viewWillAppearCalled: Int = 0
    
    func onViewWillAppear() {
        viewWillAppearCalled += 1
    }
}
