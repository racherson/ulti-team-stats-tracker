//
//  PlayGameDefenseTableViewCell.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 6/25/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol DefenseCellDelegate: AnyObject {
    func dPressed()
    func callahanPressed()
}

class DefenseTableViewCell: PlayGameDefenseTableViewCell {

    //MARK: Properties
    weak var delegate: DefenseCellDelegate?
    @IBOutlet weak var nameLabel: UILabel!
    
    override var item: PlayerViewModel? {
       didSet {
        nameLabel?.text = item?.name
       }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: Actions
    @IBAction func dPressed(_ sender: UIButton) {
        item?.addD()
        delegate?.dPressed()
    }
    
    @IBAction func callahanPressed(_ sender: UIButton) {
        item?.addCallahan()
        delegate?.callahanPressed()
    }
}
