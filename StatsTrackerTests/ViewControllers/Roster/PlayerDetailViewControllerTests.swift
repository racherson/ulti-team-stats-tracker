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
    
    func testUpdateWithViewModel() throws {
        // Given
        let model = PlayerModel(name: TestConstants.playerName, gender: Gender.women.rawValue, id: TestConstants.empty, roles: [0])
        let vm = PlayerViewModel(model: model)
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
        XCTAssertEqual(title, sut.vm?.roles)
    }
    
    func testTitleForHeaderInSection_1() throws {
        // Given
        let section = 1
        // When
        let title = sut.tableView(UITableView(), titleForHeaderInSection: section)
        // Then
        XCTAssertNil(title)
    }
    
    func testConfigureTableViewCell_games() {
        // Given
        let tableView = UITableView()
        tableView.register(PlayerDetailTableViewCell.self, forCellReuseIdentifier: "PlayerDetailTableViewCell")
        sut.vm = Instance.ViewModel.player()
        // When
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView(tableView, cellForRowAt: indexPath) as! PlayerDetailTableViewCell
        // Then
        XCTAssertEqual(PlayerDetailCellType.games.description, cell.textLabel?.text)
    }
    
    func testConfigureTableViewCell_completions() {
        // Given
        let tableView = UITableView()
        tableView.register(PlayerDetailTableViewCell.self, forCellReuseIdentifier: "PlayerDetailTableViewCell")
        sut.vm = Instance.ViewModel.player()
        // When
        let indexPath = IndexPath(row: 5, section: 0)
        let cell = sut.tableView(tableView, cellForRowAt: indexPath) as! PlayerDetailTableViewCell
        // Then
        XCTAssertEqual(PlayerDetailCellType.completions.description, cell.textLabel?.text)
    }
}

//MARK: PlayerDetailPresenterSpy
class PlayerDetailPresenterSpy: Presenter, PlayerDetailPresenterProtocol {
    var viewWillAppearCalled: Int = 0
    
    func onViewWillAppear() {
        viewWillAppearCalled += 1
    }
}
