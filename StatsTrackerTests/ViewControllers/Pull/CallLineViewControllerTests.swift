//
//  CallLineViewControllerTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 5/17/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class CallLineViewControllerTests: XCTestCase {
    
    var sut: CallLineViewController!
    var presenter: CallLinePresenterSpy!
    var vm: PlayerCollectionViewCellViewModel!
    
    var endGameCalled: Int = 0
    
    override func setUp() {
        sut = CallLineViewController.instantiate(.pull)
        let _ = sut.view
        presenter = CallLinePresenterSpy()
        let player = PlayerModel(name: TestConstants.playerName, gender: 0, id: TestConstants.empty, roles: [])
        vm = PlayerCollectionViewCellViewModel(playerArray: [[], [player], []], delegate: self)
        sut.viewModel = vm
        sut.presenter = presenter
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        presenter = nil
        vm = nil
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
        sut.viewModel = nil
        XCTAssertNil(sut.viewModel)
        // Given
        let vm = PlayerCollectionViewCellViewModel(playerArray: [[], [], []], delegate: self)
        // When
        sut.updateWithViewModel(vm: vm)
        // Then
        XCTAssertNotNil(sut.viewModel)
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
    
    func testShowCallLine() throws {
        // Given
        sut.collectionView.isHidden = true
        // When
        sut.showCallLine()
        // Then
        XCTAssertTrue(sut.playPointButton.isHidden)
        XCTAssertFalse(sut.collectionView.isHidden)
        XCTAssertEqual(Constants.Titles.callLineTitle, sut.navigationItem.title)
        XCTAssertNotNil(sut.navigationItem.rightBarButtonItem)
        XCTAssertNotNil(sut.navigationItem.leftBarButtonItem)
    }
    
    func testShowPlayPoint() throws {
        // Given
        sut.collectionView.isHidden = false
        // When
        sut.showPlayPoint()
        // Then
        XCTAssertFalse(sut.playPointButton.isHidden)
        XCTAssertTrue(sut.collectionView.isHidden)
        XCTAssertEqual(Constants.Titles.pointTitle, sut.navigationItem.title)
        XCTAssertNil(sut.navigationItem.rightBarButtonItem)
        XCTAssertNil(sut.navigationItem.leftBarButtonItem)
    }
    
    func testStartPointPressed() throws {
        XCTAssertEqual(0, presenter.startPointCalled)
        // When
        sut.startPointPressed()
        // Then
        XCTAssertEqual(1, presenter.startPointCalled)
    }
    
    func testEndGamePressed() throws {
        XCTAssertEqual(0, endGameCalled)
        // When
        sut.endGamePressed()
        // Then
        XCTAssertEqual(1, endGameCalled)
    }
    
    func testPlayPointPressed() throws {
        XCTAssertEqual(0, presenter.nextPointCalled)
        // When
        sut.playPointPressed(UIButton())
        // Then
        XCTAssertEqual(1, presenter.nextPointCalled)
    }
    
    func testDidSelectItemAt() throws {
        // Given
        let indexPath = IndexPath(row: 0, section: 1)
        let collectionView = CollectionViewSpy(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        // When
        sut.collectionView(collectionView, didSelectItemAt: indexPath)
        // Then
        XCTAssertTrue(collectionView.moveItemCalled)
    }
}

//MARK: PlayerCollectionViewCellViewModelDelegate
extension CallLineViewControllerTests: PlayerCollectionViewCellViewModelDelegate {
    func endGame(items: [[PlayerViewModel]]) {
        endGameCalled += 1
    }
}

//MARK: CallLinePresenterSpy
class CallLinePresenterSpy: Presenter, CallLinePresenterProtocol {
    
    var viewWillAppearCalled: Int = 0
    var startPointCalled: Int = 0
    var nextPointCalled: Int = 0
    
    func onViewWillAppear() {
        viewWillAppearCalled += 1
    }
    
    func startPoint() {
        startPointCalled += 1
    }
    
    func nextPoint(scored: Bool) {
        nextPointCalled += 1
    }
}
