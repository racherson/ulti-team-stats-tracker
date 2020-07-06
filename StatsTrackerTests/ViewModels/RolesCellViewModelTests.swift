//
//  RolesCellViewModelTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 5/19/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class RolesCellViewModelTests: XCTestCase {
    
    var sut: RolesCellViewModel!
    
    override func setUp() {
        sut = RolesCellViewModel()
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testHeaderForSection_Zero() throws {
        // Given
        let section = 0
        // When
        let result = sut.tableView(UITableView(), titleForHeaderInSection: section)
        // Then
        XCTAssertEqual(result, Constants.Titles.roles)
    }
    
    func testHeaderForSection_Nonzero() throws {
        // Given
        let section = 1
        // When
        let result = sut.tableView(UITableView(), titleForHeaderInSection: section)
        // Then
        XCTAssertNil(result)
    }
    
    func testNumberOfRowsInSection() throws {
        // Given
        let role = Roles(rawValue: 0)
        let item = RolesCellViewModelItem(item: role!)
        sut.items = [item]
        // When
        let section = 0
        let result = sut.tableView(UITableView(), numberOfRowsInSection: section)
        // Then
        XCTAssertEqual(1, result)
    }
    
    func testConfigureTableViewCell_Selected() throws {
        // Given
        let tableView = TableViewSpy()
        tableView.register(RolesTableViewCell.self, forCellReuseIdentifier: "RolesTableViewCell")
        XCTAssertFalse(tableView.selectRowCalled)
        let item = RolesCellViewModelItem(item: Roles(rawValue: 0)!)
        item.isSelected = true
        sut.items = [item]
        // When
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView(tableView, cellForRowAt: indexPath) as! RolesTableViewCell
        // Then
        XCTAssertEqual(item.item, cell.item?.item)
        XCTAssertTrue(tableView.selectRowCalled)
    }
    
    func testConfigureTableViewCell_UnSelected() throws {
        // Given
        let tableView = TableViewSpy()
        tableView.register(RolesTableViewCell.self, forCellReuseIdentifier: "RolesTableViewCell")
        XCTAssertFalse(tableView.deselectRowCalled)
        let item = RolesCellViewModelItem(item: Roles(rawValue: 0)!)
        item.isSelected = false
        sut.items = [item]
        // When
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView(tableView, cellForRowAt: indexPath) as! RolesTableViewCell
        // Then
        XCTAssertEqual(item.item, cell.item?.item)
        XCTAssertTrue(tableView.deselectRowCalled)
    }
}
