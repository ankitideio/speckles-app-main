//
//  ProgramRegistrationExpenses.swift
//  iSignIn
//
//  Created by meet sharma on 24/07/23.
//

import Foundation
import RealmSwift

class ProgramRegistrationExpenses: Object {
    @Persisted var programs:Int = 0
    @Persisted var expenses:Int = 0
    @Persisted var registrations:Int = 0
  
    convenience init(json: NSDictionary) {
        self.init()
        self.programs = json["programs"] as? Int ?? 0
        self.expenses = json["expenses"] as? Int ?? 0
        self.registrations = json["registrations"] as? Int ?? 0
 
    }
}


