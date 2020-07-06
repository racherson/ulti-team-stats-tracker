//
//  CallLineCellViewModelTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 6/20/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
import ViewControllerPresentationSpy
@testable import StatsTracker

class CallLineCellViewModelTests: XCTestCase {
    
    var sut: CallLineCellViewModel!
    
    private let selectedSection = 0
    private let womenSection = Gender.women.rawValue + 1
    private let menSection = Gender.men.rawValue + 1
    
    private var endGameCalled: Int = 0
    
    override func setUp() {
        let playerArray = [[], [Instance.getPlayerModel()], []]
        sut = CallLineCellViewModel(playerArray: playerArray, delegate: self)
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testInit() throws {
        XCTAssertEqual(3, sut.items.count)
        XCTAssertEqual(0, sut.items[0].count)
        XCTAssertEqual(1, sut.items[1].count)
        XCTAssertEqual(0, sut.items[2].count)
    }
    
    func testSelectPlayer_Selecting() throws {
        // Given
        sut.items = [[], [Instance.ViewModel.player()], []]
        let indexPath = IndexPath(row: 0, section: womenSection)
        // When
        let newIndexPath = sut.selectPlayer(at: indexPath)
        // Then
        XCTAssertEqual(newIndexPath, IndexPath(row: 0, section: selectedSection))
    }
    
    func testSelectPlayer_Deselecting() throws {
        // Given
        sut.items = [[Instance.ViewModel.player()], [], []]
        let indexPath = IndexPath(row: 0, section: selectedSection)
        // When
        let newIndexPath = sut.selectPlayer(at: indexPath)
        // Then
        XCTAssertEqual(newIndexPath, IndexPath(row: 0, section: womenSection))
    }
    
    func testSelectPlayer_FullLine() throws {
        // Given
        sut.items = [[], [Instance.ViewModel.player()], []]
        for _ in 1...7 {
            sut.items[selectedSection].append(Instance.ViewModel.player())
        }
        let indexPath = IndexPath(row: 0, section: womenSection)
        // When
        let newIndexPath = sut.selectPlayer(at: indexPath)
        // Then
        XCTAssertNil(newIndexPath)
    }
    
    func testEndGame() throws {
        XCTAssertEqual(0, endGameCalled)
        // When
        sut.endGame()
        // Then
        XCTAssertEqual(1, endGameCalled)
    }
    
    func testFullLine_full() throws {
        // Given
        for _ in 1...7 {
            sut.items[selectedSection].append(Instance.ViewModel.player())
        }
        // When
        let result = sut.fullLine()
        // Then
        XCTAssertTrue(result)
    }
    
    func testFullLine_notFull() throws {
        // Given
        for _ in 1...2 {
            sut.items[selectedSection].append(Instance.ViewModel.player())
        }
        // When
        let result = sut.fullLine()
        // Then
        XCTAssertFalse(result)
    }
    
    func testClearLine() throws {
        // Given
        let womanModel = Instance.getPlayerModel(.women)
        let manModel = Instance.getPlayerModel(.men)
        sut.items = [[PlayerViewModel(model: womanModel), PlayerViewModel(model: manModel)], [], []]
        // When
        sut.clearLine()
        // Then
        XCTAssertEqual(0, sut.items[0].count)
        XCTAssertEqual(1, sut.items[1].count)
        XCTAssertEqual(1, sut.items[2].count)
    }
    
    func testAddPointsToPlayers() throws {
        // Given
        let womanVM = PlayerViewModel(model: Instance.getPlayerModel(.women))
        let manVM = PlayerViewModel(model: Instance.getPlayerModel(.men))
        sut.items = [[womanVM, manVM], [], []]
        // When
        sut.addPointsToPlayers()
        // Then
        XCTAssertTrue(womanVM.enteredGame)
        XCTAssertTrue(manVM.enteredGame)
        XCTAssertEqual(1, womanVM.model.points)
        XCTAssertEqual(1, manVM.model.points)
        XCTAssertEqual(1, womanVM.model.games)
        XCTAssertEqual(1, manVM.model.games)
    }
    
    func testNumberOfPlayersInSection_NonEmptySection() throws {
        XCTAssertEqual(0, sut.collectionView(UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init()), numberOfItemsInSection: selectedSection))
        XCTAssertEqual(1, sut.collectionView(UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init()), numberOfItemsInSection: womenSection))
        XCTAssertEqual(0, sut.collectionView(UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init()), numberOfItemsInSection: menSection))
    }
    
    func testNumberOfPlayersInSection_OutOfBounds() throws {
        // Given
        let sectionGreaterThan = 2
        let sectionLessThan = -1
        // Then
        XCTAssertEqual(Constants.Empty.int, sut.collectionView(UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init()), numberOfItemsInSection: sectionGreaterThan))
        XCTAssertEqual(Constants.Empty.int, sut.collectionView(UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init()), numberOfItemsInSection: sectionLessThan))
    }
    
    func testConfigureCollectionViewCell() {
        // Given
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.register(CallLineCollectionViewCell.self, forCellWithReuseIdentifier: "CallLineCollectionViewCell")
        // When
        let indexPath = IndexPath(row: 0, section: 1)
        let cell = sut.collectionView(collectionView, cellForItemAt: indexPath) as! CallLineCollectionViewCell
        // Then
        XCTAssertEqual(.red, cell.backgroundColor)
    }
}

//MARK: CallLineCellViewModelDelegate
extension CallLineCellViewModelTests: CallLineCellViewModelDelegate {
    func endGame(items: [[PlayerViewModel]]) {
        endGameCalled += 1
    }
}
