//
//  RolesCellViewModel.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/17/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

class RolesCellViewModelItem {
    var item: Roles
    var isSelected = false
    
    init(item: Roles) {
        self.item = item
    }
}

class RolesCellViewModel: NSObject {
    var items = [RolesCellViewModelItem]()
    
    init(roleArray: [Roles]) {
        items = roleArray.map { RolesCellViewModelItem(item: $0) }
    }
    
    var selectedItems: [RolesCellViewModelItem] {
        return items.filter { return $0.isSelected }
    }
}

//MARK: UITableViewDataSource
extension RolesCellViewModel: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? Constants.Titles.roles : nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "RolesTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RolesTableViewCell else {
            fatalError(Constants.Errors.dequeueError(cellIdentifier))
        }
        
        cell.item = items[indexPath.row]
        
        // Select/deselect the cell
        if items[indexPath.row].isSelected {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        } else {
            tableView.deselectRow(at: indexPath, animated: false)
        }
        
        return cell
    }
}
