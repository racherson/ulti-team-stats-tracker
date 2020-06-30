//
//  PlayGameOffenseTableViewCell.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 6/27/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

class PlayGameOffenseTableViewCell: UITableViewCell {
    
    //MARK: Properties
    var item: PlayerViewModel?
    var index: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
