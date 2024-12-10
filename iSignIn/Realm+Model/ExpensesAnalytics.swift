//
//  ExpensesAnalytics.swift
//  iSignIn
//
//  Created by meet sharma on 24/07/23.
//

import Foundation
import RealmSwift

class ExpensesAnalytics: Object {
    @Persisted var January:Int = 0
    @Persisted var February:Int = 0
    @Persisted var March:Int = 0
    @Persisted var April:Int = 0
    @Persisted var May:Int = 0
    @Persisted var June:Int = 0
    @Persisted var July:Int = 0
    @Persisted var August:Int = 0
    @Persisted var September:Int = 0
    @Persisted var October:Int = 0
    @Persisted var November:Int = 0
    @Persisted var December:Int = 0
  
    convenience init(json: NSDictionary) {
        self.init()
        self.January = json["January"] as? Int ?? 0
        self.February = json["February"] as? Int ?? 0
        self.March = json["March"] as? Int ?? 0
        self.April = json["April"] as? Int ?? 0
        self.May = json["May"] as? Int ?? 0
        self.June = json["June"] as? Int ?? 0
        self.July = json["July"] as? Int ?? 0
        self.August = json["August"] as? Int ?? 0
        self.September = json["September"] as? Int ?? 0
        self.October = json["October"] as? Int ?? 0
        self.November = json["November"] as? Int ?? 0
        self.December = json["December"] as? Int ?? 0
       
 
    }
}

