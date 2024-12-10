//
//  Attendee.swift
//  iSignIn
//
//  Created by Dmitrij on 2023-01-03.
//

import Foundation
import RealmSwift
import UIKit

class Attendee: Object {
    
    
    enum AttendeeSubmitStatus: Int, PersistableEnum {
        case notReady = 0
        case readySigned
        case readyNoShow
    }
    
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var attId: Int = 0
    @Persisted var profileId: Int = 0
    @Persisted var registrationStatusId: Int = 0
    
    @Persisted var isCompanyEmployee = false
    
    @Persisted var other: String = ""
    
    @Persisted var submitSignatureDrawingData: Data?
        
    @Persisted var firstName: String = ""
    @Persisted var middleName: String = ""
    @Persisted var middleInitials: String = ""
    @Persisted var suffix: String = ""
    @Persisted var phone: String = ""
    @Persisted var lastName: String = ""
    @Persisted var degree: String = ""
    @Persisted var degreeType: String = ""
    @Persisted var speciality: String = ""
    @Persisted var address: String = ""
    @Persisted var stateProvince: String = ""
    @Persisted var city: String = ""
    @Persisted var postalCode: String = ""
    @Persisted var email: String = ""
    @Persisted var licenceState: String = ""
    @Persisted var licenceNumber: String = ""
    @Persisted var registrationBucket: String = ""
    @Persisted var isOfficeStaff: Bool = false
    @Persisted var isUsPrescriber: Bool = false
    @Persisted var isNonUsPrescriber: Bool = false
    @Persisted var isGovernmentEmployee: Bool = false
    @Persisted var npi: String = ""
    @Persisted var signature: String = ""
    @Persisted var submitMealConsumtion: Bool = false
    @Persisted var submitLicenseMN: Bool = false
    @Persisted var submitLicenseNJ: Bool = false
    @Persisted var submitLicenseVT: Bool = false
    @Persisted var submitSignature: Data?
    
    @Persisted var submitStatus: AttendeeSubmitStatus = .notReady
    @Persisted var submitSubmited: Bool = false
    @Persisted var manuallyAdded: Bool = false
    
    @Persisted(originProperty: "attendees") var program: LinkingObjects<Program>
    
    convenience init(json: NSDictionary) {
        self.init()
        self.attId = json["id"] as? Int ?? 0
        self.registrationStatusId = json["registration_status_id"] as? Int ?? 0
        self.profileId = json["profile_id"] as? Int ?? 0
        
        self.firstName = json["first_name"] as? String ?? ""
        self.middleName = json["middle_name"] as? String ?? ""
        self.middleInitials = json["middle_initial"] as? String ?? ""
        self.suffix = json["suffix"] as? String ?? ""
        self.phone = json["phone"] as? String ?? ""
        self.lastName = json["last_name"] as? String ?? ""
        self.degree = json["degree"] as? String ?? ""
        self.degreeType = json["degree_type"] as? String ?? ""
        self.speciality = json["specialty"] as? String ?? ""
        self.address = json["line_1"] as? String ?? ""
        self.stateProvince = json["state_province"] as? String ?? ""
        self.city = json["city"] as? String ?? ""
        self.postalCode = json["postal_code"] as? String ?? ""
        self.email = json["email"] as? String ?? ""
        self.licenceState = json["sln_state"] as? String ?? ""
        self.licenceNumber = json["sln"] as? String ?? ""
        self.npi = json["npi"] as? String ?? ""
        self.isCompanyEmployee = json["is_company_emp"] as? Bool ?? false
        self.registrationBucket = json["registration_bucket"] as? String ?? ""
        self.isOfficeStaff = json["is_office_staff"] as? Bool ?? false
        self.isUsPrescriber = json["is_us_prescriber"] as? Bool ?? false
        self.isNonUsPrescriber = json["is_non_us_prescriber"] as? Bool ?? false
        self.isGovernmentEmployee = json["is_government_employee"] as? Bool ?? false
        self.submitMealConsumtion = json["has_consumed_meal"] as? Bool ?? false
        self.submitLicenseMN = json["is_mn"] as? Bool ?? false
        self.submitLicenseNJ = json["is_nj"] as? Bool ?? false
        self.submitLicenseVT = json["is_vt"] as? Bool ?? false

    }
    
