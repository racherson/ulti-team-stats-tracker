//
//  RosterPresenterTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 5/10/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
import ViewControllerPresentationSpy
@testable import StatsTracker

class RosterPresenterTests: XCTestCase {

    var sut: RosterPresenter!
    var vc: RosterViewControllerSpy!
    var dbManager: MockDBManager!
    
    var addPressedCount: Int = 0
    var playerPageCount: Int = 0
    var vmName: String?
    var vmGender: Gender?
    
    override func setUp() {
        vc = RosterViewControllerSpy()
        dbManager = MockDBManager()
        sut = RosterPresenter(vc: vc, delegate: self, dbManager: dbManager)
        vc.presenter = sut
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        vc = nil
        dbManager = nil
        super.tearDown()
    }
    
    func testSetGenderArrays() throws {
        // Given sut init, then
        XCTAssertEqual(1, dbManager.getDataCalled)
    }
    
    func testOnViewWillAppear() throws {
        XCTAssertEqual(vc.navigationItem.title, nil)
        // When
        sut.onViewWillAppear()
        // Then
        XCTAssertEqual(vc.navigationItem.title, Constants.Titles.rosterTitle)
    }
    
    func testNumberOfPlayersInSection_EmptySection() throws {
        // Given
        let array1: [PlayerModel] = []
        let array2: [PlayerModel] = []
        // When
        sut.playerModels = [array1, array2]
        // Then
        XCTAssertEqual(array1.count, sut.numberOfPlayersInSection(Gender.women.rawValue))
        XCTAssertEqual(array2.count, sut.numberOfPlayersInSection(Gender.men.rawValue))
    }
    
    func testNumberOfPlayersInSection_NonEmptySection() throws {
        // Given
        let women: [PlayerModel] = [PlayerModel(name: "Woman1", gender: Gender.women.rawValue, id: TestConstants.empty),
                                     PlayerModel(name: "Woman2", gender: Gender.women.rawValue, id: TestConstants.empty)]
        let men: [PlayerModel] = [PlayerModel(name: "Man", gender: Gender.men.rawValue, id: TestConstants.empty)]
        // When
        sut.playerModels = [women, men]
        // Then
        XCTAssertEqual(women.count, sut.numberOfPlayersInSection(Gender.women.rawValue))
        XCTAssertEqual(men.count, sut.numberOfPlayersInSection(Gender.men.rawValue))
    }
    
    func testGetPlayerName() throws {
        // Given
        let women: [PlayerModel] = [PlayerModel(name: "Woman1", gender: Gender.women.rawValue, id: TestConstants.empty)]
        let men: [PlayerModel] = [PlayerModel(name: "Man1", gender: Gender.men.rawValue, id: TestConstants.empty)]
        sut.playerModels = [women, men]
        // When
        let indexPathWoman = IndexPath(row: 0, section: Gender.women.rawValue)
        let indexPathMan = IndexPath(row: 0, section: Gender.men.rawValue)
        // Then
        XCTAssertEqual("Woman1", sut.getPlayerName(at: indexPathWoman))
        XCTAssertEqual("Man1", sut.getPlayerName(at: indexPathMan))
    }
    
    func testAddPressed() throws {
        XCTAssertEqual(0, addPressedCount)
        // When
        sut.addPressed()
        // Then
        XCTAssertEqual(1, addPressedCount)
    }
    
    func testAddPlayerWoman() throws {
        // Given
        sut.playerModels = [[],[]]
        let player = PlayerModel(name: "Woman", gender: Gender.women.rawValue, id: TestConstants.empty)
        XCTAssertEqual(0, sut.playerModels[player.gender].count)
        XCTAssertEqual(0, vc.updateViewCalled)
        // When
        sut.addPlayer(player)
        // Then
        XCTAssertEqual(1, sut.playerModels[player.gender].count)
        XCTAssertEqual(1, vc.updateViewCalled)
    }
    
    func testAddPlayerMan() throws {
        // Given
        sut.playerModels = [[],[]]
        let player = PlayerModel(name: "Man", gender: Gender.men.rawValue, id: TestConstants.empty)
        XCTAssertEqual(0, sut.playerModels[player.gender].count)
        XCTAssertEqual(0, vc.updateViewCalled)
        // When
        sut.addPlayer(player)
        // Then
        XCTAssertEqual(1, sut.playerModels[player.gender].count)
        XCTAssertEqual(1, vc.updateViewCalled)
    }
    
