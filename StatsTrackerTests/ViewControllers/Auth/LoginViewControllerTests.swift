//
//  LoginViewControllerTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 5/13/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class LoginViewControllerTests: XCTestCase {
    
    var sut: LoginViewController!
    var presenter: LoginPresenterSpy!
    
    override func setUp() {
        sut = LoginViewController.instantiate(.auth)
        let _ = sut.view
        presenter = LoginPresenterSpy()
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
        // When
        sut.showError(Constants.Errors.oob)
        // Then
        XCTAssertEqual(1, sut.errorLabel.alpha)
        XCTAssertEqual(Constants.Errors.oob, sut.errorLabel.text)
    }
    
    func testCancelPressed() throws {
        XCTAssertEqual(0, presenter.cancelCalled)
        // When
        sut.cancelPressed()
        // Then
        XCTAssertEqual(1, presenter.cancelCalled)
    }
    
    func testLoginPressed() throws {
        XCTAssertEqual(0, presenter.loginCalled)
        // When
        sut.loginPressed(UIButton())
        // Then
        XCTAssertEqual(1, presenter.loginCalled)
    }
}

//MARK: LoginPresenterSpy
class LoginPresenterSpy: Presenter, LoginPresenterProtocol {
    
    var viewWillAppearCalled: Int = 0
    var cancelCalled: Int = 0
    var viewWillDisappearCalled: Int = 0
    var loginCalled: Int = 0
    
    func onViewWillAppear() {
        viewWillAppearCalled += 1
    }
    
    func cancelPressed() {
        cancelCalled += 1
    }
    
    func loginPressed(email: String?, password: String?) {
        loginCalled += 1
    }
    
    func onViewWillDisappear() {
        viewWillDisappearCalled += 1
    }
}
