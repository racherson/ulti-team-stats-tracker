//
//  HomeViewControllerTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 5/13/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class HomeViewControllerTests: XCTestCase {
    
    var sut: HomeViewController!
    
    var signUpPressedCount: Int = 0
    var loginPressedCount: Int = 0
    
    override func setUp() {
        sut = HomeViewController.instantiate(.auth)
        sut.delegate = self
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testSignUpPressed() throws {
        XCTAssertEqual(0, signUpPressedCount)
        // When
        sut.signUpPressed(UIButton())
        // Then
        XCTAssertEqual(1, signUpPressedCount)
    }
    
    func testLoginPressed() throws {
        XCTAssertEqual(0, loginPressedCount)
        // When
        sut.loginPressed(UIButton())
        // Then
        XCTAssertEqual(1, loginPressedCount)
    }
}

//MARK: HomeViewControllerDelegate
extension HomeViewControllerTests: HomeViewControllerDelegate {
    func signUpPressed() {
        signUpPressedCount += 1
    }
    
    func loginPressed() {
        loginPressedCount += 1
    }
}
