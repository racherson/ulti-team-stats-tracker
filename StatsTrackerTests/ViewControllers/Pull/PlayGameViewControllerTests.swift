//
//  PlayGameViewControllerTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 5/17/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class PlayGameViewControllerTests: XCTestCase {
    
    var sut: PlayGameViewController!
    var presenter: PlayGamePresenterSpy!
    
    override func setUp() {
        sut = PlayGameViewController.instantiate(.pull)
        let _ = sut.view
        presenter = PlayGamePresenterSpy()
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
        let collectionView = CollectionViewSpy(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        sut.collectionView = collectionView
        // When
        sut.updateView()
        // Then
        XCTAssertTrue(collectionView.reloadDataCalled)
    }
    
    func testStartPointPressed_fullLine() throws {
        XCTAssertEqual(0, presenter.startPointCalled)
        // Given
        presenter.playerCount = 7
        // When
        sut.startPointPressed()
        // Then
        XCTAssertEqual(1, presenter.startPointCalled)
    }
    
    func testStartPointPressed_notFullLine() throws {
        XCTAssertEqual(0, presenter.displayAlertCalled)
        // Given
        presenter.playerCount = 5
        // When
        sut.startPointPressed()
        // Then
        XCTAssertEqual(1, presenter.displayAlertCalled)
    }
    
    func testNumberOfRowsInSection() throws {
        XCTAssertEqual(0, presenter.numberOfPlayersCalled)
        // When
        let _ = sut.collectionView(UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init()), numberOfItemsInSection: 0)
        // Then
        XCTAssertEqual(1, presenter.numberOfPlayersCalled)
    }
    
    func testConfigureCollectionViewCell() {
        XCTAssertEqual(0, presenter.getPlayerNameCalled)
        // Given
        let collectionView = sut.collectionView
        // When
        let indexPath = IndexPath(row: 0, section: 1)
        let cell = sut.collectionView(collectionView!, cellForItemAt: indexPath)
            as! PlayerCollectionViewCell
        // Then
        XCTAssertEqual(.red, cell.backgroundColor)
        XCTAssertEqual(1, presenter.getPlayerNameCalled)
        XCTAssertEqual(TestConstants.playerName, cell.label.text)
    }
}

//MARK: PlayGamePresenterSpy
class PlayGamePresenterSpy: Presenter, PlayGamePresenterProtocol {
    
    var viewWillAppearCalled: Int = 0
    var fullLineCalled: Int = 0
    var displayAlertCalled: Int = 0
    var startPointCalled: Int = 0
    var playerCount: Int = 0
    var numberOfPlayersCalled: Int = 0
    var getPlayerNameCalled: Int = 0
    var selectPlayerCalled: Int = 0
    
    var playerModels = [[PlayerModel]]()
    
    func onViewWillAppear() {
        viewWillAppearCalled += 1
    }
    
    func fullLine() -> Bool {
        fullLineCalled += 1
        return playerCount < 7 ? false : true
    }
    
    func displayConfirmAlert() {
        displayAlertCalled += 1
    }
    
    func startPoint() {
        startPointCalled += 1
    }
    
    func numberOfPlayersInSection(_ section: Int) -> Int {
        numberOfPlayersCalled += 1
        return 1
    }
    
    func getPlayerName(at indexPath: IndexPath) -> String {
        getPlayerNameCalled += 1
        return TestConstants.playerName
    }
    
    func selectPlayer(at indexPath: IndexPath) -> IndexPath {
        selectPlayerCalled += 1
        return indexPath
    }
}
