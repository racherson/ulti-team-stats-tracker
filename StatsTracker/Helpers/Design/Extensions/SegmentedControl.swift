//
//  SegmentedControl.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 7/15/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

//MARK: UISegmentedControl
extension UISegmentedControl {
    open override func awakeFromNib() {
        super.awakeFromNib()
        setTitleTextAttributes(Font.segmentedControl, for: .normal)
    }
}
