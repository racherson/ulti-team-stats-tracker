//
//  GamesTableViewCell.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 6/9/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

class GamesTableViewCell: UITableViewCell {
    
    var item: GameViewModel? {
       didSet {
        textLabel?.text = item?.model.opponent
       }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .disclosureIndicator
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
