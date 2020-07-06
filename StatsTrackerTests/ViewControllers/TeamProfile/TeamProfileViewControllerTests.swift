//
//  TeamProfileViewControllerTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 5/13/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class TeamProfileViewControllerTests: XCTestCase {
    
    var sut: TeamProfileViewController!
    var presenter: TeamProfilePresenterSpy!
    
    override func setUp() {
        sut = TeamProfileViewController.instantiate(.team)
        let _ = sut.view
        presenter = TeamProfilePresenterSpy()
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
    
    func testUpdateWithViewModel_NotAnimating() throws {
        // Given
        let viewModel = Instance.ViewModel.teamProfile()
        // When
        sut.updateWithViewModel(viewModel: viewModel)
        // Then
        XCTAssertEqual(viewModel.teamName, sut.teamNameLabel.text)
        XCTAssertEqual(viewModel.teamImage, sut.teamImage.image)
    }
    
    func testUpdateWithViewModel_Animating() throws {
        // Given
        sut.activityIndicator.startAnimating()
        let viewModel = Instance.ViewModel.teamProfile()
        // When
        sut.updateWithViewModel(viewModel: viewModel)
        // Then
        XCTAssertFalse(sut.activityIndicator.isAnimating)
        XCTAssertTrue(sut.activityIndicator.isHidden)
        XCTAssertEqual(1, sut.teamNameLabel.alpha)
        XCTAssertEqual(1, sut.teamImage.alpha)
        XCTAssertEqual(viewModel.teamName, sut.teamNameLabel.text)
        XCTAssertEqual(viewModel.teamImage, sut.teamImage.image)
    }
    
    func testLoadingState() throws {
        XCTAssertFalse(sut.activityIndicator.isAnimating)
        XCTAssertTrue(sut.activityIndicator.isHidden)
        // When
        sut.loadingState()
        // Then
        XCTAssertTrue(sut.activityIndicator.isAnimating)
        XCTAssertFalse(sut.activityIndicator.isHidden)
        XCTAssertEqual(0, sut.teamNameLabel.alpha)
        XCTAssertEqual(0, sut.teamImage.alpha)
    }
    
    func testSettingsPressed() throws {
        XCTAssertEqual(0, presenter.settingsPressedCount)
        // When
        sut.settingsPressed()
        // Then
        XCTAssertEqual(1, presenter.settingsPressedCount)
    }
}

//MARK: TeamProfilePresenterSpy
class TeamProfilePresenterSpy: Presenter, TeamProfilePresenterProtocol {
    
    var viewModel: TeamProfileViewModel?
    var viewWillAppearCalled: Int = 0
    var settingsPressedCount: Int = 0
    
    func onViewWillAppear() {
        viewWillAppearCalled += 1
    }
    
    func settingsPressed() {
        settingsPressedCount += 1
    }
}
