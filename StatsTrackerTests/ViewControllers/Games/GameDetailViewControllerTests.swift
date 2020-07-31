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
    
    func testUpdateWithViewModel() throws {
        // Given
        let vm = GameViewModel(model: Instance.getGameDataModel())
        let tableView = TableViewSpy()
        sut.tableView = tableView
        // When
        sut.updateWithViewModel(vm: vm)
        // Then
        XCTAssertTrue(tableView.reloadDataCalled)
    }
    
    func testTitleForHeaderInSection_0() throws {
        // Given
        let section = 0
        // When
        let title = sut.tableView(UITableView(), titleForHeaderInSection: section)
        // Then
        XCTAssertEqual(title, sut.vm?.tournament)
    }
    
    func testTitleForHeaderInSection_1() throws {
        // Given
        let section = 1
        // When
        let title = sut.tableView(UITableView(), titleForHeaderInSection: section)
        // Then
        XCTAssertNil(title)
    }
    
    func testConfigureTableViewCell_score() {
        // Given
        let tableView = UITableView()
        tableView.register(GameDetailTableViewCell.self, forCellReuseIdentifier: "GameDetailTableViewCell")
        sut.vm = Instance.ViewModel.game()
        // When
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView(tableView, cellForRowAt: indexPath) as! GameDetailTableViewCell
        // Then
        XCTAssertEqual(GameDetailCellType.score.description, cell.textLabel?.text)
    }
    
    func testConfigureTableViewCell_offensiveEfficiency() {
        // Given
        let tableView = UITableView()
        tableView.register(GameDetailTableViewCell.self, forCellReuseIdentifier: "GameDetailTableViewCell")
        sut.vm = Instance.ViewModel.game()
        // When
        let indexPath = IndexPath(row: 3, section: 0)
        let cell = sut.tableView(tableView, cellForRowAt: indexPath) as! GameDetailTableViewCell
        // Then
        XCTAssertEqual(GameDetailCellType.offensiveEfficiency.description, cell.textLabel?.text)
    }
}

//MARK: GameDetailPresenterSpy
class GameDetailPresenterSpy: Presenter, GameDetailPresenterProtocol {
    var viewWillAppearCalled: Int = 0
    
    func onViewWillAppear() {
        viewWillAppearCalled += 1
    }
}
