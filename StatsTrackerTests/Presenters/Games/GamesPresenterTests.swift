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
    var vc: GamesViewController!
    var dbManager: MockDBManager!
    
    var goToGamePageCalled: Int = 0
    
    override func setUp() {
        vc = GamesViewController.instantiate(.games)
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
    
    func testSetTournamentArrays() throws {
        // Given sut init, then
        XCTAssertEqual(1, dbManager.getDataCalled)
    }
    
    func testNumberOfTournaments() throws {
        // Given
        sut.tournamentModels = [[GameDataModel(id: TestConstants.empty, tournament: TestConstants.empty, opponent: TestConstants.empty)]]
        // When
        let result = sut.numberOfTournaments()
        // Then
        XCTAssertEqual(1, result)
    }
    
    func testNumberOfPlayersInSection_EmptySection() throws {
        // Given
        let array1: [GameDataModel] = []
        let array2: [GameDataModel] = []
        // When
        sut.tournamentModels = [array1, array2]
        // Then
        XCTAssertEqual(array1.count, sut.numberOfGamesInSection(0))
        XCTAssertEqual(array2.count, sut.numberOfGamesInSection(1))
    }
    
    func testNumberOfPlayersInSection_NonEmptySection() throws {
        // Given
        let tournament1: [GameDataModel] = [GameDataModel(id: TestConstants.empty, tournament: TestConstants.empty, opponent: TestConstants.empty), GameDataModel(id: TestConstants.empty, tournament: TestConstants.empty, opponent: TestConstants.empty)]
        let tournament2: [GameDataModel] = [GameDataModel(id: TestConstants.empty, tournament: TestConstants.empty, opponent: TestConstants.empty)]
        // When
        sut.tournamentModels = [tournament1, tournament2]
        // Then
        XCTAssertEqual(tournament1.count, sut.numberOfGamesInSection(0))
        XCTAssertEqual(tournament2.count, sut.numberOfGamesInSection(1))
    }
    
    func testNumberOfPlayersInSection_OutOfBounds() throws {
        // Given
        let array1: [GameDataModel] = []
        let array2: [GameDataModel] = []
        let sectionGreaterThan = 2
        let sectionLessThan = -1
        // When
        sut.tournamentModels = [array1, array2]
        // Then
        XCTAssertEqual(Constants.Empty.int, sut.numberOfGamesInSection(sectionGreaterThan))
        XCTAssertEqual(Constants.Empty.int, sut.numberOfGamesInSection(sectionGreaterThan))
        XCTAssertEqual(Constants.Empty.int, sut.numberOfGamesInSection(sectionLessThan))
        XCTAssertEqual(Constants.Empty.int, sut.numberOfGamesInSection(sectionLessThan))
    }
    
    func testGetGameOpponent() throws {
        // Given
        let tournament1: [GameDataModel] = [GameDataModel(id: TestConstants.empty, tournament: TestConstants.empty, opponent: "Opponent1")]
        let tournament2: [GameDataModel] = [GameDataModel(id: TestConstants.empty, tournament: TestConstants.empty, opponent: "Opponent2")]
        sut.tournamentModels = [tournament1, tournament2]
        // When
        let indexPath1 = IndexPath(row: 0, section: 0)
        let indexPath2 = IndexPath(row: 0, section: 1)
        let opponent1Name = sut.getGameOpponent(at: indexPath1)
        let opponent2Name = sut.getGameOpponent(at: indexPath2)
        // Then
        XCTAssertEqual("Opponent1", opponent1Name)
        XCTAssertEqual("Opponent2", opponent2Name)
    }
    
    func testGetGameOpponent_SectionOutOfBounds() throws {
        // Given
        let tournament1: [GameDataModel] = [GameDataModel(id: TestConstants.empty, tournament: TestConstants.empty, opponent: "Opponent1")]
        let tournament2: [GameDataModel] = [GameDataModel(id: TestConstants.empty, tournament: TestConstants.empty, opponent: "Opponent2")]
        sut.tournamentModels = [tournament1, tournament2]
        // When
        let indexPath1 = IndexPath(row: 0, section: -1)
        let indexPath2 = IndexPath(row: 0, section: 2)
        let opponent1Name = sut.getGameOpponent(at: indexPath1)
        let opponent2Name = sut.getGameOpponent(at: indexPath2)
        // Then
        XCTAssertEqual(TestConstants.empty, opponent1Name)
        XCTAssertEqual(TestConstants.empty, opponent2Name)
    }
    
    func testGetGameOpponent_RowOutOfBounds() throws {
        // Given
        let tournament1: [GameDataModel] = [GameDataModel(id: TestConstants.empty, tournament: TestConstants.empty, opponent: "Opponent1")]
        let tournament2: [GameDataModel] = [GameDataModel(id: TestConstants.empty, tournament: TestConstants.empty, opponent: "Opponent2")]
        sut.tournamentModels = [tournament1, tournament2]
        // When
        let indexPath1 = IndexPath(row: -1, section: 0)
        let indexPath2 = IndexPath(row: 2, section: 1)
        let opponent1Name = sut.getGameOpponent(at: indexPath1)
        let opponent2Name = sut.getGameOpponent(at: indexPath2)
        // Then
        XCTAssertEqual(TestConstants.empty, opponent1Name)
        XCTAssertEqual(TestConstants.empty, opponent2Name)
    }
    
    func testGetTournament() throws {
        // Given
        let tournament1: [GameDataModel] = [GameDataModel(id: TestConstants.empty, tournament: "Tournament1", opponent: TestConstants.empty)]
        let tournament2: [GameDataModel] = [GameDataModel(id: TestConstants.empty, tournament: "Tournament2", opponent: TestConstants.empty)]
        sut.tournamentModels = [tournament1, tournament2]
        // When
        let indexPath1 = IndexPath(row: 0, section: 0)
        let indexPath2 = IndexPath(row: 0, section: 1)
        let tourney1Name = sut.getTournament(at: indexPath1)
        let tourney2Name = sut.getTournament(at: indexPath2)
        // Then
        XCTAssertEqual("Tournament1", tourney1Name)
        XCTAssertEqual("Tournament2", tourney2Name)
    }
    
    func testGetTournament_SectionOutOfBounds() throws {
        // Given
        let tournament1: [GameDataModel] = [GameDataModel(id: TestConstants.empty, tournament: "Tournament1", opponent: TestConstants.empty)]
        let tournament2: [GameDataModel] = [GameDataModel(id: TestConstants.empty, tournament: "Tournament2", opponent: TestConstants.empty)]
        sut.tournamentModels = [tournament1, tournament2]
        // When
        let indexPath1 = IndexPath(row: 0, section: -1)
        let indexPath2 = IndexPath(row: 0, section: 2)
        let tourney1Name = sut.getGameOpponent(at: indexPath1)
        let tourney2Name = sut.getGameOpponent(at: indexPath2)
        // Then
        XCTAssertEqual(TestConstants.empty, tourney1Name)
        XCTAssertEqual(TestConstants.empty, tourney2Name)
    }
    
    func testGetTournament_RowOutOfBounds() throws {
        // Given
        let tournament1: [GameDataModel] = [GameDataModel(id: TestConstants.empty, tournament: "Tournament1", opponent: TestConstants.empty)]
        let tournament2: [GameDataModel] = [GameDataModel(id: TestConstants.empty, tournament: "Tournament2", opponent: TestConstants.empty)]
        sut.tournamentModels = [tournament1, tournament2]
        // When
        let indexPath1 = IndexPath(row: -1, section: 0)
        let indexPath2 = IndexPath(row: 2, section: 1)
        let tourney1Name = sut.getGameOpponent(at: indexPath1)
        let tourney2Name = sut.getGameOpponent(at: indexPath2)
        // Then
        XCTAssertEqual(TestConstants.empty, tourney1Name)
        XCTAssertEqual(TestConstants.empty, tourney2Name)
    }
    
    func testGoToGamePage() throws {
        XCTAssertEqual(0, goToGamePageCalled)
        // Given
        let tournament: [GameDataModel] = [GameDataModel(id: TestConstants.empty, tournament: TestConstants.empty, opponent: TestConstants.empty)]
        sut.tournamentModels = [tournament]
        // When
        let indexPath = IndexPath(row: 0, section: 0)
        sut.goToGamePage(at: indexPath)
        // Then
        XCTAssertEqual(1, goToGamePageCalled)
    }
    
    func testGoToPlayerPage_RowOutOfBounds() throws {
        let alertVerifier = AlertVerifier()
        
        XCTAssertEqual(0, goToGamePageCalled)
        // Given
        let error = CustomError.outOfBounds
        let tournament: [GameDataModel] = [GameDataModel(id: TestConstants.empty, tournament: TestConstants.empty, opponent: TestConstants.empty)]
        sut.tournamentModels = [tournament]
        // When
        let indexPath = IndexPath(row: 1, section: 0)
        sut.goToGamePage(at: indexPath)
        // Then
        alertVerifier.verify(
            title: Constants.Errors.documentErrorTitle,
            message: error.localizedDescription,
            animated: true,
            actions: [
                .default(TestConstants.Alerts.dismiss)
            ],
            presentingViewController: vc
        )
    }
    
    func testGoToPlayerPage_SectionOutOfBounds() throws {
        let alertVerifier = AlertVerifier()
        
        XCTAssertEqual(0, goToGamePageCalled)
        // Given
        let error = CustomError.outOfBounds
        let tournament: [GameDataModel] = [GameDataModel(id: TestConstants.empty, tournament: TestConstants.empty, opponent: TestConstants.empty)]
        sut.tournamentModels = [tournament]
        // When
        let indexPath = IndexPath(row: 0, section: -1)
        sut.goToGamePage(at: indexPath)
        // Then
        alertVerifier.verify(
            title: Constants.Errors.documentErrorTitle,
            message: error.localizedDescription,
            animated: true,
            actions: [
                .default(TestConstants.Alerts.dismiss)
            ],
            presentingViewController: vc
        )
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
        XCTAssertNil(sut.tournamentModels)
        
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
        XCTAssertNotNil(sut.tournamentModels)
    }
    
    func testOnSuccessfulGet_GameDataModelSuccess() throws {
        // Given
        sut.tournamentModels = []
        let tourneyModel = GameDataModel(id: TestConstants.empty, tournament: TestConstants.empty, opponent: TestConstants.empty)
        let data = [
            FirebaseKeys.CollectionPath.games: [tourneyModel.dictionary]
        ]
        // When
        sut.onSuccessfulGet(data)
        // Then
        XCTAssertEqual(1, sut.tournamentModels[0].count)
        XCTAssertEqual(tourneyModel.tournament, sut.tournamentModels[0][0].tournament)
    }
    
    func testOnSuccessfulGet_GameDataModelFailure() throws {
        // Given
        sut.tournamentModels = [[]]
        let gameDictionary = ["": ""]
        let data = [
            FirebaseKeys.CollectionPath.games: [gameDictionary]
        ]
        // When
        sut.onSuccessfulGet(data)
        // Then
        XCTAssertEqual(0, sut.tournamentModels.count)
    }
}

//MARK: GamesPresenterDelegate
extension GamesPresenterTests: GamesPresenterDelegate {
    func goToGamePage(viewModel: GameViewModel) {
        goToGamePageCalled += 1
    }
}

//MARK: GamesViewController
class GamesViewControllerSpy: GamesViewController {
    var updateViewCalled: Int = 0
    
    override func updateView() {
        updateViewCalled += 1
    }
}
