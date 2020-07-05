//
//  PointDataModelTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 7/5/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class PointDataModelTests: XCTestCase {
    
    func testRequiredInit() throws {
        // When
        let sut = PointDataModel(wind: 0, scored: true, type: 0)
        // Then
        XCTAssertEqual(0, sut.wind)
        XCTAssertTrue(sut.scored)
        XCTAssertEqual(0, sut.type)
    }
    
    func testConvenienceInit_success() throws {
        // Given
        let data: [String: Any] = [
            Constants.PointModel.wind: 0,
            Constants.PointModel.scored: true,
            Constants.PointModel.type: 0
        ]
        // When
        let sut = PointDataModel(documentData: data)
        // Then
        XCTAssertEqual(0, sut!.wind)
        XCTAssertTrue(sut!.scored)
        XCTAssertEqual(0, sut!.type)
    }
    
    func testConvenienceInit_failure() throws {
        // Given
        let data = [
            Constants.PointModel.wind: 0,
            Constants.PointModel.type: 0
        ]
        // When
        let sut = PointDataModel(documentData: data)
        // Then
        XCTAssertNil(sut)
    }
    
    func testDictionary() throws {
        // When
        let sut = PointDataModel(wind: 0, scored: true, type: 0)
        let wind = sut.dictionary[Constants.PointModel.wind] as! Int
        let scored = sut.dictionary[Constants.PointModel.scored] as! Bool
        let type = sut.dictionary[Constants.PointModel.type] as! Int
        // Then
        XCTAssertEqual(0, wind)
        XCTAssertTrue(scored)
        XCTAssertEqual(0, type)
    }
}
