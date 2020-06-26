//
//  PlayGameOffenseTableViewCell.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 6/20/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

class PlayGameOffenseTableViewCell: UITableViewCell {
    
    var item: PlayerViewModel? {
       didSet {
        textLabel?.text = item?.model.name
       }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
