//
//  PointDataModel.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/18/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

struct PointDataModel {
    var wind: Int
    var scored: Bool // home team scored or not
    var type: Int
    
    var dictionary: [String: Any] {
        return [
            Constants.PointModel.wind: wind,
            Constants.PointModel.scored: scored,
            Constants.PointModel.type: type
        ]
    }
    
    enum CodingKeys: String, CodingKey {
        case wind
        case scored
        case type
    }
    
    //MARK: Initialization
    init(wind: Int, scored: Bool, type: Int) {
        self.wind = wind
        self.scored = scored
        self.type = type
    }
}


//MARK: DocumentSerializable
extension PointDataModel: DocumentSerializable {
    init?(documentData: [String : Any]) {
        guard let wind = documentData[Constants.PointModel.wind] as? Int,
            let scored = documentData[Constants.PointModel.scored] as? Bool,
            let type = documentData[Constants.PointModel.type] as? Int else { return nil }
        
        self.init(wind: wind, scored: scored, type: type)
    }
}

//MARK: CustomDebugStringConvertible
extension PointDataModel: CustomDebugStringConvertible {
    var debugDescription: String {
        return "PointDataModel(dictionary: \(dictionary))"
    }
}

