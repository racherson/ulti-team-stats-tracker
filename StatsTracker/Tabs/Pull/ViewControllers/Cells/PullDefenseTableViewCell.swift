//
//  PullDefenseTableViewCell.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 6/29/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol PullDefenseCellDelegate: NSObject {
    func pull()
}

class PullDefenseTableViewCell: PlayGameDefenseTableViewCell {
    
    //MARK: Properties
    weak var delegate: PullDefenseCellDelegate?
    @IBOutlet weak var nameLabel: UILabel!
    
    override var item: PlayerViewModel? {
       didSet {
        nameLabel?.text = item?.name
       }
    }
    
    //MARK: Actions
    @IBAction func pullPressed(_ sender: UIButton) {
        item?.addPull()
        delegate?.pull()
    }
}
