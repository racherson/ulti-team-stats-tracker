//
//  RosterTableViewCell.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/4/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

class RosterTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .disclosureIndicator
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
