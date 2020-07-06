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
    var vm: CallLineCellViewModel!
    var collectionView: CollectionViewSpy!
    
    override func setUp() {
        sut = CallLineViewController.instantiate(.pull)
        let _ = sut.view
        presenter = CallLinePresenterSpy()
        let player = Instance.getPlayerModel()
        vm = CallLineCellViewModel(playerArray: [[], [player], []], delegate: self)
        collectionView = CollectionViewSpy(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        sut.collectionView = collectionView
        sut.presenter = presenter
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        presenter = nil
        vm = nil
        collectionView = nil
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
        XCTAssertFalse(collectionView.reloadDataCalled)
        XCTAssertFalse(collectionView.dataSourceSet)
        // Given
        let vm = Instance.ViewModel.callLineEmpty(delegate: self)
        // When
        sut.updateWithViewModel(vm: vm)
        // Then
        XCTAssertTrue(collectionView.reloadDataCalled)
        XCTAssertTrue(collectionView.dataSourceSet)
    }
    
    func testStartPointPressed() throws {
        XCTAssertEqual(0, presenter.startPointCalled)
        // When
        sut.startPointPressed()
        // Then
        XCTAssertEqual(1, presenter.startPointCalled)
    }
    
    func testEndGamePressed() throws {
        XCTAssertEqual(0, presenter.endGameCalled)
        // When
        sut.endGamePressed()
        // Then
        XCTAssertEqual(1, presenter.endGameCalled)
    }
    
    func testDidSelectItemAt() throws {
        XCTAssertEqual(0, presenter.selectPlayerCalled)
        // Given
        let indexPath = IndexPath(row: 0, section: 1)
        // When
        sut.collectionView(collectionView, didSelectItemAt: indexPath)
        // Then
        XCTAssertTrue(collectionView.moveItemCalled)
        XCTAssertEqual(1, presenter.selectPlayerCalled)
    }
}

//MARK: CallLineCellViewModelDelegate
extension CallLineViewControllerTests: CallLineCellViewModelDelegate {
    func endGame(items: [[PlayerViewModel]]) { }
}

//MARK: CallLinePresenterSpy
class CallLinePresenterSpy: Presenter, CallLinePresenterProtocol {

    var viewWillAppearCalled: Int = 0
    var startPointCalled: Int = 0
    var selectPlayerCalled: Int = 0
    var endGameCalled: Int = 0
    
    func onViewWillAppear() {
        viewWillAppearCalled += 1
    }
    
    func startPoint() {
        startPointCalled += 1
    }
    
    func selectPlayer(at indexPath: IndexPath) -> IndexPath? {
        selectPlayerCalled += 1
        return indexPath
    }
    
    func endGame() {
        endGameCalled += 1
    }
}
