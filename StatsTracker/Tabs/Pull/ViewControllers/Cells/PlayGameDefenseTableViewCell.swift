//
//  PlayGameDefenseTableViewCell.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 6/25/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol PlayGameDefenseCellDelegate: AnyObject { }

class PlayGameDefenseTableViewCell: UITableViewCell {

    //MARK: Properties
    weak var delegate: PlayGameDefenseCellDelegate?
    
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
