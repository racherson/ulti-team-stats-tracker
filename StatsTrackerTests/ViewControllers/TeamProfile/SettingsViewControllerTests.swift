//
//  SettingsViewControllerTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 5/13/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class SettingsViewControllerTests: XCTestCase {

    var sut: SettingsViewController!
    var presenter: SettingsPresenterSpy!
    
    override func setUp() {
        sut = SettingsViewController.instantiate(.team)
        let _ = sut.view
        presenter = SettingsPresenterSpy()
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
    
    func testConfigureTableViewCell() {
        // Given
        let tableView = sut.tableView
        // When
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView(tableView!, cellForRowAt: indexPath) as! SettingsTableViewCell
        // Then
        XCTAssertEqual(cell.cellLabel.text, Constants.Titles.logout)
    }
    
    func testLogoutPressed() {
        XCTAssertEqual(0, presenter.logoutPressedCount)
        // Given
        let tableView = sut.tableView
        // When
        let indexPath = IndexPath(row: 0, section: 0)
        sut.tableView(tableView!, didSelectRowAt: indexPath)
        // Then
        XCTAssertEqual(1, presenter.logoutPressedCount)
    }
    
    func testEditProfilePressed() {
        XCTAssertEqual(0, presenter.editPressedCount)
        // Given
        let tableView = sut.tableView
        // When
        let indexPath = IndexPath(row: 1, section: 0)
        sut.tableView(tableView!, didSelectRowAt: indexPath)
        // Then
        XCTAssertEqual(1, presenter.editPressedCount)
    }
}

//MARK: SettingsPresenterSpy
class SettingsPresenterSpy: Presenter, SettingsPresenterProtocol {
    
    var viewWillAppearCalled: Int = 0
    var editPressedCount: Int = 0
    var logoutPressedCount: Int = 0
    
    func onViewWillAppear() {
        viewWillAppearCalled += 1
    }
    
    func editPressed() {
        editPressedCount += 1
    }
    
    func logoutPressed() {
        logoutPressedCount += 1
    }
}
