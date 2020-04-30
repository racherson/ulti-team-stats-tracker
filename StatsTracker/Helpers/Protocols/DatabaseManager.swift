//
//  DatabaseManager.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/29/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol DatabaseManager {
    
    //MARK: Properties
    var uid: String { get }
    var delegate: DatabaseManagerDelegate? { get set }
    
    //MARK: Methods
    func setData(data: [String: Any])
    func getData()
    func updateData(data: [String: Any])
    func storeImage(image: UIImage)
}

protocol DatabaseManagerDelegate: AnyObject {
    func displayError(with error: Error)
    func newData(_ data: [String: Any]?)
    func storeImageURL(url: String)
}

extension DatabaseManagerDelegate {
    // Defaults
    func displayError(with error: Error) { }
    func newData(_ data: [String: Any]?) { }
    func storeImageURL(url: String) { }
}

//MARK: DBError
enum DBError: Error {
    case document
    case unknown
}

extension DBError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .document:
            return Constants.Errors.documentError
        case .unknown:
            return Constants.Errors.unknown
        }
    }
}
