//
//  RosterTableViewCell.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/4/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

class RosterTableViewCell: UITableViewCell {

    var item: PlayerViewModel? {
       didSet {
        textLabel?.text = item?.model.name
       }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .disclosureIndicator
    }
}
