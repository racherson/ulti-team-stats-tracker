//
//  SettingsTableViewCell.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/10/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var logoutImage: UIImageView!
    @IBOutlet weak var logoutLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
