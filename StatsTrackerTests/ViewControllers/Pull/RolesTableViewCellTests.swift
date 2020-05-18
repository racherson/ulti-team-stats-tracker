//
//  RolesTableViewCellTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 5/18/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class RolesTableViewCellTests: XCTestCase {
    
    var sut: RolesTableViewCell!
    
    override func setUp() {
        sut = RolesTableViewCell()
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testItemDidSet() throws {
        XCTAssertNil(sut.item)
        // Given
        let item = RolesCellViewModelItem(item: Roles.handler)
        // When
        sut.item = item
        // Then
        XCTAssertEqual(sut.textLabel?.text, Roles.handler.description)
    }
}
