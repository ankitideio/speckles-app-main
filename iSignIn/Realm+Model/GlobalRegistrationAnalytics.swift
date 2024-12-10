//
//  GlobalRegistrationAnalytics.swift
//  iSignIn
//
//  Created by meet sharma on 24/07/23.
//

import Foundation
import RealmSwift

class GlobalRegistrationAnalytics: Object {
    @Persisted var my:Int = 0
    @Persisted var average:String = ""
    @Persisted var top:Int = 0

    convenience init(json: NSDictionary) {
        self.init()
        self.my = json["my"] as? Int ?? 0
        self.average = json["average"] as? String ?? ""
        self.top = json["top"] as? Int ?? 0
 
    }
}
