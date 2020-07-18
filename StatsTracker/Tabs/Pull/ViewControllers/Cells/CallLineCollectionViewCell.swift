//
//  CallLineCollectionViewCell.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/27/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

class CallLineCollectionViewCell: UICollectionViewCell {
    
    //MARK: Properties
    @IBOutlet weak var label: UILabel!
    
    var item: PlayerViewModel? {
       didSet {
        label?.text = item?.model.name
        label?.adjustsFontSizeToFitWidth = true
        label?.textColor = .white
       }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Circle
        self.layer.cornerRadius = self.frame.size.width / 2
    }
}
