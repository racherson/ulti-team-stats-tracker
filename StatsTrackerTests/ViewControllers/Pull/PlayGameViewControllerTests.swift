//
//  PlayGameViewControllerTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 6/25/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class PlayGameViewControllerTests: XCTestCase {
    
    var sut: PlayGameViewController!
    var presenter: PlayGamePresenterSpy!
    var vm: PlayGameCellViewModel!
    var tableView: TableViewSpy!
    
    private var nextPointCalled: Int = 0
    
    override func setUp() {
        sut = PlayGameViewController.instantiate(.pull)
        let _ = sut.view
        presenter = PlayGamePresenterSpy()
        let model = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])
        let player = PlayerViewModel(model: model)
        vm = PlayGameCellViewModel(playerArray: [[], [player], []], delegate: self)
        tableView = TableViewSpy()
        sut.tableView = tableView
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
    
    func testUpdateWithViewModel() throws {
        XCTAssertFalse(tableView.reloadDataCalled)
        XCTAssertFalse(tableView.dataSourceSet)
        // Given
        let vm = PlayGameCellViewModel(playerArray: [[], [], []], delegate: self)
        // When
        sut.updateWithViewModel(vm: vm)
        // Then
        XCTAssertTrue(tableView.reloadDataCalled)
        XCTAssertTrue(tableView.dataSourceSet)
    }
}

//MARK: PlayGameCellViewModelDelegate
extension PlayGameViewControllerTests: PlayGameCellViewModelDelegate {
    func nextPoint(scored: Bool) {
        nextPointCalled += 1
    }
}

//MARK: PlayGamePresenterSpy
class PlayGamePresenterSpy: Presenter, PlayGamePresenterProtocol {
    
    var viewWillAppearCalled: Int = 0
    
    func onViewWillAppear() {
        viewWillAppearCalled += 1
    }
}
