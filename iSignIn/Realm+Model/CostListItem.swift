//
//  CostList.swift
//  iSignIn
//
//  Created by meet sharma on 25/07/23.
//

import Foundation
import RealmSwift

class CostListItem: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var costId: Int = 0
    @Persisted var label: String = ""
    @Persisted var cost:String = ""
    
    convenience init(json: NSDictionary) {
        self.init()
        self.costId = json["id"] as? Int ?? 0
        self.label = json["label"] as? String ?? ""
        self.cost = json["cost"] as? String ?? ""
    }
    
    func updateCostListItem(withSyncedProgram syncCostList: CostListItem) {
        
        guard costId == syncCostList.costId else {
            return
        }
        costId = syncCostList.costId
        cost = syncCostList.cost
        label = syncCostList.label
       
    }

}
