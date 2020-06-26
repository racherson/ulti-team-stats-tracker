//
//  PlayGameOffenseTableViewCell.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 6/20/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol PlayGameOffenseCellDelegate: AnyObject {
    func scorePressed()
}

class PlayGameOffenseTableViewCell: UITableViewCell {
    
    //MARK: Properties
    weak var delegate: PlayGameOffenseCellDelegate?
    @IBOutlet weak var scoreButton: UIButton!
    
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
    
    //MARK: Actions
    @IBAction func scorePressed(_ sender: Any) {
        item?.model.addGoal()
        delegate?.scorePressed()
    }
}
