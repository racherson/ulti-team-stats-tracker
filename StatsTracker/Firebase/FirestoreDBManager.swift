//
//  FirestoreDBManager.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/29/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class FirestoreDBManager {
    
    //MARK: Properties
    var uid: String?
    weak var setDataDelegate: DatabaseManagerSetDataDelegate?
    weak var getDataDelegate: DatabaseManagerGetDataDelegate?
    weak var deleteDataDelegate: DatabaseManagerDeleteDataDelegate?
    weak var storeImageDelegate: DatabaseManagerStoreImageDelegate?
    
    init(_ uid: String? = nil) {
        self.uid = uid
    }
    
    private let root = Firestore
        .firestore()
        .collection(FirebaseKeys.CollectionPath.environment)
        .document(FirebaseKeys.CollectionPath.environment)
    
    //MARK: Private methods
    private func referenceForUserPublicData(_ collection: DataCollection) -> DocumentReference {
        let publicDataRef = root
            .collection(FirebaseKeys.CollectionPath.users)
            .document(uid!)
            .collection(FirebaseKeys.CollectionPath.publicData)
            .document(FirebaseKeys.CollectionPath.publicData)
        
        switch collection {
        case .profile:
            return publicDataRef
        case .roster:
            return publicDataRef
                .collection(FirebaseKeys.CollectionPath.roster)
                .document(FirebaseKeys.CollectionPath.roster)
        case .games:
            return publicDataRef
                .collection(FirebaseKeys.CollectionPath.games)
                .document(FirebaseKeys.CollectionPath.games)
        }
    }
}

//MARK: DatabaseManager
extension FirestoreDBManager: DatabaseManager {
    
    // This method adds new data to the current user's public data.
    func setData(data: [String : Any], collection: DataCollection) {
        guard uid != nil else {
            self.setDataDelegate?.displayError(with: DBError.document); return
        }
        
        // Switch on the collection type to get the correct document reference
        var docRef: DocumentReference
        
        switch collection {
        case .profile:
            docRef = referenceForUserPublicData(collection)
        case .roster:
            var genderCollection: String
            
            // Grab fields from data needed to store the data properly
            guard let gender = data[Constants.PlayerModel.gender] as? Int, let id = data[Constants.PlayerModel.id] as? String else {
                self.setDataDelegate?.displayError(with: DBError.model); return
            }
            
            // Switch on the gender to get the correct collection
            switch Gender(rawValue: gender) {
            case .women:
                genderCollection = FirebaseKeys.CollectionPath.women
            case .men:
                genderCollection = FirebaseKeys.CollectionPath.men
            case .none:
                setDataDelegate?.displayError(with: DBError.model); return
            }
            
            // Set the document reference of where to set the data
            docRef = referenceForUserPublicData(collection).collection(genderCollection).document(id)
        case .games:
            guard let id = data[Constants.GameModel.id] as? String else {
                self.setDataDelegate?.displayError(with: DBError.model); return
            }
            docRef = referenceForUserPublicData(collection).collection(FirebaseKeys.CollectionPath.games).document(id)
        }
        
        docRef.setData(data) { (error) in
            if error != nil {
                // Show error message
                self.setDataDelegate?.displayError(with: error!); return
            }
            self.setDataDelegate?.onSuccessfulSet()
        }
    }
    
    // This method retrieves the current user's public data and sends it to the delegate.
    func getData(collection: DataCollection) {
        guard uid != nil else {
            self.getDataDelegate?.displayError(with: DBError.document); return
        }
        
        switch collection {
        case .profile:
            getDataForProfile()
        case .roster:
            getDataForRoster()
        case .games:
            getDataForGames()
        }
    }
    
    private func getDataForProfile() {
        referenceForUserPublicData(.profile).getDocument { (document, error) in
            if error != nil {
                // Show error message
                self.getDataDelegate?.displayError(with: error!); return
            }
            guard let document = document, document.exists, let data = document.data() else {
                // Show error message
                self.getDataDelegate?.displayError(with: DBError.document); return
            }
            
            // Send retrieved data to delegate
            self.getDataDelegate?.onSuccessfulGet(data)
        }
    }
    
