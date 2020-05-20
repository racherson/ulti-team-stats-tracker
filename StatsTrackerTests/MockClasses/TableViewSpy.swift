//
//  TableViewSpy.swift
//  StatsTrackerTests
//
//  Created by Rachel Anderson on 5/19/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

class TableViewSpy: UITableView {
    
    var reloadDataCalled = false
    var selectRowCalled = false
    var deselectRowCalled = false
    
    override func reloadData() {
         reloadDataCalled = true
    }
    
    override func numberOfRows(inSection section: Int) -> Int {
        return 1
    }
    
    override func selectRow(at indexPath: IndexPath?, animated: Bool, scrollPosition: UITableView.ScrollPosition) {
        selectRowCalled = true
    }
    
    override func deselectRow(at indexPath: IndexPath, animated: Bool) {
        deselectRowCalled = true
    }
}
