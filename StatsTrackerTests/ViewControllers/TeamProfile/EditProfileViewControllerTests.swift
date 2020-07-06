//
//  EditProfileViewControllerTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 5/13/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
import ViewControllerPresentationSpy
@testable import StatsTracker

class EditProfileViewControllerTests: XCTestCase {
    
    var sut: EditProfileViewController!
    var presenter: EditProfilePresenterSpy!
    
    override func setUp() {
        sut = EditProfileViewController.instantiate(.team)
        let _ = sut.view
        presenter = EditProfilePresenterSpy()
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
    
    func testUpdateWithViewModel() throws {
        XCTAssertNil(sut.currentEmail)
        // Given
        let viewModel = Instance.ViewModel.teamProfile()
        // When
        sut.updateWithViewModel(vm: viewModel)
        // Then
        XCTAssertEqual(viewModel.email, sut.currentEmail)
        XCTAssertEqual(viewModel.teamName, sut.teamNameTextField.text)
        XCTAssertEqual(viewModel.teamImage, sut.teamPhotoImage.image)
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
        // When
        sut.savePressed()
        // Then
        XCTAssertEqual(1, presenter.savePressedCount)
        XCTAssertTrue(sut.activityIndicator.isAnimating)
        XCTAssertEqual(1, sut.visualEffectView.alpha)
    }
    
    func testSelectImageFromPhotoLibrary() throws {
        let presentationVerifier = PresentationVerifier()
        
        // When
        sut.selectImageFromPhotoLibrary(UITapGestureRecognizer())
        let nextVC: UIImagePickerController? = presentationVerifier.verify(animated: true,
                                                                           presentingViewController: sut)
        // Then
        XCTAssertEqual(nextVC!.sourceType, .photoLibrary)
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

//MARK: EditProfilePresenterSpy
class EditProfilePresenterSpy: Presenter, EditProfilePresenterProtocol {
    
    var viewWillAppearCalled: Int = 0
    var cancelPressedCount: Int = 0
    var savePressedCount: Int = 0
    
    func onViewWillAppear() {
        viewWillAppearCalled += 1
    }
    
    func cancelPressed() {
        cancelPressedCount += 1
    }
    
    func savePressed(vm: TeamProfileViewModel) {
        savePressedCount += 1
    }
}
