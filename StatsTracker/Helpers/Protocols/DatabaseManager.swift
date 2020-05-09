//
//  DatabaseManager.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/29/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

enum DataCollection: Int {
    case profile
    case roster
}

protocol DatabaseManager {
    
    //MARK: Properties
    var uid: String? { get set }
    var delegate: DatabaseManagerDelegate? { get set }
    
    //MARK: Methods
    func setData(data: [String: Any], collection: DataCollection)
    func getData(collection: DataCollection)
    func updateData(data: [String: Any], collection: DataCollection)
    func storeImage(image: UIImage)
}

protocol DatabaseManagerDelegate: AnyObject {
    func displayError(with error: Error)
    func newData(_ data: [String: Any]?)
    func storeImageURL(url: String)
}

extension DatabaseManagerDelegate {
    // Defaults
    func newData(_ data: [String: Any]?) { }
    func storeImageURL(url: String) { }
}
