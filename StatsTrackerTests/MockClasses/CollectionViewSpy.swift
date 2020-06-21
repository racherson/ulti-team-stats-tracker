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
    var moveItemCalled = false
    
    override func reloadData() {
         reloadDataCalled = true
    }
    
    override func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        moveItemCalled = true
    }
}
