//
//  NoDiscTableViewCell.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 6/20/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol NoDiscCellDelegate: NSObject {
    func scorePressed()
    func catchDisc(_ index: IndexPath)
    func dropDisc()
}

class NoDiscTableViewCell: PlayGameOffenseTableViewCell {
    
    //MARK: Properties
    weak var delegate: NoDiscCellDelegate?
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
    @IBAction func catchPressed(_ sender: UIButton) {
        item?.addCatch()
        delegate?.catchDisc(index)
    }
    
    @IBAction func dropPressed(_ sender: UIButton) {
        item?.addDrop()
        delegate?.dropDisc()
    }
    
    @IBAction func scorePressed(_ sender: UIButton) {
        item?.addGoal()
        delegate?.scorePressed()
    }
}
