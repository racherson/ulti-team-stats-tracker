//
//  PullViewControllerTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 5/14/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class PullViewControllerTests: XCTestCase {

    var sut: PullViewController!
    var presenter: PullPresenterSpy!

    override func setUp() {
        sut = PullViewController.instantiate(.pull)
        let _ = sut.view
        presenter = PullPresenterSpy()
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

class PullPresenterSpy: Presenter, PullPresenterProtocol {

    var viewWillAppearCalled: Int = 0

    func onViewWillAppear() {
        viewWillAppearCalled += 1
    }
}
