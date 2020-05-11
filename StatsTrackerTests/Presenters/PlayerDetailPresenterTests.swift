//
//  PlayerDetailPresenterTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 5/11/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class PlayerDetailPresenterTests: XCTestCase {

    var sut: PlayerDetailPresenter!
    var vc: PlayerDetailViewController!
    var viewModel: PlayerViewModel!
    
    override func setUp() {
        vc = PlayerDetailViewController.instantiate(.roster)
        let _ = vc.view
        let model = PlayerModel(name: "Name", gender: 0, id: "")
        viewModel = PlayerViewModel(model: model)
        sut = PlayerDetailPresenter(vc: vc, delegate: self, viewModel: viewModel)
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        vc = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testOnViewWillAppear() throws {
        XCTAssertEqual(vc.navigationItem.title, nil)
        // When
        sut.onViewWillAppear()
        // Then
        XCTAssertEqual(viewModel.name, vc.navigationItem.title)
        XCTAssertEqual(viewModel.games, vc.gamesPlayedLabel.text)
        XCTAssertEqual(viewModel.points, vc.pointsPlayedLabel.text)
        XCTAssertEqual(viewModel.goals, vc.goalsLabel.text)
        XCTAssertEqual(viewModel.assists, vc.assistsLabel.text)
        XCTAssertEqual(viewModel.ds, vc.dLabel.text)
        XCTAssertEqual(viewModel.completions, vc.completionsLabel.text)
        XCTAssertEqual(viewModel.throwaways, vc.throwawaysLabel.text)
        XCTAssertEqual(viewModel.completionPercentage, vc.completionPercentLabel.text)
        XCTAssertEqual(viewModel.catches, vc.catchesLabel.text)
        XCTAssertEqual(viewModel.drops, vc.dropsLabel.text)
        XCTAssertEqual(viewModel.catchingPercentage, vc.catchPercentLabel.text)
        XCTAssertEqual(viewModel.pulls, vc.pullsLabel.text)
        XCTAssertEqual(viewModel.callahans, vc.callahanLabel.text)
    }
}

extension PlayerDetailPresenterTests: PlayerDetailPresenterDelegate { }
