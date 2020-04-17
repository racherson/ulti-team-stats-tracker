//
//  FirestoreReferenceManager.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/14/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import Firebase

struct FirestoreReferenceManager {
    
    static let environment = "dev"
    
    static let db = Firestore.firestore()
    static let root = db.collection(environment).document(environment)
    
    static func referenceForUserPublicData(uid: String) -> DocumentReference {
        return root
            .collection(FirebaseKeys.CollectionPath.users)
            .document(uid)
            .collection(FirebaseKeys.CollectionPath.publicData)
            .document(FirebaseKeys.CollectionPath.publicData)
    }
    
}