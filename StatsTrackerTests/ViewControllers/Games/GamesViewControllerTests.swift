//
//  GamesViewControllerTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 5/14/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class GamesViewControllerTests: XCTestCase {
    
    var sut: GamesViewController!
    var presenter: GamesPresenterSpy!
    
    override func setUp() {
        sut = GamesViewController.instantiate(.games)
        let _ = sut.view
        presenter = GamesPresenterSpy()
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
    
    func testUpdateView() throws {
        // Given
        let tableView = TableViewSpy()
        sut.tableView = tableView
        // When
        sut.updateView()
        // Then
        XCTAssertTrue(tableView.reloadDataCalled)
    }
    
    func testNumberOfRowsInSection() throws {
        XCTAssertEqual(0, presenter.numberOfGamesInSectionCalled)
        // When
        let _ = sut.tableView(UITableView(), numberOfRowsInSection: 0)
        // Then
        XCTAssertEqual(1, presenter.numberOfGamesInSectionCalled)
    }
    
    func testTitleForHeaderInSection() throws {
        XCTAssertEqual(0, presenter.getTournamentCalled)
        // Given
        let tableView = TableViewSpy()
        sut.tableView = tableView
        // When
        let title = sut.tableView(sut.tableView, titleForHeaderInSection: 0)
        // Then
        XCTAssertEqual(1, presenter.getTournamentCalled)
        XCTAssertEqual(TestConstants.tournamentName, title)
    }
    
    func testConfigureTableViewCell() {
        XCTAssertEqual(0, presenter.getGameOpponentCalled)
        // Given
        let tableView = sut.tableView
        // When
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView(tableView!, cellForRowAt: indexPath)
            as! GamesTableViewCell
        // Then
        XCTAssertEqual(TestConstants.teamName, cell.textLabel?.text)
        XCTAssertEqual(1, presenter.getGameOpponentCalled)
    }
    
    func testDidSelectRow() throws {
        XCTAssertEqual(0, presenter.goToGamePageCalled)
        // Given
        let indexPath = IndexPath(row: 0, section: 0)
        // When
        sut.tableView(sut.tableView, didSelectRowAt: indexPath)
        // Then
        XCTAssertEqual(1, presenter.goToGamePageCalled)
    }
}

class GamesPresenterSpy: Presenter, GamesPresenterProtocol {
    
    var viewWillAppearCalled: Int = 0
    var numberOfTourneysCalled: Int = 0
    var numberOfGamesInSectionCalled: Int = 0
    var getGameOpponentCalled: Int = 0
    var getTournamentCalled: Int = 0
    var goToGamePageCalled: Int = 0
    var tournamentArrays: [[GameDataModel]] = [[GameDataModel]]()
    
    func setTournamentArrays() { }
    
    func onViewWillAppear() {
        viewWillAppearCalled += 1
    }
    
    func numberOfTournaments() -> Int {
        numberOfTourneysCalled += 1
        return 1
    }
    
    func numberOfGamesInSection(_ section: Int) -> Int {
        numberOfGamesInSectionCalled += 1
        return 1
    }
    
    func getGameOpponent(at indexPath: IndexPath) -> String {
        getGameOpponentCalled += 1
        return TestConstants.teamName
    }
    
    func getTournament(at indexPath: IndexPath) -> String {
        getTournamentCalled += 1
        return TestConstants.tournamentName
    }
    
    func goToGamePage(at indexPath: IndexPath) {
        goToGamePageCalled += 1
    }
}
