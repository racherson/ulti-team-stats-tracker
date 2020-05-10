//
//  DBError.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/30/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

enum DBError: Error {
    case document
    case unknown
    case model
}

//MARK: LocalizedError, CustomStringConvertible
extension DBError: LocalizedError, CustomStringConvertible {
    public var description: String {
        switch self {
        case .document:
            return getLocalizedString(Constants.Errors.documentError)
        case .unknown:
            return getLocalizedString(Constants.Errors.unknown)
        case .model:
            return getLocalizedString(Constants.Errors.modelError)
        }
    }
    
    func getLocalizedString(_ error: String) -> String {
        return String.localizedStringWithFormat(NSLocalizedString("%@", comment: "Error description"), error)
    }
}
