//
//  TableView.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 7/13/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

//MARK: UITableView
extension UITableView {
    func setUp() {
        // Set tableview footer
        contentInsetAdjustmentBehavior = .never
        tableFooterView = UIView(frame: .zero)
        
        // Set background gradient
        Color.setGradient(view: self)
    }
}

//MARK: UITableViewCell
extension UITableViewCell {
    func setUp() {
        guard let textLabel = textLabel, let text = textLabel.text else {
            return
        }
        
        // Set tableview cell font
        let mutableAttributedString = NSMutableAttributedString(string: text, attributes: Font.tableView)
        textLabel.attributedText = mutableAttributedString
    }
}
