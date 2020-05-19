//
//  CustomError.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/18/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

enum CustomError: Error {
    case outOfBounds
}

//MARK: LocalizedError, CustomStringConvertible
extension CustomError: LocalizedError, CustomStringConvertible {
    public var description: String {
        switch self {
        case .outOfBounds:
            return getLocalizedString(Constants.Errors.oob)
        }
    }
    
    func getLocalizedString(_ error: String) -> String {
        return String.localizedStringWithFormat(NSLocalizedString("%@", comment: "Error description"), error)
    }
}
