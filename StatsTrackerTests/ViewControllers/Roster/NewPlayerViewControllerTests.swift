//
//  NewPlayerViewControllerTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 5/13/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class NewPlayerViewControllerTests: XCTestCase {
    
    var sut: NewPlayerViewController!
    var presenter: NewPlayerPresenterSpy!
    
    override func setUp() {
        sut = NewPlayerViewController.instantiate(.roster)
        let _ = sut.view
        presenter = NewPlayerPresenterSpy()
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
    
    func testTextFieldIsNotEmpty_Empty() throws {
        // Given
        let emptyTextField = UITextField()
        // When
        sut.textFieldIsNotEmpty(sender: emptyTextField)
        // Then
        XCTAssertFalse(sut.saveButton!.isEnabled)
    }
    
    func testTextFieldIsNotEmpty_NotEmpty() throws {
        // Given
        let textField = UITextField()
        textField.text = "Test"
        // When
        sut.textFieldIsNotEmpty(sender: textField)
        // Then
        XCTAssertTrue(sut.saveButton!.isEnabled, sut.saveButton!.isEnabled.description)
    }
    
    func testCancelPressed() throws {
        XCTAssertEqual(0, presenter.cancelPressedCount)
        // When
        sut.cancelPressed()
        // Then
        XCTAssertEqual(1, presenter.cancelPressedCount)
    }
    
    func testSavePressed() throws {
        XCTAssertEqual(0, presenter.savePressedCount)
        // Given
        sut.nameTextField.text = TestConstants.playerName
        // When
        sut.savePressed()
        // Then
        XCTAssertEqual(1, presenter.savePressedCount)
    }
    
    func testTextFieldShouldReturn() throws {
        // Given
        let textField = UITextField()
        // When
        let result = sut.textFieldShouldReturn(textField)
        // Then
        XCTAssertFalse(textField.isFirstResponder)
        XCTAssertTrue(result)
    }
}

//MARK: NewPlayerPresenterSpy
class NewPlayerPresenterSpy: Presenter, NewPlayerPresenterProtocol {
    
    var viewWillAppearCalled: Int = 0
    var cancelPressedCount: Int = 0
    var savePressedCount: Int = 0
    
    func onViewWillAppear() {
        viewWillAppearCalled += 1
    }
    
    func cancelPressed() {
        cancelPressedCount += 1
    }
    
    func savePressed(model: PlayerModel) {
        savePressedCount += 1
    }
}
