//
//  SignUpViewControllerTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 5/13/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class SignUpViewControllerTests: XCTestCase {

    var sut: SignUpViewController!
    var presenter: SignUpPresenterSpy!
    
    override func setUp() {
        sut = SignUpViewController.instantiate(.auth)
        let _ = sut.view
        presenter = SignUpPresenterSpy()
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
    
    func testViewWillDisappear() throws {
        XCTAssertEqual(0, presenter.viewWillDisappearCalled)
        // When
        sut.viewWillDisappear(false)
        // Then
        XCTAssertEqual(1, presenter.viewWillDisappearCalled)
    }
    
    func testShowError() throws {
        XCTAssertEqual(0, sut.errorLabel.alpha)
        // Given
        let message = "Error"
        // When
        sut.showError(message)
        // Then
        XCTAssertEqual(1, sut.errorLabel.alpha)
        XCTAssertEqual(message, sut.errorLabel.text)
    }
    
    func testCancelPressed() throws {
        XCTAssertEqual(0, presenter.cancelCalled)
        // When
        sut.cancelPressed()
        // Then
        XCTAssertEqual(1, presenter.cancelCalled)
    }
    
    func testSignUpPressed() throws {
        XCTAssertEqual(0, presenter.signUpCalled)
        // When
        sut.signUpPressed(UIButton())
        // Then
        XCTAssertEqual(1, presenter.signUpCalled)
    }
}

//MARK: SignUpPresenterSpy
class SignUpPresenterSpy: Presenter, SignUpPresenterProtocol {
    
    var viewWillAppearCalled: Int = 0
    var cancelCalled: Int = 0
    var viewWillDisappearCalled: Int = 0
    var signUpCalled: Int = 0
    
    func onViewWillAppear() {
        viewWillAppearCalled += 1
    }
    
    func cancelPressed() {
        cancelCalled += 1
    }
    
    func signUpPressed(name: String?, email: String?, password: String?) {
        signUpCalled += 1
    }
    
    func onViewWillDisappear() {
        viewWillDisappearCalled += 1
    }
}
