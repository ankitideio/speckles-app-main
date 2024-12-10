//
//  Program.swift
//  iSignIn
//
//  Created by Dmitrij on 2023-01-03.
//

import Foundation
import RealmSwift
import UIKit

class Program: Object {
    
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
    @Persisted var created: Date = Date()
    @Persisted var qr_code_download: String = ""
    @Persisted var program_image_download: String = ""
    
    @Persisted var brandId: Int = 0
    @Persisted var programTypeId: Int = 0
    @Persisted var timzoneId: Int = 0
    @Persisted var speakerId: String = ""
    @Persisted var locationId: String = ""
    @Persisted var attandeesCount: Int = 0
    @Persisted var presentationId: Int = 0
    @Persisted var eventDate: String = ""
    @Persisted var eventTime: String = ""
    @Persisted var IsUploaded: Bool = false
    @Persisted var title: String = ""
    @Persisted var attendees: List<Attendee>
    @Persisted var costs: List<Costs>
    
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
        self.title = json["title"] as? String ?? ""
        self.brand = json["brands"] as? String ?? ""
        self.qr_code_download = json["qr_code_download"] as? String ?? ""
        self.program_image_download = json["program_image_download"] as? String ?? ""
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
        
    }
    
    func updateProgram (withSyncedProgram syncProgram: Program) {
        
        guard programId == syncProgram.programId else {
            return
        }
        
        startDate = syncProgram.startDate
        brand = syncProgram.brand
        label = syncProgram.label
        repName = syncProgram.repName
        speakerName = syncProgram.speakerName
        programType = syncProgram.programType
        city = syncProgram.city
        stateProvince = syncProgram.stateProvince
        postalCode = syncProgram.postalCode
        venue = syncProgram.venue
        address = syncProgram.address
        
        var attendeesToDelete = [Attendee]()
        attendeesToDelete.append(contentsOf: attendees)
        
        for syncAttendee in syncProgram.attendees {

            let found = attendeesToDelete.filter({$0.attId == syncAttendee.attId})
            if found.count > 0 {
                attendeesToDelete.removeAll { attendee in
                    return found.contains(attendee)
                }
                //update
                for foundAttendee in found {
                    
                    if foundAttendee.submitSubmited || foundAttendee.submitStatus == .readySigned || foundAttendee.submitStatus == .readyNoShow {
                        continue
                    }
                    foundAttendee.firstName = syncAttendee.firstName
                    foundAttendee.middleName = syncAttendee.middleName
                    foundAttendee.middleInitials = syncAttendee.middleInitials
                    foundAttendee.lastName = syncAttendee.lastName
                    foundAttendee.degree = syncAttendee.degree
                    foundAttendee.degreeType = syncAttendee.degreeType
                    foundAttendee.speciality = syncAttendee.speciality
                    foundAttendee.address = syncAttendee.address
                    foundAttendee.stateProvince = syncAttendee.stateProvince
                    foundAttendee.city = syncAttendee.city
                    foundAttendee.postalCode = syncAttendee.postalCode
                    foundAttendee.email = syncAttendee.email
                    foundAttendee.licenceState = syncAttendee.licenceState
                    foundAttendee.licenceNumber = syncAttendee.licenceNumber
                    foundAttendee.npi = syncAttendee.npi
                    foundAttendee.profileId = syncAttendee.profileId
                    foundAttendee.registrationStatusId = syncAttendee.registrationStatusId
                    foundAttendee.isCompanyEmployee = syncAttendee.isCompanyEmployee
                }
                
            }
            else {
                //insert
                let newAttendee = Attendee(attendee: syncAttendee)
                self.attendees.append(newAttendee)
                realm?.add(newAttendee)
            }
        }
        
        
        var costToDelete = [Costs]()
        costToDelete.append(contentsOf: costs)
        
        for syncCost in syncProgram.costs {

            let found = costToDelete.filter({$0.costId == syncCost.costId})
            if found.count > 0 {
                costToDelete.removeAll { costss in
                    return found.contains(costss)
                }
                //update
                for foundCost in found {
                   
                    foundCost.costId = syncCost.costId
                    foundCost.cost_item_id = syncCost.cost_item_id
                    foundCost.label = syncCost.label
                    foundCost.actual = syncCost.actual
                    foundCost.estimate = syncCost.estimate
                    foundCost.reconciled = syncCost.reconciled
                    
                }
                
            }else {
                //insert
                let newCost = Costs(value: syncCost)
                self.costs.append(newCost)
                realm?.add(newCost)
            }
        }
        

        
        attendeesToDelete.removeAll { attendee in
            return attendee.submitSubmited || attendee.submitStatus == .readySigned || attendee.submitStatus == .readyNoShow || attendee.manuallyAdded
        }
        
        for attendee in attendeesToDelete {
            if let index = self.attendees.firstIndex(of: attendee) {
                self.attendees.remove(at: index)
            }
            realm?.delete(attendee)
        }
        
        
    }
    
    func getFullAddress () -> String {
        var address = address
        if !city.isEmpty {
            address += ", " + city
        }
        if !stateProvince.isEmpty {
            address += ", " + stateProvince
        }
        if !postalCode.isEmpty {
            address += ", " + postalCode
        }
        
        return address
    }
    
    
    func getAttendeesToSubmit () -> [Attendee] {
        
        var results = [Attendee]()
        for attendee in attendees {
            if [.readySigned, .readyNoShow].contains(attendee.submitStatus)  && !attendee.submitSubmited {
                results.append(attendee)
            }
        }
        
        return results
    }
    
    func isReadyToSubmit () -> Bool {
        
        for attendee in attendees {
            if attendee.submitStatus != .notReady && !attendee.submitSubmited {
                return true
            }
        }
        
        return false
        
    }

}

