//
//  Degrees.swift
//  iSignIn
//
//  Created by Apple on 24/07/23.
//

import Foundation
import RealmSwift

class Degrees: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var degreeId: Int = 0
    @Persisted var label: String = ""
 
    
    convenience init(json: NSDictionary) {
        self.init()
        self.degreeId = json["id"] as? Int ?? 0
        self.label = json["label"] as? String ?? ""
    
    }
    func updateDegree (withSyncedDegree syncDegree: Degrees) {
        self.label = syncDegree.label
   
    }
}
