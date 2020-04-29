//
//  TeamProfilePresenterTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 4/29/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class TeamProfilePresenterTests: XCTestCase {
    
    var sut: TeamProfilePresenter!
    var vc: TeamProfileViewController!
    var authManager: MockSignedInAuthManager!

    var settingsCalled: Int = 0

    override func setUp() {
        vc = TeamProfileViewController.instantiate(.team)
        let _ = vc.view
        sut = TeamProfilePresenter(vc: vc, delegate: self, authManager: MockSignedInAuthManager())
        sut.authManager = authManager
        super.setUp()
    }

    override func tearDown() {
        sut = nil
        vc = nil
        authManager = nil
        super.tearDown()
    }

    func testOnViewWillAppear() throws {
        sut.onViewWillAppear()
        XCTAssertTrue(vc.activityIndicator.isAnimating)
        sut.viewModel = TeamProfileViewModel(team: TestConstants.teamName, image: TestConstants.teamImage)
        sut.onViewWillAppear()
        XCTAssertTrue(vc.activityIndicator.isHidden)
        XCTAssertEqual(vc.teamNameLabel.text, TestConstants.teamName)
        XCTAssertEqual(vc.teamImage.image, TestConstants.teamImage)
    }

    func testSettingsPressed() throws {
        XCTAssertEqual(0, settingsCalled)
        sut.viewModel = TeamProfileViewModel(team: TestConstants.teamName, image: TestConstants.teamImage)
        sut.settingsPressed()
        XCTAssertEqual(1, settingsCalled)
    }
}

//MARK: TeamProfilePresenterDelegate Mock
extension TeamProfilePresenterTests: TeamProfilePresenterDelegate {
    func settingsPressed(vm: TeamProfileViewModel) {
        self.settingsCalled += 1
    }
}
