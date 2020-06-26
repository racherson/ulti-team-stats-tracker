//
//  RolesTableViewCell.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/17/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

class RolesTableViewCell: UITableViewCell {
    
    var item: RolesCellViewModelItem? {
       didSet {
        textLabel?.text = item?.item.description
       }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }
}
