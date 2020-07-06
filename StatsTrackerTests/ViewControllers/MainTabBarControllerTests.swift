//
//  MainTabBarControllerTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 5/13/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class MainTabBarControllerTests: XCTestCase {
    
    var sut: MainTabBarController!
    
    private var transitionCalled: Int = 0
    
    override func setUp() {
        sut = MainTabBarController()
        sut.coordinator = self
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testViewDidLoad() throws {
        XCTAssertEqual(4, sut.viewControllers?.count)
    }
    
    func testTransitionToHome() throws {
        XCTAssertEqual(0, transitionCalled)
        // When
        sut.transitionToHome()
        // Then
        XCTAssertEqual(1, transitionCalled)
    }
}

//MARK: MainTabBarControllerDelegate
extension MainTabBarControllerTests: MainTabBarControllerDelegate {
    func transitionToHome() {
        transitionCalled += 1
    }
}
