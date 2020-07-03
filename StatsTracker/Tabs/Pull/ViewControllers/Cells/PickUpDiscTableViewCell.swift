//
//  PickUpDiscTableViewCell.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 7/1/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol PickUpDiscCellDelegate: NSObject {
    func catchDisc(_ index: IndexPath)
    func pickUpPressed(_ index: IndexPath)
}

class PickUpDiscTableViewCell: PlayGameOffenseTableViewCell {
    
    //MARK: Properties
    weak var delegate: PickUpDiscCellDelegate?
    @IBOutlet weak var nameLabel: UILabel!
    
    override var item: PlayerViewModel? {
       didSet {
        nameLabel?.text = item?.name
       }
    }
    
    //MARK: Actions
    @IBAction func catchPressed(_ sender: UIButton) {
        item?.addCatch()
        delegate?.catchDisc(index)
    }
    
    @IBAction func pickUpPressed(_ sender: UIButton) {
        delegate?.pickUpPressed(index)
    }
}
