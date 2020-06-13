//
//  GamesPresenterTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 5/14/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
import ViewControllerPresentationSpy
@testable import StatsTracker

class GamesPresenterTests: XCTestCase {
    
    var sut: GamesPresenter!
    var vc: GamesViewControllerSpy!
    var dbManager: MockDBManager!
    
    var goToGamePageCalled: Int = 0
    
    override func setUp() {
        vc = GamesViewControllerSpy()
        dbManager = MockDBManager()
        sut = GamesPresenter(vc: vc, delegate: self, dbManager: dbManager)
        vc.presenter = sut
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        vc = nil
        dbManager = nil
        super.tearDown()
    }
    
    func testOnViewWillAppear() throws {
        XCTAssertEqual(vc.navigationItem.title, nil)
        // When
        sut.onViewWillAppear()
        // Then
        XCTAssertEqual(vc.navigationItem.title, Constants.Titles.gamesTitle)
    }
    
    func testSetViewModel() throws {
        // Given sut init, then
        XCTAssertEqual(1, dbManager.getDataCalled)
    }
    
    func testGoToGamePage() throws {
        XCTAssertEqual(0, goToGamePageCalled)
        // Given
        let model = GameDataModel(id: TestConstants.empty, tournament: TestConstants.tournamentName, opponent: TestConstants.teamName)
        let viewModel = GameViewModel(model: model)
        // When
        sut.goToGamePage(viewModel: viewModel)
        // Then
        XCTAssertEqual(1, goToGamePageCalled)
    }
    
    func testDisplayDBError() throws {
        let alertVerifier = AlertVerifier()
        
        // Given
        let dbError = DBError.unknown
        // When
        sut.displayError(with: dbError)
        // Then
        alertVerifier.verify(
            title: Constants.Errors.documentErrorTitle,
            message: dbError.localizedDescription,
            animated: true,
            actions: [
                .default(TestConstants.Alerts.dismiss)
            ],
            presentingViewController: vc
        )
    }
    
    func testDisplayUnknownError() throws {
        let alertVerifier = AlertVerifier()
        XCTAssertNil(vc.viewModel)
        
        // Given
        let unknownError = TestConstants.error
        // When
        sut.displayError(with: unknownError)
        // Then
        alertVerifier.verify(
            title: Constants.Errors.documentErrorTitle,
            message: unknownError.localizedDescription,
            animated: true,
            actions: [
                .default(TestConstants.Alerts.dismiss)
            ],
            presentingViewController: vc
        )
        XCTAssertNotNil(vc.viewModel)
    }
    
    func testOnSuccessfulGet_GameDataModelSuccess() throws {
        XCTAssertEqual(0, vc.updateViewCalled)
        // Given
        vc.viewModel = nil
        let model = GameDataModel(id: TestConstants.empty, tournament: TestConstants.tournamentName, opponent: TestConstants.teamName)
        let data = [
            FirebaseKeys.CollectionPath.games: [model.dictionary]
        ]
        // When
        sut.onSuccessfulGet(data)
        // Then
        XCTAssertEqual(1, vc.updateViewCalled)
        XCTAssertEqual(1, vc.viewModel.items[0].count)
        XCTAssertEqual(model.opponent, vc.viewModel.items[0][0].opponent)
        XCTAssertEqual(model.tournament, vc.viewModel.items[0][0].tournament)
    }
    
    func testOnSuccessfulGet_GameDataModelFailure() throws {
        XCTAssertEqual(0, vc.updateViewCalled)
        // Given
        let gameDictionary = ["": ""]
        let data = [
            FirebaseKeys.CollectionPath.games: [gameDictionary]
        ]
        // When
        sut.onSuccessfulGet(data)
        // Then
        XCTAssertEqual(0, vc.viewModel.items.count)
        XCTAssertEqual(1, vc.updateViewCalled)
    }
}

//MARK: GamesPresenterDelegate
extension GamesPresenterTests: GamesPresenterDelegate {
    func goToGamePage(viewModel: GameViewModel) {
        goToGamePageCalled += 1
    }
}

//MARK: GamesViewControllerSpy
class GamesViewControllerSpy: GamesViewController {
    var updateViewCalled: Int = 0
    
    override func updateWithViewModel(vm: GamesCellViewModel) {
        updateViewCalled += 1
        viewModel = vm
    }
}
