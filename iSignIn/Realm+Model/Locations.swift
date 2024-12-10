//
//  Locations.swift
//  iSignIn
//
//  Created by Apple on 25/07/23.
//

import Foundation
import RealmSwift

class Locations: Object {
    
   // @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var id: Int = 0
    @Persisted var address_type: String = ""
    @Persisted var location_name: String = ""
    @Persisted var address_line: String = ""
    @Persisted var city_state: String = ""
    
    convenience init(json: NSDictionary) {
        self.init()
        self.id = json["id"] as? Int ?? 0
        self.address_type = json["address_type"] as? String ?? ""
        self.location_name = json["location_name"] as? String ?? ""
        self.address_line = json["address_line"] as? String ?? ""
        self.city_state = json["city_state"] as? String ?? ""
        
    }
    
}
