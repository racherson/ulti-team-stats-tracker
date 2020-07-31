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
        viewModel = Instance.ViewModel.player()
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
    }
}

//MARK: PlayerDetailPresenterDelegate
extension PlayerDetailPresenterTests: PlayerDetailPresenterDelegate { }