    convenience init(attendee: Attendee) {
        self.init()
        self.attId = attendee.attId
        self.firstName = attendee.firstName
        self.middleName = attendee.middleName
        self.middleInitials = attendee.middleInitials
        self.lastName = attendee.lastName
        self.degree = attendee.degree
        self.degreeType = attendee.degreeType
        self.speciality = attendee.speciality
        self.address = attendee.address
        self.stateProvince = attendee.stateProvince
        self.city = attendee.city
        self.postalCode = attendee.postalCode
        self.email = attendee.email
        self.licenceState = attendee.licenceState
        self.licenceNumber = attendee.licenceNumber
        self.npi = attendee.npi
        self.profileId = attendee.profileId
        self.registrationStatusId = attendee.registrationStatusId
        self.isCompanyEmployee = attendee.isCompanyEmployee
        self.submitLicenseVT = attendee.submitLicenseVT
        self.submitLicenseNJ = attendee.submitLicenseNJ
        self.submitLicenseMN = attendee.submitLicenseMN
        self.submitMealConsumtion = attendee.submitMealConsumtion
        
        self.registrationBucket = attendee.registrationBucket
        self.isOfficeStaff = attendee.isOfficeStaff
        self.isUsPrescriber = attendee.isUsPrescriber
        self.isNonUsPrescriber = attendee.isNonUsPrescriber
        self.isGovernmentEmployee = attendee.isGovernmentEmployee
    }
    
    convenience init(searchJson: NSDictionary) {
        
        self.init()
        self.attId = searchJson["id"] as? Int ?? 0
        self.profileId = searchJson["profile_id"] as? Int ?? 0
        self.firstName = searchJson["first_name"] as? String ?? ""
        self.middleName = searchJson["middle_name"] as? String ?? ""
        self.middleInitials = searchJson["middle_initial"] as? String ?? ""
        self.lastName = searchJson["last_name"] as? String ?? ""
        self.registrationStatusId = searchJson["registration_status_id"] as? Int ?? 0
        self.isCompanyEmployee = searchJson["is_company_emp"] as? Bool ?? false
        self.registrationBucket = searchJson["registration_bucket"] as? String ?? ""
        self.isOfficeStaff = searchJson["is_office_staff"] as? Bool ?? false
        self.isUsPrescriber = searchJson["is_us_prescriber"] as? Bool ?? false
        self.isNonUsPrescriber = searchJson["is_non_us_prescriber"] as? Bool ?? false
        self.isGovernmentEmployee = searchJson["is_government_employee"] as? Bool ?? false
        
        print(searchJson)
        
        
        if  let profile = searchJson.value(forKey: "hcp_profile") as? NSDictionary{
            if let degree = profile.value(forKey: "degree") as? String{
                self.degree = degree
            }
            if let npi = profile.value(forKey: "npi") as? Int{
                self.npi = "\(npi)"
            }
            else if let npi = profile.value(forKey: "npi") as? String {
                self.npi = npi
            }
            if let licenseNo = profile.value(forKey: "sln") as? String{
                self.licenceNumber = licenseNo
            }
            if let licenseState = profile.value(forKey: "sln_state") as? String{
                self.licenceState = licenseState
            }
        }
        if let address = searchJson.value(forKey: "preferred_address") as? NSDictionary{
            if let city = address.value(forKey: "city") as? String{
                self.city =  city
            }
            if let eMail = address.value(forKey: "email") as? String{
                self.email = eMail
            }
            if let street = address.value(forKey: "line_1") as? String{
                self.address = street
            }
            if let postal_code = address.value(forKey: "postal_code") as? String{
                self.postalCode = postal_code
            }
            if let state_Province = address.value(forKey: "state_province") as? String{
                self.stateProvince = state_Province
            }
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
    
    private var _drawingData: Data?
    
    func getDrawingData () -> Data? {
        return _drawingData
    }
    
    func setDrawingData (_ data: Data?) {
        _drawingData = data
    }
    
}
