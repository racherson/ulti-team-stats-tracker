//
//  HasDiscTableViewCell.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 6/26/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol HasDiscCellDelegate: NSObject {
    func turnover()
}

class HasDiscTableViewCell: PlayGameOffenseTableViewCell {
    
    //MARK: Properties
    weak var delegate: HasDiscCellDelegate?
    @IBOutlet weak var nameLabel: UILabel!
    
    override var item: PlayerViewModel? {
       didSet {
        nameLabel?.text = item?.name
       }
    }
    
    //MARK: Actions
    @IBAction func throwawayPressed(_ sender: UIButton) {
        item?.addThrowaway()
        delegate?.turnover()
    }
}
