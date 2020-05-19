//
//  DocumentSerializable.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/18/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation

protocol DocumentSerializable {
    init?(documentData: [String: Any])
}
