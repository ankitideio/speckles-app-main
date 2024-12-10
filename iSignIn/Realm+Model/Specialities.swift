//
//  Specialities.swift
//  iSignIn
//
//  Created by Apple on 24/07/23.
//

import Foundation
import RealmSwift

class Specialities: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var specId: Int = 0
    @Persisted var label: String = ""
 
    
    convenience init(json: NSDictionary) {
        self.init()
        self.specId = json["id"] as? Int ?? 0
        self.label = json["label"] as? String ?? ""
    
    }
    func updateSpeciality(withSyncedSpeciality syncSpeciality: Specialities) {
        self.label = syncSpeciality.label
   
    }
}
