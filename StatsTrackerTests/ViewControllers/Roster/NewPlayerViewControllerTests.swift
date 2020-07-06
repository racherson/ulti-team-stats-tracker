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
        textField.text = TestConstants.test
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
    
    func testSavePressed_ModelCreated() throws {
        XCTAssertNil(presenter.modelCreated)
        // Given
        sut.nameTextField.text = TestConstants.playerName
        sut.genderSegmentedControl.selectedSegmentIndex = Gender.women.rawValue
        let viewModel = RolesCellViewModel()
        viewModel.items[0].isSelected = true
        sut.viewModel = viewModel
        // When
        sut.savePressed()
        // Then
        XCTAssertEqual(TestConstants.playerName, presenter.modelCreated?.name)
        XCTAssertEqual(Gender.women.rawValue, presenter.modelCreated?.gender)
        XCTAssertEqual([Roles.handler.rawValue], presenter.modelCreated?.roles)
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
    
    func testDidSelectRowAt() throws {
        // Given
        let viewModel = RolesCellViewModel()
        let indexPath = IndexPath(row: 0, section: 0)
        XCTAssertFalse(viewModel.items[indexPath.row].isSelected)
        sut.viewModel = viewModel
        // When
        sut.tableView(sut.tableView, didSelectRowAt: indexPath)
        // Then
        XCTAssertTrue(viewModel.items[indexPath.row].isSelected)
    }
    
    func testDidDeSelectRowAt() throws {
        // Given
        let viewModel = RolesCellViewModel()
        viewModel.items[0].isSelected = true
        let indexPath = IndexPath(row: 0, section: 0)
        XCTAssertTrue(viewModel.items[indexPath.row].isSelected)
        sut.viewModel = viewModel
        // When
        sut.tableView(sut.tableView, didDeselectRowAt: indexPath)
        // Then
        XCTAssertFalse(viewModel.items[indexPath.row].isSelected)
    }
}

//MARK: NewPlayerPresenterSpy
class NewPlayerPresenterSpy: Presenter, NewPlayerPresenterProtocol {
    
    var viewWillAppearCalled: Int = 0
    var cancelPressedCount: Int = 0
    var savePressedCount: Int = 0
    var modelCreated: PlayerModel?
    
    func onViewWillAppear() {
        viewWillAppearCalled += 1
    }
    
    func cancelPressed() {
        cancelPressedCount += 1
    }
    
    func savePressed(model: PlayerModel) {
        savePressedCount += 1
        modelCreated = model
    }
}
