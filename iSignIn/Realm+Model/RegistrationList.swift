//
//  RegistrationList.swift
//  iSignIn
//
//  Created by meet sharma on 21/07/23.
//

import Foundation
import RealmSwift

class RegisterList: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var registerId:Int = 0
    @Persisted var uuid:String = ""
    @Persisted var context_type: String = ""
    @Persisted var context_id:Int = 0
    @Persisted var profile_id:Int = 0
    @Persisted var presentation_id:Int = 0
    @Persisted var registration_status_id:Int = 0
    @Persisted var registration_bucket: String = ""
    @Persisted var first_name: String = ""
    @Persisted var last_name: String = ""
    @Persisted var suffix: String = ""
    @Persisted var email: String = ""
    @Persisted var phone: String = ""
    @Persisted var line_1:String = ""
    @Persisted var city:String = ""
    @Persisted var country:String = ""
    @Persisted var postal_code:String = ""
    @Persisted var state_province:String = ""
    @Persisted var created: Date = Date()
    convenience init(json: NSDictionary) {
        self.init()
        self.registerId = json["id"] as? Int ?? 0
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let dateString = json["created_at"] as? String {
            if let date = df.date(from: dateString) {
                self.created = date
            }
        }
        self.uuid = json["uuid"] as? String ?? ""
        self.context_type = json["context_type"] as? String ?? ""
        self.context_id = json["context_id"] as? Int ?? 0
        self.profile_id = json["profile_id"] as? Int ?? 0
        self.presentation_id = json["presentation_id"] as? Int ?? 0
        self.registration_bucket = json["registration_bucket"] as? String ?? ""
        self.registration_status_id = json["registration_status_id"] as? Int ?? 0
        self.first_name = json["first_name"] as? String ?? ""
        self.last_name = json["last_name"] as? String ?? ""
        self.suffix = json["suffix"] as? String ?? ""
        self.email = json["email"] as? String ?? ""
        self.phone = json["phone"] as? String ?? ""
        self.line_1 = json["line_1"] as? String ?? ""
        self.city = json["city"] as? String ?? ""
        self.country = json["country"] as? String ?? ""
        self.postal_code = json["postal_code"] as? String ?? ""
        self.state_province = json["state_province"] as? String ?? ""
    }
    
}


