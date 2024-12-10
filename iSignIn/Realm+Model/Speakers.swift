//
//  Speakers.swift
//  iSignIn
//
//  Created by Apple on 24/07/23.
//

import Foundation
import RealmSwift

class Speakers: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var specId: Int = 0
    @Persisted var first_name: String = ""
    @Persisted var middle_name: String = ""
    @Persisted var last_name: String = ""
    @Persisted var degree: String = ""
    @Persisted var specialty: String = ""
    @Persisted var NPI: String = ""
    @Persisted var preferred_name: String = ""
    
    convenience init(json: NSDictionary) {
        self.init()
        self.specId = json["id"] as? Int ?? 0
        self.first_name = json["first_name"] as? String ?? ""
        self.middle_name = json["middle_name"] as? String ?? ""
        self.last_name = json["last_name"] as? String ?? ""
        self.degree = json["degree"] as? String ?? ""
        self.specialty = json["specialty"] as? String ?? ""
        self.NPI = json["NPI"] as? String ?? ""
        self.preferred_name = json["preferred_name"] as? String ?? ""
        
    }
    
}
