//
//  UserDataModel.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/15/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

extension Constants {
    struct UserDataModel {
        static let teamName = "teamName"
        static let email = "email"
        static let imageURL = "imageURL"
    }
}

protocol DocumentSerializable {
    init?(documentData: [String: Any])
}

struct UserDataModel {
    private(set) var teamName: String
    private(set) var email: String
    private(set) var imageURL: String
    
    var dictionary: [String: Any] {
        return [
            Constants.UserDataModel.teamName: teamName,
            Constants.UserDataModel.email: email,
            Constants.UserDataModel.imageURL: imageURL
        ]
    }
}

extension UserDataModel: DocumentSerializable {
    init?(documentData: [String : Any]) {
        let teamName = documentData[Constants.UserDataModel.teamName] as? String ?? Constants.Empty.string
        let email = documentData[Constants.UserDataModel.email] as? String ?? Constants.Empty.string
        let imageURL = documentData[Constants.UserDataModel.imageURL] as? String ?? Constants.Empty.string
        self.init(teamName: teamName, email: email, imageURL: imageURL)
    }
}

extension UserDataModel: CustomDebugStringConvertible {
    var debugDescription: String {
        return "UserDataModel(dictionary: \(dictionary))"
    }
}

extension UserDataModel: CustomStringConvertible {
    var description: String {
        return "UserDataModel(teamName: \(teamName))"
    }
}
