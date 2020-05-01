//
//  EditProfilePresenterTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 4/29/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
import ViewControllerPresentationSpy
@testable import StatsTracker

class EditProfilePresenterTests: XCTestCase {

    var sut: EditProfilePresenter!
    var vc: EditProfileViewController!
    var authManager: MockSignedInAuthManager!
    
    var cancelPressedCount: Int = 0
    var savePressedCount: Int = 0
    var backToProfileCount: Int = 0
    
    override func setUp() {
        vc = EditProfileViewController.instantiate(.team)
        let _ = vc.view
        authManager = MockSignedInAuthManager()
        sut = EditProfilePresenter(vc: vc, delegate: self, authManager: authManager)
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        vc = nil
        authManager = nil
        super.tearDown()
    }
    
    func testOnViewWillAppear() throws {
        sut.viewModel = TeamProfileViewModel(team: TestConstants.teamName, image: TestConstants.teamImage)
        sut.onViewWillAppear()
        XCTAssertEqual(vc.teamNameTextField.text, TestConstants.teamName)
        XCTAssertEqual(vc.teamPhotoImage.image, TestConstants.teamImage)
    }
    
    func testCancelPressed() throws {
        XCTAssertEqual(0, cancelPressedCount)
        sut.cancelPressed()
        XCTAssertEqual(1, cancelPressedCount)
    }

    func testSavePressed() throws {
        //TODO
    }
}

//MARK: EditProfilePresenterDelegate Mock
extension EditProfilePresenterTests: EditProfilePresenterDelegate {
    func backToProfile() {
        self.backToProfileCount += 1
    }
    
    func cancelPressed() {
        self.cancelPressedCount += 1
    }
    
    func savePressed(newName: String, newImage: UIImage) {
        self.savePressedCount += 1
    }
}
