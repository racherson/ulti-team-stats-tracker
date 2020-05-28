//
//  CollectionViewSpy.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 5/27/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

class CollectionViewSpy: UICollectionView {
    
    var reloadDataCalled = false
    
    override func reloadData() {
         reloadDataCalled = true
    }
}
