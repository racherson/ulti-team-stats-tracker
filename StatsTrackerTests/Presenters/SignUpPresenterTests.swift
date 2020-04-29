//
//  SignUpPresenterTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 4/28/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class SignUpPresenterTests: XCTestCase {
    
    var sut: SignUpPresenter!
    var vc: SignUpViewController!
    var navigationController: MockNavigationController!
    var authManager: MockSignedInAuthManager!
    
    override func setUp() {
        navigationController = MockNavigationController()
        vc = SignUpViewController()
        sut = SignUpPresenter(vc: vc, delegate: self)
        sut.authManager = MockSignedInAuthManager()
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        navigationController = nil
        vc = nil
        super.tearDown()
    }
}

extension SignUpPresenterTests: SignUpAndLoginPresenterDelegate {
    func cancelPressed() { }
    
    func transitionToTabs() { }
}
