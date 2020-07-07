//
//  GameDetailViewControllerTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 6/10/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class GameDetailViewControllerTests: XCTestCase {
    
    var sut: GameDetailViewController!
    var presenter: GameDetailPresenterSpy!
    
    override func setUp() {
        sut = GameDetailViewController.instantiate(.games)
        let _ = sut.view
        presenter = GameDetailPresenterSpy()
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
        let vm = GameViewModel(model: Instance.getGameDataModel())
        // When
        sut.updateWithViewModel(vm: vm)
        // Then
        XCTAssertEqual(sut.tournamentLabel.text, TestConstants.tournamentName)
        XCTAssertEqual(sut.scoreLabel.text, vm.finalScore)
        XCTAssertEqual(sut.breaksLabel.text, vm.breaksFor)
        XCTAssertEqual(sut.breaksAgainstLabel.text, vm.breaksAgainst)
        XCTAssertEqual(sut.offensiveEfficiencyLabel.text, vm.offensiveEfficiency)
    }
    
    func testUpdateWithViewModel_NotEmpty() throws {
        // Given
        let model = GameDataModel(id: TestConstants.empty, tournament: TestConstants.tournamentName, opponent: TestConstants.teamName, finalScore: [Constants.ScoreModel.team: 15, Constants.ScoreModel.opponent: 10], points: [])
        let vm = GameViewModel(model: model)
        // When
        sut.updateWithViewModel(vm: vm)
        // Then
        XCTAssertEqual(sut.tournamentLabel.text, TestConstants.tournamentName)
        XCTAssertEqual(sut.scoreLabel.text, vm.finalScore)
        XCTAssertEqual(sut.breaksLabel.text, vm.breaksFor)
        XCTAssertEqual(sut.breaksAgainstLabel.text, vm.breaksAgainst)
        XCTAssertEqual(sut.offensiveEfficiencyLabel.text, vm.offensiveEfficiency)
    }
}

//MARK: GameDetailPresenterSpy
class GameDetailPresenterSpy: Presenter, GameDetailPresenterProtocol {
    var viewWillAppearCalled: Int = 0
    
    func onViewWillAppear() {
        viewWillAppearCalled += 1
    }
}
