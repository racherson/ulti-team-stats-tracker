//
//  GameDetailPresenterTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 6/10/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class GameDetailPresenterTests: XCTestCase {
    var sut: GameDetailPresenter!
    var vc: GameDetailViewControllerSpy!
    var viewModel: GameViewModel!
    
    override func setUp() {
        vc = GameDetailViewControllerSpy()
        let model = Instance.getGameDataModel()
        viewModel = GameViewModel(model: model)
        sut = GameDetailPresenter(vc: vc, delegate: self, viewModel: viewModel)
        vc.presenter = sut
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
        XCTAssertEqual(0, vc.updateWithViewModelCalled)
        // When
        sut.onViewWillAppear()
        // Then
        XCTAssertEqual(vc.navigationItem.title, TestConstants.teamName)
        XCTAssertEqual(1, vc.updateWithViewModelCalled)
    }
}

//MARK: GameDetailPresenterDelegate
extension GameDetailPresenterTests: GameDetailPresenterDelegate { }

//MARK: GameDetailViewControllerSpy
class GameDetailViewControllerSpy: GameDetailViewController {
    var updateWithViewModelCalled: Int = 0
    
    override func updateWithViewModel(vm: GameViewModel) {
        updateWithViewModelCalled += 1
    }
}
