//
//  UserDataModelTests.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 7/5/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import XCTest
@testable import StatsTracker

class UserDataModelTests: XCTestCase {
    
    func testRequiredInit() throws {
        // When
        let sut = UserDataModel(teamName: TestConstants.teamName, email: TestConstants.email, imageURL: TestConstants.empty)
        // Then
        XCTAssertEqual(TestConstants.teamName, sut.teamName)
        XCTAssertEqual(TestConstants.email, sut.email)
        XCTAssertEqual(TestConstants.empty, sut.imageURL)
    }
    
    func testConvenienceInit_success() throws {
        // Given
        let data = [
            Constants.UserDataModel.teamName: TestConstants.teamName,
            Constants.UserDataModel.email: TestConstants.email,
            Constants.UserDataModel.imageURL: TestConstants.empty
        ]
        // When
        let sut = UserDataModel(documentData: data)
        // Then
        XCTAssertEqual(TestConstants.teamName, sut!.teamName)
        XCTAssertEqual(TestConstants.email, sut!.email)
        XCTAssertEqual(TestConstants.empty, sut!.imageURL)
    }
    
    func testConvenienceInit_failure() throws {
        // Given
        let data = [
            Constants.UserDataModel.teamName: TestConstants.teamName,
            Constants.UserDataModel.email: TestConstants.email
        ]
        // When
        let sut = UserDataModel(documentData: data)
        // Then
        XCTAssertNil(sut)
    }
    
    func testDictionary() throws {
        // When
        let sut = UserDataModel(teamName: TestConstants.teamName, email: TestConstants.email, imageURL: TestConstants.empty)
        let name = sut.dictionary[Constants.UserDataModel.teamName] as! String
        let email = sut.dictionary[Constants.UserDataModel.email] as! String
        let url = sut.dictionary[Constants.UserDataModel.imageURL] as! String
        // Then
        XCTAssertEqual(TestConstants.teamName, name)
        XCTAssertEqual(TestConstants.email, email)
        XCTAssertEqual(TestConstants.empty, url)
    }
}
