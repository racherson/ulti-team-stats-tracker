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
    var setDataDelegate: DatabaseManagerSetDataDelegate? { get set }
    var getDataDelegate: DatabaseManagerGetDataDelegate? { get set }
    var deleteDataDelegate: DatabaseManagerDeleteDataDelegate? { get set }
    var storeImageDelegate: DatabaseManagerStoreImageDelegate? { get set }
    
    //MARK: Methods
    func setData(data: [String: Any], collection: DataCollection)
    func getData(collection: DataCollection)
    func storeImage(image: UIImage)
    func deleteData(data: [String: Any], collection: DataCollection)
}

//MARK: DatabaseManagerSetDataDelegate
protocol DatabaseManagerSetDataDelegate: AnyObject {
    func displayError(with error: Error)
    func onSuccessfulSet()
}

//MARK: DatabaseManagerGetDataDelegate
protocol DatabaseManagerGetDataDelegate: AnyObject {
    func displayError(with error: Error)
    func onSuccessfulGet(_ data: [String: Any])
}

//MARK: DatabaseManagerDeleteDataDelegate
protocol DatabaseManagerDeleteDataDelegate: AnyObject {
    func displayError(with error: Error)
    func onSuccessfulDelete()
}

//MARK: DatabaseManagerStoreImageDelegate
protocol DatabaseManagerStoreImageDelegate: AnyObject {
    func displayError(with error: Error)
    func storeImageURL(url: String)
}
