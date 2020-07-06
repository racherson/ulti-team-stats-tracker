//
//  PlayerDetailViewControllerTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 5/13/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class PlayerDetailViewControllerTests: XCTestCase {
    
    var sut: PlayerDetailViewController!
    var presenter: PlayerDetailPresenterSpy!
    
    override func setUp() {
        sut = PlayerDetailViewController.instantiate(.roster)
        let _ = sut.view
        presenter = PlayerDetailPresenterSpy()
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
    
    func testUpdateWithViewModel_Empty() throws {
        // Given
        let model = PlayerModel(name: TestConstants.playerName, gender: Gender.women.rawValue, id: TestConstants.empty, roles: [0])
        let vm = PlayerViewModel(model: model)
        // When
        sut.updateWithViewModel(vm: vm)
        // Then
        XCTAssertEqual(sut.rolesLabel.text, Roles(rawValue: 0)?.description)
        XCTAssertEqual(sut.gamesPlayedLabel.text, vm.games)
        XCTAssertEqual(sut.pointsPlayedLabel.text, vm.points)
        XCTAssertEqual(sut.goalsLabel.text, vm.goals)
        XCTAssertEqual(sut.assistsLabel.text, vm.assists)
        XCTAssertEqual(sut.dLabel.text, vm.ds)
        XCTAssertEqual(sut.completionsLabel.text, vm.completions)
        XCTAssertEqual(sut.throwawaysLabel.text, vm.throwaways)
        XCTAssertEqual(sut.completionPercentLabel.text, vm.completionPercentage)
        XCTAssertEqual(sut.catchesLabel.text, vm.catches)
        XCTAssertEqual(sut.dropsLabel.text, vm.drops)
        XCTAssertEqual(sut.catchPercentLabel.text, vm.catchingPercentage)
        XCTAssertEqual(sut.pullsLabel.text, vm.pulls)
        XCTAssertEqual(sut.callahanLabel.text, vm.callahans)
    }
    
    func testUpdateWithViewModel_NotEmpty() throws {
        // Given
        let model = PlayerModel(name: TestConstants.playerName, gender: Gender.women.rawValue, id: TestConstants.empty, points: 0, games: 0, completions: 80, throwaways: 20, catches: 100, drops: 5, goals: 0, assists: 0, ds: 0, pulls: 0, callahans: 0, roles: [0])
        let vm = PlayerViewModel(model: model)
        // When
        sut.updateWithViewModel(vm: vm)
        // Then
        XCTAssertEqual(sut.completionsLabel.text, vm.completions)
        XCTAssertEqual(sut.throwawaysLabel.text, vm.throwaways)
        XCTAssertEqual(sut.completionPercentLabel.text, vm.completionPercentage)
        XCTAssertEqual(sut.catchesLabel.text, vm.catches)
        XCTAssertEqual(sut.dropsLabel.text, vm.drops)
        XCTAssertEqual(sut.catchPercentLabel.text, vm.catchingPercentage)
    }
    
    func testGetRolesString_Multiple() throws {
        // Given
        let model = PlayerModel(name: TestConstants.playerName, gender: Gender.women.rawValue, id: TestConstants.empty, roles: [0, 1])
        let viewModel = PlayerViewModel(model: model)
        // When
        sut.updateWithViewModel(vm: viewModel)
        // Then
        XCTAssertEqual(sut.rolesLabel.text, Roles(rawValue: 0)!.description + ", " + Roles(rawValue: 1)!.description)
    }
    
    func testGetRolesString_None() throws {
        // Given
        let viewModel = Instance.ViewModel.player()
        // When
        sut.updateWithViewModel(vm: viewModel)
        // Then
        XCTAssertEqual(sut.rolesLabel.text, TestConstants.empty)
    }
}

//MARK: PlayerDetailPresenterSpy
class PlayerDetailPresenterSpy: Presenter, PlayerDetailPresenterProtocol {
    var viewWillAppearCalled: Int = 0
    
    func onViewWillAppear() {
        viewWillAppearCalled += 1
    }
}
