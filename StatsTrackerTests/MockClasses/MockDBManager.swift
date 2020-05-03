//
//  MockDBManager.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 4/30/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit
@testable import StatsTracker

class MockDBManager: DatabaseManager {
    
    //MARK: Properties
    var uid: String?
    weak var delegate: DatabaseManagerDelegate?
    
    var setDataCalled: Int = 0
    var getDataCalled: Int = 0
    var updateDataCalled: Int = 0
    var storeImageDataCalled: Int = 0
    
    //MARK: Methods
    func setData(data: [String : Any]) {
        setDataCalled += 1
    }
    
    func getData() {
        getDataCalled += 1
    }
    
    func updateData(data: [String : Any]) {
        updateDataCalled += 1
    }
    
    func storeImage(image: UIImage) {
        storeImageDataCalled += 1
    }
}
