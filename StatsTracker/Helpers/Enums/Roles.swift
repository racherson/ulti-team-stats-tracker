//
//  Roles.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/18/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

enum Roles: Int, CaseIterable {
    case handler
    case cutter
    case puller
    
    var description: String {
        switch self {
        case .handler:
            return Constants.Titles.handler
        case .cutter:
            return Constants.Titles.cutter
        case .puller:
            return Constants.Titles.puller
        }
    }
}
