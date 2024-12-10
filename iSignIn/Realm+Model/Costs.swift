//
//  Costs.swift
//  iSignIn
//
//  Created by meet sharma on 25/07/23.
//

import Foundation
import RealmSwift

class Costs: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var programId: Int = 0
    @Persisted var costId: Int = 0
    @Persisted var cost_item_id: Int = 0
    @Persisted var label: String = ""
    @Persisted var estimate: String = ""
    @Persisted var actual:String = ""
    @Persisted var reconciled:String = ""
    @Persisted var data:String = ""
    
    let program = LinkingObjects(fromType: Program.self, property: "costs")
    
    convenience init(json: NSDictionary) {
        self.init()
        self.costId = json["id"] as? Int ?? 0
        self.cost_item_id = json["cost_item_id"] as? Int ?? 0
        self.label = json["label"] as? String ?? ""
        self.estimate = json["estimate"] as? String ?? ""
        self.actual = json["actual"] as? String ?? ""
        self.reconciled = json["reconciled"] as? String ?? ""
    }
    
}

