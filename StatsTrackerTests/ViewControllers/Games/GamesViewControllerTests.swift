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
    var viewModel: GamesCellViewModelSpy?
    
    override func setUp() {
        sut = GamesViewController.instantiate(.games)
        let _ = sut.view
        presenter = GamesPresenterSpy()
        viewModel = nil
        sut.presenter = presenter
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        presenter = nil
        viewModel = nil
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
        XCTAssertNil(sut.viewModel)
        // Given
        let vm = GamesCellViewModel(gameArray: [], delegate: self)
        // When
        sut.updateWithViewModel(vm: vm)
        // Then
        XCTAssertNotNil(sut.viewModel)
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
    
    func testDidSelectRow() throws {
        viewModel = GamesCellViewModelSpy(gameArray: [], delegate: self)
        sut.viewModel = viewModel
        XCTAssertEqual(0, viewModel?.goToGamePageCalled)
        // Given
        let indexPath = IndexPath(row: 0, section: 0)
        // When
        sut.tableView(sut.tableView, didSelectRowAt: indexPath)
        // Then
        XCTAssertEqual(1, viewModel?.goToGamePageCalled)
    }
}

//MARK: GamesPresenterSpy
class GamesPresenterSpy: Presenter, GamesPresenterProtocol {
    var viewWillAppearCalled: Int = 0
    func setViewModel() { }
    
    func onViewWillAppear() {
        viewWillAppearCalled += 1
    }
}

//MARK: GamesCellViewModelSpy
class GamesCellViewModelSpy: GamesCellViewModel {
    var goToGamePageCalled: Int = 0
    
    override func goToGamePage(at indexPath: IndexPath) {
        goToGamePageCalled += 1
    }
}

//MARK: GamesCellViewModelDelegate
extension GamesViewControllerTests: GamesCellViewModelDelegate {
    func goToGamePage(viewModel: GameViewModel) { }
    func updateView() { }
    func displayError(with: Error) {  }
}
