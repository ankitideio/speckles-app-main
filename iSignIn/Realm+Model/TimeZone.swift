//
//  TimeZone.swift
//  iSignIn
//
//  Created by meet sharma on 24/07/23.
//

import Foundation
import RealmSwift

class TimeZone: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var tzId: Int = 0
    @Persisted var label: String = ""
    @Persisted var labelIso: String = ""
    @Persisted var labelShort: String = ""
    
    convenience init(json: NSDictionary) {
        self.init()
        self.tzId = json["id"] as? Int ?? 0
        self.label = json["label"] as? String ?? ""
        self.labelIso = json["label_iso"] as? String ?? ""
        self.labelShort = json["label_short"] as? String ?? ""
    }
    
}
