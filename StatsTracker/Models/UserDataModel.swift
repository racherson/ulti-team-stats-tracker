//
//  UserDataModel.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/15/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

protocol DocumentSerializable {
    init?(documentData: [String: Any])
}

struct UserDataModel {
    
    //MARK: Properties
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

//MARK: DocumentSerializable
extension UserDataModel: DocumentSerializable {
    init?(documentData: [String : Any]) {
        guard let teamName = documentData[Constants.UserDataModel.teamName] as? String,
            let email = documentData[Constants.UserDataModel.email] as? String,
            let imageURL = documentData[Constants.UserDataModel.imageURL] as? String else { return nil }
        
        self.init(teamName: teamName, email: email, imageURL: imageURL)
    }
}

//MARK: CustomDebugStringConvertible
extension UserDataModel: CustomDebugStringConvertible {
    var debugDescription: String {
        return "UserDataModel(dictionary: \(dictionary))"
    }
}

//MARK: CustomStringConvertible
extension UserDataModel: CustomStringConvertible {
    var description: String {
        return "UserDataModel(teamName: \(teamName))"
    }
}
