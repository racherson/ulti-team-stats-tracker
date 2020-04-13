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
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(type: Int) {
        switch type {
        case SettingCellType.logout.rawValue:
            cellLabel.text = Constants.Titles.logout
            cellImage.image = UIImage(systemName: "arrow.turn.up.left")
        case SettingCellType.edit.rawValue:
            cellLabel.text = Constants.Titles.edit
            cellImage.image = UIImage(systemName: "pencil")
        default:
            fatalError(Constants.Errors.settingCellError)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