    func testGoToPlayerPage() throws {
        XCTAssertEqual(0, playerPageCount)
        XCTAssertNil(vmName)
        XCTAssertNil(vmGender)
        // Given
        let name = "Woman"
        let women: [PlayerModel] = [PlayerModel(name: name, gender: Gender.women.rawValue, id: TestConstants.empty)]
        sut.playerModels = [women, []]
        // When
        let indexPath = IndexPath(row: 0, section: 0)
        sut.goToPlayerPage(at: indexPath)
        // Then
        XCTAssertEqual(1, playerPageCount)
        XCTAssertEqual(name, vmName)
        XCTAssertEqual(Gender.women, vmGender)
    }
    
    func testDeletePlayerWoman() throws {
        // Given
        let player = PlayerModel(name: "Woman", gender: Gender.women.rawValue, id: TestConstants.empty)
        sut.playerModels = [[player],[]]
        XCTAssertEqual(1, sut.playerModels[player.gender].count)
        XCTAssertEqual(0, vc.updateViewCalled)
        // When
        let indexPath = IndexPath(row: 0, section: player.gender)
        sut.deletePlayer(at: indexPath)
        // Then
        XCTAssertEqual(0, sut.playerModels[player.gender].count)
        XCTAssertEqual(1, vc.updateViewCalled)
    }
    
    func testDeletePlayerMan() throws {
        XCTAssertEqual(0, vc.updateViewCalled)
        // Given
        let player = PlayerModel(name: "Man", gender: Gender.men.rawValue, id: TestConstants.empty)
        sut.playerModels = [[],[player]]
        XCTAssertEqual(1, sut.playerModels[player.gender].count)
        XCTAssertEqual(0, vc.updateViewCalled)
        // When
        let indexPath = IndexPath(row: 0, section: player.gender)
        sut.deletePlayer(at: indexPath)
        // Then
        XCTAssertEqual(0, sut.playerModels[player.gender].count)
        XCTAssertEqual(1, vc.updateViewCalled)
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
        XCTAssertNil(sut.playerModels)
        
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
        XCTAssertNotNil(sut.playerModels)
    }
    
    func testOnSuccessfulGet_PlayerModelSuccess() throws {
        // Given
        sut.playerModels = [[],[]]
        let womanModel = PlayerModel(name: "Woman", gender: Gender.women.rawValue, id: TestConstants.empty)
        let manModel = PlayerModel(name: "Man", gender: Gender.men.rawValue, id: TestConstants.empty)
        let data = [
            FirebaseKeys.CollectionPath.women: [womanModel.dictionary],
            FirebaseKeys.CollectionPath.men: [manModel.dictionary]
        ]
        // When
        sut.onSuccessfulGet(data)
        // Then
        XCTAssertEqual(1, sut.playerModels[Gender.women.rawValue].count)
        XCTAssertEqual(1, sut.playerModels[Gender.men.rawValue].count)
        XCTAssertEqual(womanModel.name, sut.playerModels[Gender.women.rawValue][0].name)
        XCTAssertEqual(manModel.name, sut.playerModels[Gender.men.rawValue][0].name)
    }
    
    func testOnSuccessfulGet_PlayerModelFailure() throws {
        // Given
        sut.playerModels = [[],[]]
        let playerDictionary = ["": ""]
        let data = [
            FirebaseKeys.CollectionPath.women: [playerDictionary],
            FirebaseKeys.CollectionPath.men: [playerDictionary]
        ]
        // When
        sut.onSuccessfulGet(data)
        // Then
        XCTAssertEqual(0, sut.playerModels[Gender.women.rawValue].count)
        XCTAssertEqual(0, sut.playerModels[Gender.men.rawValue].count)
    }
}

//MARK: RosterPresenterDelegate
extension RosterPresenterTests: RosterPresenterDelegate {
    func addPressed() {
        addPressedCount += 1
    }
    
    func goToPlayerPage(viewModel: PlayerViewModel) {
        playerPageCount += 1
        vmName = viewModel.name
        vmGender = viewModel.gender
    }
}

//MARK: RosterViewControllerSpy
class RosterViewControllerSpy: RosterViewController {
    var updateViewCalled: Int = 0
    
    override func updateView() {
        updateViewCalled += 1
    }
}
