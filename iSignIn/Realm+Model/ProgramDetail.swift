//
//  ProgramDetail.swift
//  iSignIn
//
//  Created by meet sharma on 21/07/23.
//

import Foundation
import RealmSwift

class ProgramDetail: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var programId:Int = 0
    @Persisted var startDate: Date?
    @Persisted var brand: String = ""
    @Persisted var label: String = ""
    @Persisted var repName: String = ""
    @Persisted var speakerName: String = ""
    @Persisted var programType: String = ""
    @Persisted var city: String = ""
    @Persisted var stateProvince: String = ""
    @Persisted var postalCode: String = ""
    @Persisted var venue: String = ""
    @Persisted var address: String = ""
    @Persisted var qr_code_download: String = ""
    @Persisted var created: Date = Date()

    convenience init(json: NSDictionary) {
        self.init()
        self.programId = json["id"] as? Int ?? 0
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let dateString = json["start_date"] as? String {
            if let date = df.date(from: dateString) {
                self.startDate = date
            }
        }
        self.qr_code_download = json["qr_code_download"] as? String ?? ""
        self.brand = json["brands"] as? String ?? ""
        self.label = json["label"] as? String ?? ""
        self.repName = json["rep"] as? String ?? ""
        self.speakerName = json["speakers"] as? String ?? ""
        self.programType = json["type"] as? String ?? ""
        self.city = json["city"] as? String ?? ""
        self.stateProvince = json["state_province"] as? String ?? ""
        self.postalCode = json["postal_code"] as? String ?? ""
        self.venue = json["location"] as? String ?? ""
        self.address = json["address"] as? String ?? ""
        self.created = Date()
//        self.registrations = json["registrations"] as! List<RegisterList>
        
    }
}


