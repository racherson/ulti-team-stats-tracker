//
//  PlayGamePresenterTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 5/17/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
import ViewControllerPresentationSpy
@testable import StatsTracker

class PlayGamePresenterTests: XCTestCase {
    
    var sut: PlayGamePresenter!
    var vc: PlayGameViewControllerSpy!
    var dbManager: MockDBManager!
    let selectedSection = 0
    let womenSection = Gender.women.rawValue + 1
    let menSection = Gender.men.rawValue + 1
    
    override func setUp() {
        vc = PlayGameViewControllerSpy()
        dbManager = MockDBManager()
        sut = PlayGamePresenter(vc: vc, delegate: self, dbManager: dbManager)
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
        XCTAssertEqual(vc.navigationItem.title, Constants.Titles.pointTitle)
    }
    
    func testFetchRoster() throws {
        // Given sut init, then
        XCTAssertEqual(1, dbManager.getDataCalled)
    }
    
    func testFullLine_True() throws {
        // Given
        sut.playerModels = [[], [], []]
        for _ in 1...7 {
            sut.playerModels![selectedSection].append(PlayerModel(name: "", gender: 0, id: "", roles: []))
        }
        // When
        let result = sut.fullLine()
        // Then
        XCTAssertTrue(result)
    }
    
    func testFullLine_False() throws {
        // Given
        sut.playerModels = [[], [], []]
        for _ in 1...2 {
            sut.playerModels![selectedSection].append(PlayerModel(name: "", gender: 0, id: "", roles: []))
        }
        // When
        let result = sut.fullLine()
        // Then
        XCTAssertFalse(result)
    }
    
    func testDisplayConfirmAlert() throws {
        let alertVerifier = AlertVerifier()
        
        // When
        sut.displayConfirmAlert()
        // Then
        alertVerifier.verify(
            title: Constants.Alerts.startGameTitle,
            message: Constants.Alerts.startGameAlert,
            animated: true,
            actions: [
                .destructive(TestConstants.Alerts.cancel),
                .default(TestConstants.Alerts.confirm),
            ],
            presentingViewController: vc
        )
    }
    
    func testExecutingActionForConfirmButton_shouldStartPoint() throws {
        let alertVerifier = AlertVerifier()
        
        // Given
        sut.displayConfirmAlert()
        // When
        try alertVerifier.executeAction(forButton: TestConstants.Alerts.confirm)
        // Then
    }
    
    func testStartPoint() throws {
        //
    }
    
    func testNumberOfPlayersInSection_EmptyModels() throws {
        // When
        sut.playerModels = nil
        // Then
        XCTAssertEqual(Constants.Empty.int, sut.numberOfPlayersInSection(womenSection))
        XCTAssertEqual(Constants.Empty.int, sut.numberOfPlayersInSection(menSection))
    }
    
    func testNumberOfPlayersInSection_NonEmptySection() throws {
        // Given
        let women: [PlayerModel] = [PlayerModel(name: "Woman1", gender: Gender.women.rawValue, id: TestConstants.empty, roles: []),
                                    PlayerModel(name: "Woman2", gender: Gender.women.rawValue, id: TestConstants.empty, roles: [])]
        let men: [PlayerModel] = [PlayerModel(name: "Man", gender: Gender.men.rawValue, id: TestConstants.empty, roles: [])]
        // When
        sut.playerModels = [[], women, men]
        // Then
        XCTAssertEqual(0, sut.numberOfPlayersInSection(selectedSection))
        XCTAssertEqual(women.count, sut.numberOfPlayersInSection(womenSection))
        XCTAssertEqual(men.count, sut.numberOfPlayersInSection(menSection))
    }
    
    func testNumberOfPlayersInSection_OutOfBounds() throws {
        // Given
        let array1: [PlayerModel] = []
        let array2: [PlayerModel] = []
        let sectionGreaterThan = 2
        let sectionLessThan = -1
        // When
        sut.playerModels = [[], array1, array2]
        // Then
        XCTAssertEqual(Constants.Empty.int, sut.numberOfPlayersInSection(sectionGreaterThan))
        XCTAssertEqual(Constants.Empty.int, sut.numberOfPlayersInSection(sectionGreaterThan))
        XCTAssertEqual(Constants.Empty.int, sut.numberOfPlayersInSection(sectionLessThan))
        XCTAssertEqual(Constants.Empty.int, sut.numberOfPlayersInSection(sectionLessThan))
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
        XCTAssertEqual(0, vc.updateViewCalled)
        // Given
        sut.playerModels = [[], [], []]
        let womanModel = PlayerModel(name: "Woman", gender: Gender.women.rawValue, id: TestConstants.empty, roles: [])
        let manModel = PlayerModel(name: "Man", gender: Gender.men.rawValue, id: TestConstants.empty, roles: [])
        let data = [
            FirebaseKeys.CollectionPath.women: [womanModel.dictionary],
            FirebaseKeys.CollectionPath.men: [manModel.dictionary]
        ]
        // When
        sut.onSuccessfulGet(data)
        // Then
        XCTAssertEqual(0, sut.playerModels![selectedSection].count)
        XCTAssertEqual(1, sut.playerModels![womenSection].count)
        XCTAssertEqual(1, sut.playerModels![menSection].count)
        XCTAssertEqual(womanModel.name, sut.playerModels![womenSection][0].name)
        XCTAssertEqual(manModel.name, sut.playerModels![menSection][0].name)
        XCTAssertEqual(1, vc.updateViewCalled)
    }
    
    func testOnSuccessfulGet_PlayerModelFailure() throws {
        XCTAssertEqual(0, vc.updateViewCalled)
        // Given
        sut.playerModels = [[], [],[]]
        let playerDictionary = ["": ""]
        let data = [
            FirebaseKeys.CollectionPath.women: [playerDictionary],
            FirebaseKeys.CollectionPath.men: [playerDictionary]
        ]
        // When
        sut.onSuccessfulGet(data)
        // Then
        XCTAssertEqual(0, sut.playerModels![selectedSection].count)
        XCTAssertEqual(0, sut.playerModels![womenSection].count)
        XCTAssertEqual(0, sut.playerModels![menSection].count)
        XCTAssertEqual(1, vc.updateViewCalled)
    }
    
    func testCollectionViewDisplaysAllRosterPlayers() throws {
        // Given
        sut.playerModels = [[],
                            [PlayerModel(name: TestConstants.playerName, gender: 0, id: "", roles: [])],
                            [PlayerModel(name: TestConstants.playerName, gender: 1, id: "", roles: [])]]
        // Create real instance of the view controller
        sut.vc = PlayGameViewController.instantiate(.pull)
        let _ = sut.vc.view
        sut.vc.presenter = sut
        // When
        sut.vc.updateView()
        // Then
        XCTAssertEqual(sut.playerModels![selectedSection].count, sut.vc.collectionView(sut.vc.collectionView, numberOfItemsInSection: selectedSection))
        XCTAssertEqual(sut.playerModels![womenSection].count, sut.vc.collectionView(sut.vc.collectionView, numberOfItemsInSection: womenSection))
        XCTAssertEqual(sut.playerModels![menSection].count, sut.vc.collectionView(sut.vc.collectionView, numberOfItemsInSection: menSection))
    }
}

//MARK: PlayGamePresenterDelegate
extension PlayGamePresenterTests: PlayGamePresenterDelegate { }

//MARK: RosterViewControllerSpy
class PlayGameViewControllerSpy: PlayGameViewController {
    var updateViewCalled: Int = 0
    
    override func updateView() {
        updateViewCalled += 1
    }
}