    private func getDataForRoster() {
        // Initialize gender arrays
        var womenArray: [[String: Any]] = [[String: Any]]()
        var menArray: [[String: Any]] = [[String: Any]]()
        
        // Get all the women players
        self.referenceForUserPublicData(.roster).collection(FirebaseKeys.CollectionPath.women).getDocuments { (snapshot, error) in
            if error != nil {
                // Show error message
                self.getDataDelegate?.displayError(with: error!); return
            }
            
            guard let snapshot = snapshot else {
                // Show error message
                self.getDataDelegate?.displayError(with: DBError.document); return
            }
            
            for document in snapshot.documents {
                if document.exists {
                    womenArray.append(document.data())
                }
            }
            
            // Get all the men players
            self.referenceForUserPublicData(.roster).collection(FirebaseKeys.CollectionPath.men).getDocuments { (snapshot, error) in
                if error != nil {
                    // Show error message
                    self.getDataDelegate?.displayError(with: error!); return
                }
                
                guard let snapshot = snapshot else {
                    // Show error message
                    self.getDataDelegate?.displayError(with: DBError.document); return
                }
                
                for document in snapshot.documents {
                    if document.exists {
                        menArray.append(document.data())
                    }
                }
                
                let newData = [
                            FirebaseKeys.CollectionPath.women: womenArray,
                            FirebaseKeys.CollectionPath.men: menArray
                        ]
                self.getDataDelegate?.onSuccessfulGet(newData)
            }
        }
    }
    
    private func getDataForGames() {
        // Initialize game array
        var gameArray: [[String: Any]] = [[String: Any]]()
        
        // Get all the women players
        self.referenceForUserPublicData(.games).collection(FirebaseKeys.CollectionPath.games).getDocuments { (snapshot, error) in
            if error != nil {
                // Show error message
                self.getDataDelegate?.displayError(with: error!); return
            }
            
            guard let snapshot = snapshot else {
                // Show error message
                self.getDataDelegate?.displayError(with: DBError.document); return
            }
            
            for document in snapshot.documents {
                if document.exists {
                    gameArray.append(document.data())
                }
            }
            
            let newData = [
                FirebaseKeys.CollectionPath.games: gameArray
            ]
            
            self.getDataDelegate?.onSuccessfulGet(newData)
        }
    }
    
    // This method deletes data from the database.
    func deleteData(data: [String: Any], collection: DataCollection) {
        
        switch collection {
        case .profile:
            return // Not implemented
        case .roster:
            var genderCollection: String
            
            // Grab fields from data needed to store the data properly
            guard let gender = data[Constants.PlayerModel.gender] as? Int, let id = data[Constants.PlayerModel.id] as? String else {
                self.deleteDataDelegate?.displayError(with: DBError.model); return
            }
            
            switch Gender(rawValue: gender) {
            case .women:
                genderCollection = FirebaseKeys.CollectionPath.women
            case .men:
                genderCollection = FirebaseKeys.CollectionPath.men
            case .none:
                self.deleteDataDelegate?.displayError(with: DBError.model); return
            }
            
            referenceForUserPublicData(collection).collection(genderCollection).document(id).delete() { err in
                if let err = err {
                    self.deleteDataDelegate?.displayError(with: err)
                }
                self.deleteDataDelegate?.onSuccessfulDelete()
            }
        case .games:
            // TODO
            return // Not implemented
        }
    }
    
    // This method store an image in the FirebaseStorage and returns a url to the delegate.
    func storeImage(image: UIImage) {
        // Convert image to data to store
        guard let uid = uid, let data = image.jpegData(compressionQuality: 1.0) else {
            self.storeImageDelegate?.displayError(with: DBError.document); return
        }
        
        // Store image under the current user uid
        let imageReference = Storage.storage()
            .reference()
            .child(FirebaseKeys.CollectionPath.imagesFolder)
            .child(uid)
        
        // Store the image data in storage
        imageReference.putData(data, metadata: nil) { (metadata, err) in
            if let err = err {
                // Show error message
                self.storeImageDelegate?.displayError(with: err); return
            }
            
            // Get the image url
            imageReference.downloadURL { (url, err) in
                if let err = err {
                    // Show error message
                    self.storeImageDelegate?.displayError(with: err); return
                }
                guard let url = url else {
                    // Show error message
                    self.storeImageDelegate?.displayError(with: DBError.unknown); return
                }
                
                // Send image url string to delegate
                self.storeImageDelegate?.storeImageURL(url: url.absoluteString)
            }
        }
    }
}
