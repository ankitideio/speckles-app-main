//
//  HonorariumCostList.swift
//  iSignIn
//
//  Created by meet sharma on 26/07/23.
//

import Foundation
import RealmSwift

class HonorariumCostList: Object {
    
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
    
    func updateHonorariumCostList(withSyncedProgram syncHonorariumCost: HonorariumCostList) {
        
        guard costId == syncHonorariumCost.costId else {
            return
        }
        
        costId = syncHonorariumCost.costId
        cost = syncHonorariumCost.cost
        label = syncHonorariumCost.label
       
    }

}
