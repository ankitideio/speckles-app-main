//
//  States.swift
//  iSignIn
//
//  Created by Apple on 25/07/23.
//

import Foundation
import RealmSwift

class States: Object {
    
   @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var iso: String = ""
    @Persisted var label: String = ""
 
    
    convenience init(json: NSDictionary) {
        self.init()
        self.iso = json["iso"] as? String ?? ""
        self.label = json["label"] as? String ?? ""
    
    }
    func updateState(withSyncedState syncState: States) {
        self.label = syncState.label
   
    }
}
