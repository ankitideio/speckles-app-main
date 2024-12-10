//
//  InvitationsCostList.swift
//  iSignIn
//
//  Created by meet sharma on 26/07/23.
//

import Foundation
import RealmSwift

class InvitationCostList: Object {
    
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
    
    func updateInvitationCostList(withSyncedProgram syncInvitationCost: InvitationCostList) {
        
        guard costId == syncInvitationCost.costId else {
            return
        }
        costId = syncInvitationCost.costId
        cost = syncInvitationCost.cost
        label = syncInvitationCost.label
       
    }

}
