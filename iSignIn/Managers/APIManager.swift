//
//  APIManager.swift
//  iSignIn
//
//  Created by Dmitrij on 2022-12-26.
//

import Foundation
import UIKit
import SwiftKeychainWrapper
import RealmSwift

enum UserStateEnum: Int {
    case signedIn, signedOut
}

class APIManager {
    
    enum APIManagerError: Error, LocalizedError {
        case badCredentials, noInternetConnection, internalError, notAuthorised
        
        var errorDescription: String? {
            switch self {
            case .badCredentials:
                return "Cannot login user, Invalid email or password."
            case .noInternetConnection:
                return "No Internet connection."
            case .internalError:
                return "Internal Error."
            case .notAuthorised:
                return "User is not authorised."
            }
        }
    }
    
    static let shared = APIManager()

//    private let _baseURL = "https://uat-hcsp.com/api/v2mobile/"
    private let _baseURL = "https://speckles.io/api/v2mobile/"
    private let _pathLogin = "login"
    private let _pathSyncPrograms = "program"
    private let _pathSearchAttendee = "hcp/all?"
    private let _pathSubmitAttendees = "sync"
    private let _pathSyncBrands = "brands"
    private let _pathSyncTimezones = "timezone"
    private let _pathMyAnalyticsProgram = "my/programs/byyear?year="
    private let _pathMyAnalyticsRegistrations = "my/registrations/byyear?year="
    private let _pathMyAnalyticsExpenses = "my/programs/expenses?year="
    private let _pathGlobalProgramAnalytics = "my/programs/bymonth?year="
    private let _pathGlobalRegisterAnalytics = "my/registrations/bymonth?year="
    private let _pathProgramRegistrationExpense = "my/program-registration-expenses/byyear?year="
    private let _pathGetDegrees = "degrees"
    private let _pathGetSpeciality = "specialties"
    private let _pathGetStates = "states"
    private let _pathSearchSpeakers = "speakers/search?"
    private let _pathSearchLocation = "address?"
    private let _pathCosts = "costs"
    private let _PathCreateEvent = "program/create"
    private let _pathCreateCost = "cost/create"
    
    private init () {
        
    }
    
    
    var currentUserState: UserStateEnum {
        if let api_token = KeychainWrapper.standard.string(forKey: .apiToken), !api_token.isEmpty {
            return .signedIn
        }
        return .signedOut
    }
    
    //MARK: - Interface Methods
    
    func uploadAttendees (programID: Int?,attendee:Attendee?, completion: @escaping (Result<Int, Error>) -> Void) {
        
        guard let apiToken = KeychainWrapper.standard.string(forKey: .apiToken) else {
            completion(.failure(APIManagerError.notAuthorised))
            return
        }
        
        guard let url = URL(string: _baseURL + _pathSubmitAttendees) else {
            completion(.failure(APIManagerError.internalError))
            return
        }
        
        var payLoad = Dictionary<String, AnyObject>()
        var registrationDic = [AnyObject]()
            
            var record = [String : AnyObject]()
            
            
            record["id"] = attendee?.attId as AnyObject
            record["profile_id"] = attendee?.profileId as AnyObject
            record["program_id"] = programID as AnyObject
            record["registration_status_id"] = "10" as AnyObject
            record["first_name"] = attendee?.firstName as AnyObject
            record["middle_name"] = attendee?.middleName as AnyObject
            record["last_name"] = attendee?.lastName as AnyObject
            record["specialty"] = attendee?.speciality as AnyObject
            record["email"] = attendee?.email as AnyObject
            record["has_consumed_meal"] = attendee?.submitMealConsumtion as AnyObject
            record["postal_code"] = attendee?.postalCode as AnyObject
            record["degree_type"] = attendee?.degreeType as AnyObject
            record["state_province"] = attendee?.stateProvince as AnyObject
            record["line_1"] = attendee?.address as AnyObject
            record["city"] = attendee?.city as AnyObject
            record["signature"] = attendee?.signature as AnyObject
            record["is_vt"] = attendee?.submitLicenseVT as AnyObject
            record["is_mn"] = attendee?.submitLicenseMN as AnyObject
            record["is_nj"] = attendee?.submitLicenseNJ as AnyObject
            record["sln_state"] = attendee?.licenceState as AnyObject
            record["sln"] = attendee?.licenceNumber as AnyObject
            record["npi"] = attendee?.npi as AnyObject
            record["is_company_emp"] = "" as AnyObject
            record["is_office_staff"] = false as AnyObject
            record["country"] = "US" as AnyObject
            record["phone"] = attendee?.phone as AnyObject
 
            registrationDic.append(record as AnyObject)
        
            payLoad["registrations"] = registrationDic as AnyObject
                
        let jsonData = try? JSONSerialization.data(withJSONObject: payLoad)
        print(payLoad)
        var request = URLRequest(url: url)
        print(request)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
       
     
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            guard let strongSlf = self else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
                return
            }
            //-1009 no internat
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.notAuthorised))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
                return
            }
            
            do {
                
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: [.allowFragments, JSONSerialization.ReadingOptions.mutableContainers]) as? NSDictionary {
                    
                    print("uploadAttendees: \(jsonResult)")
//                    let data  = jsonResult["1"] as? NSDictionary
//                     let id = jsonResult["id"] as? Int
//
//                    let program = Program()
//                    program.programId = programID ?? 0
//                    attendee?.attId = id ?? 0
//                    let realm = try! Realm()
//                    try! realm.write {
//                        program.attendees.append(objectsIn: [attendee!])
//                        realm.add(program)
//                        print("added")
//                    }
//
                    DispatchQueue.main.async {
                        completion(.success(jsonResult.count))
                    }
                }
                else {
                    DispatchQueue.main.async {
                        completion(.failure(APIManagerError.internalError))
                    }
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
            }
            
        }
        
        task.resume()
    }
    
    
    func uploadProgram (program: Program?, completion: @escaping (Result<Int, Error>) -> Void) {
        
        guard let apiToken = KeychainWrapper.standard.string(forKey: .apiToken) else {
            completion(.failure(APIManagerError.notAuthorised))
            return
        }
        print(apiToken)
        guard let url = URL(string: _baseURL + _PathCreateEvent) else {
            completion(.failure(APIManagerError.internalError))
            return
        }
           print(url)

        var payLoad = [String:AnyObject]()
        payLoad["brand_id"] = program?.brandId as AnyObject
        payLoad["title"] = program?.label as AnyObject
        payLoad["program_type_id"] = program?.programTypeId as AnyObject
        payLoad["start_date"] = program?.eventDate as AnyObject
        payLoad["start_time"] = program?.eventTime as AnyObject
        payLoad["timezone_id"] = program?.timzoneId as AnyObject
        payLoad["attendee_count_hcp"] = program?.attandeesCount as AnyObject
        payLoad["presentation_id"] = program?.presentationId as AnyObject
        payLoad["speaker_id"] = program?.speakerId as AnyObject
        payLoad["location_id"] = program?.locationId as AnyObject
        
        print(payLoad)
        
        let jsonData = try? JSONSerialization.data(withJSONObject: payLoad)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            print(data)
            print(response)
            print(error)
            guard let strongSlf = self else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
                return
            }
            //-1009 no internat
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.notAuthorised))
                    print("done: 200")
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
                return
            }
            
            do {
                
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: [.allowFragments, JSONSerialization.ReadingOptions.mutableContainers]) as? NSDictionary {
                    
                    print("uploadAttendees: \(jsonResult)")
                    
                    let programID = jsonResult["id"] as! Int ?? 0
                    
                    program?.programId = programID
                    program?.title = program?.label ?? ""
                    let realm = try! Realm()
                         try! realm.write {
                             realm.add(program!)
                             print("Added")
                    }
                                        
                    DispatchQueue.main.async {
                        completion(.success(jsonResult.count))
                    }
                }
                else {
                    DispatchQueue.main.async {
                        completion(.failure(APIManagerError.internalError))
                    }
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
            }
            
        }
        
        task.resume()
    }
    
    
    func searchAttendees (firstName: String?, lastName: String?, npi: String?, city: String?, state: String?, completion: @escaping (Result<[Attendee], Error>) -> Void) {
        
        guard let apiToken = KeychainWrapper.standard.string(forKey: .apiToken) else {
            completion(.failure(APIManagerError.notAuthorised))
            return
        }
        
        var paramArray = [String]()
        
        if let firstName = firstName, !firstName.isEmpty, let firstNameEncoded = firstName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let string = "first_name=\(firstNameEncoded)"
            paramArray.append(string)
        }
        if let lastName = lastName, !lastName.isEmpty, let lastNameEncoded = lastName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let string = "last_name=\(lastNameEncoded)"
            paramArray.append(string)
        }
        if let npi = npi, !npi.isEmpty, let npiEncoded = npi.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let string = "npi=\(npiEncoded)"
            paramArray.append(string)
        }
        if let city = city, !city.isEmpty, let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let string = "addresses[city]=\(cityEncoded)"
            paramArray.append(string)
        }
        if let state = state, !state.isEmpty, let stateEncoded = state.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let string = "addresses[state_province]=\(stateEncoded)"
            paramArray.append(string)
        }
        
        var query = ""
        if paramArray.count > 0 {
            query = paramArray.joined(separator: "&")
        }
        
        print(paramArray)
        guard let url = URL(string: _baseURL + _pathSearchAttendee + query) else {
            completion(.failure(APIManagerError.internalError))
            return
        }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            //-1009 no internat
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.notAuthorised))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
                return
            }
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: [.allowFragments, JSONSerialization.ReadingOptions.mutableContainers]) as? NSDictionary {
                    
                    var results = [Attendee]()
                    //print("got attendees: \(jsonResult)")
                    
                    if let arrayDict = jsonResult["data"] as? NSArray {
                        for item in arrayDict {
                            if let attendee = item as? NSDictionary {
                                let newAttendee = Attendee(searchJson: attendee)
                                results.append(newAttendee)
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        completion(.success(results))
                    }
                }
                else {
                    DispatchQueue.main.async {
                        completion(.failure(APIManagerError.internalError))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
            }
            
        }
        task.resume()
    }
    
    func searchSpeakars (firstName: String?, lastName: String?, npi: String?, degree: String?, speciality: String?, completion: @escaping (Result<[Speakers], Error>) -> Void) {
        
        guard let apiToken = KeychainWrapper.standard.string(forKey: .apiToken) else {
            completion(.failure(APIManagerError.notAuthorised))
            return
        }

 
        var components = URLComponents(string: _baseURL + _pathSearchSpeakers )!
            
            // Construct the query items with the proper format
            components.queryItems = [
                URLQueryItem(name: "filter[first_name]", value: firstName ?? ""),
                URLQueryItem(name: "filter[last_name]", value: lastName ?? ""),
                URLQueryItem(name: "filter[hcpProfile][degree_id]", value: degree ?? ""),
                URLQueryItem(name: "filter[hcpProfile][specialty_id]", value: speciality ?? ""),
                URLQueryItem(name: "filter[hcpProfile][npi]", value: npi ?? "")
            ]
        
        var request = URLRequest(url: components.url!)
        print(request)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
           
            //-1009 no internat
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.notAuthorised))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
                return
            }
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray  {
                    print("Response:\(jsonResult)")
                    var results = [Speakers]()
                    //print("got attendees: \(jsonResult)")
                    
                   if let arrayDict = jsonResult as? NSArray {
                        for item in arrayDict {
                            if let attendee = item as? NSDictionary {
                                let newAttendee = Speakers(json: attendee)
                                print(newAttendee.specId)
                                results.append(newAttendee)
                            }
                        }
                   }
                    DispatchQueue.main.async {
                        completion(.success(results))
                    }
                }
                else {
                    DispatchQueue.main.async {
                        completion(.failure(APIManagerError.internalError))
                        print("Ingernal error")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
            }
            
        }
        task.resume()
    }
    
    func searchLocations (locationName: String?, type: String?, page: String?, city: String?, state: String?, completion: @escaping (Result<[Locations], Error>,_ totalPage:Int) -> Void) {
        
        guard let apiToken = KeychainWrapper.standard.string(forKey: .apiToken) else {
            completion(.failure(APIManagerError.notAuthorised), 0)
            return
        }
        
        var paramArray = [String]()
        
        if let locationName = locationName, !locationName.isEmpty, let locationNameEncoded = locationName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let string = "label=\(locationNameEncoded)"
            paramArray.append(string)
        }
        if let type = type, !type.isEmpty, let typeEncoded = type.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let string = "scopes=\(typeEncoded)"
            paramArray.append(string)
        }
        if let page = page, !page.isEmpty, let pageEncoded = page.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let string = "page=\(pageEncoded)"
            paramArray.append(string)
        }
        if let city = city, !city.isEmpty, let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let string = "city=\(cityEncoded)"
            paramArray.append(string)
        }
        if let state = state, !state.isEmpty, let stateEncoded = state.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let string = "state_province=\(stateEncoded)"
            paramArray.append(string)
        }
        
        var query = ""
        if paramArray.count > 0 {
            query = paramArray.joined(separator: "&")
        }
        
        print(paramArray)
        guard let url = URL(string: _baseURL + _pathSearchLocation + query) else {
            completion(.failure(APIManagerError.internalError), 0)
            return
        }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            //-1009 no internat
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error), 0)
                }
                return
            }
            
            guard let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.notAuthorised), 0)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError), 0)
                }
                return
            }
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: [.allowFragments, JSONSerialization.ReadingOptions.mutableContainers]) as? NSDictionary {
                    print(jsonResult)
                    let lastPage = jsonResult["last_page"] as? Int ?? 0
                    var results = [Locations]()
                    if let arrayDict = jsonResult["data"] as? NSArray {
                        for item in arrayDict {
                            if let loc = item as? NSDictionary {
                                let newloc = Locations(json: loc)
                                results.append(newloc)
                            }
                        }
                    }

                    DispatchQueue.main.async {
                        completion(.success(results),lastPage)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        completion(.failure(APIManagerError.internalError), 0)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError), 0)
                }
            }
            
        }
        task.resume()
    }
    
    
    func loginWith (username: String, password: String, completion: @escaping (Result<(), Error>) -> Void) {
        
        var request = URLRequest(url: URL(string: _baseURL + _pathLogin)!)
        print(request)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let postString = "email=\(username)&password=\(password)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            //-1009 no internat
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.notAuthorised))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
                return
            }
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: [.allowFragments, JSONSerialization.ReadingOptions.mutableContainers]) as? NSDictionary, let apiToken = jsonResult["api_token"] as? String, !apiToken.isEmpty {
                    print(apiToken)
                    KeychainWrapper.standard.set(apiToken, forKey: KeychainWrapper.Key.apiToken.rawValue)
                                DispatchQueue.main.async {
                                    completion(.success(()))
                                }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(APIManagerError.internalError))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
            }
        }
        task.resume()
        
    }
    
    func syncProgramRegistrationExpenses(completion: @escaping (Result<(), Error>) -> Void) {
        
        guard let apiToken = KeychainWrapper.standard.string(forKey: .apiToken) else {
            DispatchQueue.main.async {
                completion(.failure(APIManagerError.notAuthorised))
            }
            return
        }
        
        var request = URLRequest(url: URL(string: _baseURL + _pathProgramRegistrationExpense + (KeychainWrapper.standard.string(forKey: "year") ?? ""))!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            guard let strongSlf = self else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
                return
            }
            //-1009 no internat
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.notAuthorised))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
                return
            }

            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: [.allowFragments, JSONSerialization.ReadingOptions.mutableContainers]) as? NSDictionary {
                    //print("got timezones: \(jsonResult)")
                    if strongSlf._saveProgramRegistrationExpense(jsonResult) {
                        DispatchQueue.main.async {
                            completion(.success(()))
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            completion(.failure(APIManagerError.internalError))
                        }
                    }
                    
                }
                else {
                    DispatchQueue.main.async {
                        completion(.failure(APIManagerError.internalError))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
            }
            
        }
        task.resume()
    }
    
    func syncPrograms (completion: @escaping (Result<(), Error>) -> Void) {
        
        guard let apiToken = KeychainWrapper.standard.string(forKey: .apiToken) else {
            completion(.failure(APIManagerError.notAuthorised))
            return
        }
        
        var request = URLRequest(url: URL(string: _baseURL + _pathSyncPrograms)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            guard let strongSlf = self else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
                return
            }
            //-1009 no internat
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.notAuthorised))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
                return
            }

            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: [.allowFragments, JSONSerialization.ReadingOptions.mutableContainers]) as? [NSDictionary] {
                    print(jsonResult)
                    print("got programs: \(jsonResult)")
                    strongSlf._loadProgramAttendees(jsonResult, completion: completion)
                    
                }
                else {
                    DispatchQueue.main.async {
                        completion(.failure(APIManagerError.internalError))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
            }
            
        }
        task.resume()
    }
    
    
    func syncBrands (completion: @escaping (Result<(), Error>) -> Void) {
        
        guard let apiToken = KeychainWrapper.standard.string(forKey: .apiToken) else {
            completion(.failure(APIManagerError.notAuthorised))
            return
        }
        
        var request = URLRequest(url: URL(string: _baseURL + _pathSyncBrands)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            guard let strongSlf = self else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
                return
            }
            //-1009 no internat
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.notAuthorised))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
                return
            }

            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: [.allowFragments, JSONSerialization.ReadingOptions.mutableContainers]) as? NSDictionary {
              
                    //print("got brands: \(jsonResult)")
                    if strongSlf._saveBrands(jsonResult) {
                        DispatchQueue.main.async {
                            completion(.success(()))
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            completion(.failure(APIManagerError.internalError))
                        }
                    }
                    
                }
                else {
                    print("cannot create json brands data")
                    let string = String(data: data, encoding: .utf8)
                    //print(string)
                    DispatchQueue.main.async {
                        completion(.failure(APIManagerError.internalError))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
            }
            
        }
        task.resume()
    }
    
    func syncTimezones (completion: @escaping (Result<(), Error>) -> Void) {
        
        guard let apiToken = KeychainWrapper.standard.string(forKey: .apiToken) else {
            DispatchQueue.main.async {
                completion(.failure(APIManagerError.notAuthorised))
            }
            return
        }
        
        var request = URLRequest(url: URL(string: _baseURL + _pathSyncTimezones)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            guard let strongSlf = self else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
                return
            }
            //-1009 no internat
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.notAuthorised))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
                return
            }

            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: [.allowFragments, JSONSerialization.ReadingOptions.mutableContainers]) as? NSDictionary {
                    //print("got timezones: \(jsonResult)")
                    if strongSlf._saveTimezones(jsonResult) {
                        DispatchQueue.main.async {
                            completion(.success(()))
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            completion(.failure(APIManagerError.internalError))
                        }
                    }
                    
                }
                else {
                    DispatchQueue.main.async {
                        completion(.failure(APIManagerError.internalError))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
            }
            
        }
        task.resume()
    }
   
    func syncDegrees (completion: @escaping (Result<(), Error>) -> Void) {
        
        guard let apiToken = KeychainWrapper.standard.string(forKey: .apiToken) else {
            DispatchQueue.main.async {
                completion(.failure(APIManagerError.notAuthorised))
            }
            return
        }
        
        var request = URLRequest(url: URL(string: _baseURL + _pathGetDegrees)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            guard let strongSlf = self else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
                return
            }
            //-1009 no internat
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.notAuthorised))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
                return
            }

            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: [.allowFragments, JSONSerialization.ReadingOptions.mutableContainers]) as? NSArray {
                    print(jsonResult)
                    //print("got timezones: \(jsonResult)")
                    if strongSlf._saveDegrees(jsonResult as! [NSDictionary]) {
                        DispatchQueue.main.async {
                            completion(.success(()))
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            completion(.failure(APIManagerError.internalError))
                        }
                    }
                    
                }
                else {
                    DispatchQueue.main.async {
                        completion(.failure(APIManagerError.internalError))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
            }
            
        }
        task.resume()
    }
   
    
    func syncSpeciality (completion: @escaping (Result<(), Error>) -> Void) {
        guard let apiToken = KeychainWrapper.standard.string(forKey: .apiToken) else {
          DispatchQueue.main.async {
            completion(.failure(APIManagerError.notAuthorised))
          }
          return
        }
        var request = URLRequest(url: URL(string: _baseURL + _pathGetSpeciality)!)
        print(request)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
          guard let strongSlf = self else {
            DispatchQueue.main.async {
              completion(.failure(APIManagerError.internalError))
            }
            return
          }
          //-1009 no internat
          if let error = error {
            DispatchQueue.main.async {
              completion(.failure(error))
            }
            return
          }
          guard let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 else {
            DispatchQueue.main.async {
              completion(.failure(APIManagerError.notAuthorised))
            }
            return
          }
          guard let data = data else {
            DispatchQueue.main.async {
              completion(.failure(APIManagerError.internalError))
            }
            return
          }
          do {
            if let jsonResult = try JSONSerialization.jsonObject(with: data, options: [.allowFragments, JSONSerialization.ReadingOptions.mutableContainers]) as? NSArray {
              print(jsonResult)
                if strongSlf._saveSpecialities(jsonResult as! [NSDictionary]) {
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                }
                else {
                    DispatchQueue.main.async {
                        completion(.failure(APIManagerError.internalError))
                    }
                }
            }
            else {
              DispatchQueue.main.async {
                completion(.failure(APIManagerError.internalError))
              }
            }
          } catch {
            DispatchQueue.main.async {
              completion(.failure(APIManagerError.internalError))
            }
          }
        }
        task.resume()
      }
    
    func syncStates (completion: @escaping (Result<(), Error>) -> Void) {
        guard let apiToken = KeychainWrapper.standard.string(forKey: .apiToken) else {
          DispatchQueue.main.async {
            completion(.failure(APIManagerError.notAuthorised))
          }
          return
        }
        var request = URLRequest(url: URL(string: _baseURL + _pathGetStates)!)
        print(request)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
          guard let strongSlf = self else {
            DispatchQueue.main.async {
              completion(.failure(APIManagerError.internalError))
            }
            return
          }
          //-1009 no internat
          if let error = error {
            DispatchQueue.main.async {
              completion(.failure(error))
            }
            return
          }
          guard let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 else {
            DispatchQueue.main.async {
              completion(.failure(APIManagerError.notAuthorised))
            }
            return
          }
          guard let data = data else {
            DispatchQueue.main.async {
              completion(.failure(APIManagerError.internalError))
            }
            return
          }
          do {
            if let jsonResult = try JSONSerialization.jsonObject(with: data, options: [.allowFragments, JSONSerialization.ReadingOptions.mutableContainers]) as? NSArray {
              print(jsonResult)
                if strongSlf._saveStates(jsonResult as! [NSDictionary]) {
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                }
                else {
                    DispatchQueue.main.async {
                        completion(.failure(APIManagerError.internalError))
                    }
                }
            }
            else {
              DispatchQueue.main.async {
                completion(.failure(APIManagerError.internalError))
              }
            }
          } catch {
            DispatchQueue.main.async {
              completion(.failure(APIManagerError.internalError))
            }
          }
        }
        task.resume()
      }
    
    func syncCosts (completion: @escaping (Result<(), Error>) -> Void) {
            guard let apiToken = KeychainWrapper.standard.string(forKey: .apiToken) else {
              DispatchQueue.main.async {
                completion(.failure(APIManagerError.notAuthorised))
              }
              return
            }
            var request = URLRequest(url: URL(string: _baseURL + _pathCosts)!)
            print(request)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
            let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
              guard let strongSlf = self else {
                DispatchQueue.main.async {
                  completion(.failure(APIManagerError.internalError))
                }
                return
              }
              //-1009 no internat
              if let error = error {
                DispatchQueue.main.async {
                  completion(.failure(error))
                }
                return
              }
              guard let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 else {
                DispatchQueue.main.async {
                  completion(.failure(APIManagerError.notAuthorised))
                }
                return
              }
              guard let data = data else {
                DispatchQueue.main.async {
                  completion(.failure(APIManagerError.internalError))
                }
                return
              }
                do {
                           if let jsonResult = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [NSDictionary] {
                               print(jsonResult)
                               let avArray = jsonResult.first(where: { $0["AV"] != nil })?["AV"] as? NSArray
                               let travelArray = jsonResult.first(where: { $0["Travel"] != nil })?["Travel"] as? NSArray
                               let invitationsArray = jsonResult.first(where: { $0["Invitations"] != nil })?["Invitations"] as? NSArray
                               let fbArray = jsonResult.first(where: { $0["FB"] != nil })?["FB"] as? NSArray
                               let honorariumArray = jsonResult.first(where: { $0["Honorarium"] != nil })?["Honorarium"] as? NSArray
                               let miscellaneousArray = jsonResult.first(where: { $0["Miscellaneous"] != nil })?["Miscellaneous"] as? NSArray
                               if strongSlf._saveCost(avArray ?? NSArray(), type: 0) {
                                   print("0")
                               }
                               if strongSlf._saveCost(travelArray ?? NSArray(), type: 1){
                                   print("1")
                               }
                                if strongSlf._saveCost(invitationsArray ?? NSArray(), type: 2){
                                  print("2")
                               }
                               if strongSlf._saveCost(fbArray ?? NSArray(), type: 3){
                                   print("3")
                               }
                               if strongSlf._saveCost(honorariumArray ?? NSArray(), type: 4){
                                   print("4")
                               }
                               if strongSlf._saveCost(miscellaneousArray ?? NSArray(), type: 5){
                                  print("5")
                               }
                               DispatchQueue.main.async {
                                   completion(.success(()))
                               }
                           }
                           else {
                             DispatchQueue.main.async {
                               completion(.failure(APIManagerError.internalError))
                             }
                           }
                       } catch {
                           DispatchQueue.main.async {
                               completion(.failure(APIManagerError.internalError))
                           }
                       }
                   }
                   task.resume()
          }
    
    func createCost (cost: Costs?, completion: @escaping (Result<(), Error>) -> Void) {

        guard let apiToken = KeychainWrapper.standard.string(forKey: .apiToken) else {
          DispatchQueue.main.async {
            completion(.failure(APIManagerError.notAuthorised))
          }
          return
        }
        
        
        var payLoad = [String:AnyObject]()
        payLoad["program_id"] = cost?.programId as AnyObject
        payLoad["cost_item_id"] = cost?.cost_item_id as AnyObject
        payLoad["estimate"] = cost?.estimate as AnyObject
        payLoad["actual"] = cost?.actual as AnyObject
        payLoad["data"] = cost?.data as AnyObject
        
        print(payLoad)
        
        let jsonData = try? JSONSerialization.data(withJSONObject: payLoad)
        
        var request = URLRequest(url: URL(string: _baseURL + _pathCreateCost)!)
        print(request)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            //-1009 no internat
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.notAuthorised))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
                return
            }
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: [.allowFragments, JSONSerialization.ReadingOptions.mutableContainers]) as? NSDictionary {
                    print(jsonResult)
                    
//                    let program = Program()
//                    program.programId = cost?.programId ?? 0
//                    let costId = jsonResult["id"] as? Int ?? 0
//                    cost?.costId = costId
//                    let realm = try! Realm()
//                    try! realm.write {
//                        program.costs.append(cost!)
//                        realm.add(program, update: .modified)
//
//                        print("added")
//                    }

                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                    }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
            }
        }
        task.resume()
        
    }
    
    func syncProgramAnalytics(completion: @escaping (Result<(), Error>) -> Void) {
        
        guard let apiToken = KeychainWrapper.standard.string(forKey: .apiToken) else {
            completion(.failure(APIManagerError.notAuthorised))
            return
        }
        var request = URLRequest(url: URL(string: _baseURL + _pathMyAnalyticsProgram + (KeychainWrapper.standard.string(forKey: "year") ?? ""))!)
        print(request)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            guard let strongSlf = self else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
                return
            }
            //-1009 no internat
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.notAuthorised))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
                return
            }
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? NSDictionary {
                    print(jsonResult)
             
                    if strongSlf._saveMyAnalytics(jsonResult) {
                        DispatchQueue.main.async {
                            completion(.success(()))
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            completion(.failure(APIManagerError.internalError))
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
            }
        }
        task.resume()
    }
    
    func syncRegistrationAnalytics(completion: @escaping (Result<(), Error>) -> Void) {
        
        guard let apiToken = KeychainWrapper.standard.string(forKey: .apiToken) else {
            completion(.failure(APIManagerError.notAuthorised))
            return
        }
        var request = URLRequest(url: URL(string: _baseURL + _pathMyAnalyticsRegistrations + (KeychainWrapper.standard.string(forKey: "year") ?? ""))!)
        print(request)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            guard let strongSlf = self else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
                return
            }
            //-1009 no internat
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.notAuthorised))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
                return
            }
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? NSDictionary {
                    print(jsonResult)
                
                    if strongSlf._saveRegistrationAnalytics(jsonResult) {
                        DispatchQueue.main.async {
                            completion(.success(()))
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            completion(.failure(APIManagerError.internalError))
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
            }
        }
        task.resume()
    }
    
    func syncExpensesAnalytics(completion: @escaping (Result<(), Error>) -> Void) {
        
        guard let apiToken = KeychainWrapper.standard.string(forKey: .apiToken) else {
            completion(.failure(APIManagerError.notAuthorised))
            return
        }
        var request = URLRequest(url: URL(string: _baseURL + _pathMyAnalyticsExpenses + (KeychainWrapper.standard.string(forKey: "year") ?? ""))!)
        print(request)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            guard let strongSlf = self else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
                return
            }
            //-1009 no internat
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.notAuthorised))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
                return
            }
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? NSDictionary {
                    print(jsonResult)
                    //                     let arrayDict = jsonResult[year] as? NSDictionary
                    //                    let programDetail = MyAnalytics(json: arrayDict ?? NSDictionary())
                    //                    print(programDetail)
                    if strongSlf._saveExpensesAnalytics(jsonResult) {
                        DispatchQueue.main.async {
                            completion(.success(()))
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            completion(.failure(APIManagerError.internalError))
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
            }
        }
        task.resume()
    }
    
    func syncProgramGlobalAnalytics(completion: @escaping (Result<(), Error>) -> Void) {
        
        guard let apiToken = KeychainWrapper.standard.string(forKey: .apiToken) else {
            completion(.failure(APIManagerError.notAuthorised))
            return
        }
        var request = URLRequest(url: URL(string: _baseURL + _pathGlobalProgramAnalytics + (KeychainWrapper.standard.string(forKey: "year") ?? ""))!)
        print(request)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            guard let strongSlf = self else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
                return
            }
            
            //-1009 no internat
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.notAuthorised))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
                return
            }
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? NSDictionary {
                    
                    var results = [GlobalProgramAnalytics]()
                    results.removeAll()
                    let  arrayDict = jsonResult[KeychainWrapper.standard.string(forKey: "year") ?? ""] as? NSDictionary
                    let jan = arrayDict?["January"] as? NSDictionary
                    let feb = arrayDict?["February"] as? NSDictionary
                    let march = arrayDict?["March"] as? NSDictionary
                    let april = arrayDict?["April"] as? NSDictionary
                    let may = arrayDict?["May"] as? NSDictionary
                    let june = arrayDict?["June"] as? NSDictionary
                    let july = arrayDict?["July"] as? NSDictionary
                    let aug = arrayDict?["August"] as? NSDictionary
                    let sep = arrayDict?["September"] as? NSDictionary
                    let oct = arrayDict?["October"] as? NSDictionary
                    let nov = arrayDict?["November"] as? NSDictionary
                    let dec = arrayDict?["December"] as? NSDictionary
                    let janData = GlobalProgramAnalytics(json: jan ?? NSDictionary())
                    let febData = GlobalProgramAnalytics(json: feb ?? NSDictionary())
                    let marchData = GlobalProgramAnalytics(json: march ?? NSDictionary())
                    let aprilData = GlobalProgramAnalytics(json: april ?? NSDictionary())
                    let mayData = GlobalProgramAnalytics(json: may ?? NSDictionary())
                    let juneData = GlobalProgramAnalytics(json: june ?? NSDictionary())
                    let julyData = GlobalProgramAnalytics(json: july ?? NSDictionary())
                    let augData = GlobalProgramAnalytics(json: aug ?? NSDictionary())
                    let sepData = GlobalProgramAnalytics(json: sep ?? NSDictionary())
                    let octData = GlobalProgramAnalytics(json: oct ?? NSDictionary())
                    let novData = GlobalProgramAnalytics(json: nov ?? NSDictionary())
                    let decData = GlobalProgramAnalytics(json: dec ?? NSDictionary())
                    results.append(janData)
                    results.append(febData)
                    results.append(marchData)
                    results.append(aprilData)
                    results.append(mayData)
                    results.append(juneData)
                    results.append(julyData)
                    results.append(augData)
                    results.append(sepData)
                    results.append(octData)
                    results.append(novData)
                    results.append(decData)
                    print(results)
                    if strongSlf._saveGlobalProgramAnalytics(results) {
                        DispatchQueue.main.async {
                            completion(.success(()))
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            completion(.failure(APIManagerError.internalError))
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
            }
        }
        task.resume()
    }
    
    func syncRegistrationGlobalAnalytics(completion: @escaping (Result<(), Error>) -> Void) {

        guard let apiToken = KeychainWrapper.standard.string(forKey: .apiToken) else {
            completion(.failure(APIManagerError.notAuthorised))
            return
        }
        var request = URLRequest(url: URL(string: _baseURL + _pathGlobalRegisterAnalytics + (KeychainWrapper.standard.string(forKey: "year") ?? ""))!)
        print(request)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            guard let strongSlf = self else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
                return
            }
            
            //-1009 no internat
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.notAuthorised))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
                return
            }
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? NSDictionary {
                    
                    var results = [GlobalRegistrationAnalytics]()
                    results.removeAll()
                    let  arrayDict = jsonResult[KeychainWrapper.standard.string(forKey: "year") ?? ""] as? NSDictionary
                    let jan = arrayDict?["January"] as? NSDictionary
                    let feb = arrayDict?["February"] as? NSDictionary
                    let march = arrayDict?["March"] as? NSDictionary
                    let april = arrayDict?["April"] as? NSDictionary
                    let may = arrayDict?["May"] as? NSDictionary
                    let june = arrayDict?["June"] as? NSDictionary
                    let july = arrayDict?["July"] as? NSDictionary
                    let aug = arrayDict?["August"] as? NSDictionary
                    let sep = arrayDict?["September"] as? NSDictionary
                    let oct = arrayDict?["October"] as? NSDictionary
                    let nov = arrayDict?["November"] as? NSDictionary
                    let dec = arrayDict?["December"] as? NSDictionary
                    let janData = GlobalRegistrationAnalytics(json: jan ?? NSDictionary())
                    let febData = GlobalRegistrationAnalytics(json: feb ?? NSDictionary())
                    let marchData = GlobalRegistrationAnalytics(json: march ?? NSDictionary())
                    let aprilData = GlobalRegistrationAnalytics(json: april ?? NSDictionary())
                    let mayData = GlobalRegistrationAnalytics(json: may ?? NSDictionary())
                    let juneData = GlobalRegistrationAnalytics(json: june ?? NSDictionary())
                    let julyData = GlobalRegistrationAnalytics(json: july ?? NSDictionary())
                    let augData = GlobalRegistrationAnalytics(json: aug ?? NSDictionary())
                    let sepData = GlobalRegistrationAnalytics(json: sep ?? NSDictionary())
                    let octData = GlobalRegistrationAnalytics(json: oct ?? NSDictionary())
                    let novData = GlobalRegistrationAnalytics(json: nov ?? NSDictionary())
                    let decData = GlobalRegistrationAnalytics(json: dec ?? NSDictionary())
                    results.append(janData)
                    results.append(febData)
                    results.append(marchData)
                    results.append(aprilData)
                    results.append(mayData)
                    results.append(juneData)
                    results.append(julyData)
                    results.append(augData)
                    results.append(sepData)
                    results.append(octData)
                    results.append(novData)
                    results.append(decData)
                    print(results)
                    if strongSlf._saveGlobalRegistrationAnalytics(results) {
                        DispatchQueue.main.async {
                            completion(.success(()))
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            completion(.failure(APIManagerError.internalError))
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
            }
        }
        task.resume()
    }
    
    func logout () {
        
        if let realm = RealmManager.shared.getBackgroundRealm() {
            realm.writeAsync({
                realm.deleteAll()
            
            })
        }
        
  
        KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.apiToken.rawValue)
        KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.applicationPasscode.rawValue)
        KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.applicationBiometricsEnabled.rawValue)
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.changeStoryboard()
        
    }
    
    //MARK: - Private Methods
    
    private func _saveTimezones (_ timezoneData: NSDictionary) -> Bool {
        guard let realm = RealmManager.shared.getBackgroundRealm() else {
            return false
        }
        guard let zones = timezoneData["data"] as? NSArray else {
            return false
        }
        guard zones.count > 0 else {
            return true
        }
        var savedZoneIds = [Int]()
        for item in zones {
            guard let zone = item as? NSDictionary else {
                continue
            }
            let timezone = TimeZone(json: zone)
            savedZoneIds.append(timezone.tzId)
            if let foundTimezone = realm.objects(TimeZone.self).filter("tzId == \(timezone.tzId)").first {
                try? realm.write {
                    foundTimezone.label = timezone.label
                    foundTimezone.labelIso = timezone.labelIso
                    foundTimezone.labelShort = timezone.labelShort
                }
            }
            else {
                try? realm.write {
                    realm.add(timezone)
                }
            }
        }
        //Delete timezones
        let zoneToDelete = realm.objects(TimeZone.self).filter("NOT (tzId IN %@)", savedZoneIds)
        if zoneToDelete.count > 0 {
            try? realm.write({
                for item in zoneToDelete {
                    realm.delete(item)
                }
            })
        }
        return true
    }
    
    private func _saveBrands (_ brandData: NSDictionary) -> Bool {
        guard let realm = RealmManager.shared.getBackgroundRealm() else {
            return false
        }
        guard let brands = brandData["data"] as? NSArray else {
            print("caccon get brand array")
            return false
        }
        
        var savedBrandIds = [Int]()
        for item in brands {
            guard let brand = item as? NSDictionary else {
                continue
            }
            
            let brandObject = Brand(json: brand)
            
            savedBrandIds.append(brandObject.brandId)
            if let foundBrand = realm.objects(Brand.self).filter("brandId == \(brandObject.brandId)").first {
                try? realm.write {
                    foundBrand.updateBrand(withSyncedBrand: brandObject)
                }
            }
            else {
                try? realm.write {
                    realm.add(brandObject,update: .modified)
                }
            }

        }
     
        let brandsToDelete = realm.objects(Brand.self).filter("NOT (brandId IN %@)", savedBrandIds)
        if brandsToDelete.count > 0 {
            try? realm.write({
                for item in brandsToDelete {
                    realm.delete(item)
                }
            })
        }
        print("saved brands:")
        let testbrands = realm.objects(Brand.self)
        for item in testbrands {
            print(item)
            print("programTypes: \(item.programTypes.count) presentations: \(item.presentations.count)")
        }
        print(testbrands)
        return true
    }
    
    private func _saveDegrees(_ degrees: [NSDictionary]) -> Bool {
        guard let realm = RealmManager.shared.getBackgroundRealm() else {
            return false
        }
        var savedDegreeIds = [Int]()
        for item in degrees {
            guard let degree = item as? NSDictionary else {
                continue
            }
            
            let degreeObject = Degrees(json: degree)
            
            savedDegreeIds.append(degreeObject.degreeId)
            if let foundDegree = realm.objects(Degrees.self).filter("degreeId == \(degreeObject.degreeId)").first {
                try? realm.write {
                    foundDegree.updateDegree(withSyncedDegree: degreeObject)
                }
            }
            else {
                try? realm.write {
                    realm.add(degreeObject,update: .modified)
                }
            }

        }
     
        let degreeToDelete = realm.objects(Degrees.self).filter("NOT (degreeId IN %@)", savedDegreeIds)
        if degreeToDelete.count > 0 {
            try? realm.write({
                for item in degreeToDelete{
                    realm.delete(item)
                }
            })
        }
        print("saved brands:")
       

//                    for degree in degrees {
//                        if let degreeDict = degree as? NSDictionary {
//                            let degreeObject = Degrees(json: degreeDict)
//                            try? realm.write {
//                                realm.add(degreeObject,update:.modified)
//                            }
//                        } else {
//                            // Handle invalid degree format if needed
//                        }
//                    }

        return true
    }
    
   


    private func _saveCost(_ costs: NSArray,type:Int) -> Bool {
        guard let realm = RealmManager.shared.getBackgroundRealm() else {
            return false
        }
        if type == 0{
            var savedCostIds = [Int]()
            for cost in costs {
                if let costDict = cost as? NSDictionary {
                    let costObject = CostListItem(json: costDict)
                    savedCostIds.append(costObject.costId)
                    if let foundBrand = realm.objects(CostListItem.self).filter("costId == \(costObject.costId)").first {
                        try? realm.write {
                            foundBrand.updateCostListItem(withSyncedProgram: costObject)
                        }
                    }
                    else {
                        try? realm.write {
                            realm.add(costObject,update: .modified)
                        }
                    }
                }
            }
        }else if type == 1{
            var savedCostIds = [Int]()
            for cost in costs {
                if let costDict = cost as? NSDictionary {
                    let costObject = TravelCostList(json: costDict)
                    savedCostIds.append(costObject.costId)
                    if let foundBrand = realm.objects(TravelCostList.self).filter("costId == \(costObject.costId)").first {
                        try? realm.write {
                            foundBrand.updateTravelCostList(withSyncedProgram: costObject)
                        }
                    }
                    else {
                        try? realm.write {
                            realm.add(costObject,update: .modified)
                        }
                    }
                }
            }
        }else if type == 2{
            var savedCostIds = [Int]()
            for cost in costs {
                if let costDict = cost as? NSDictionary {
                    let costObject = InvitationCostList(json: costDict)
                    savedCostIds.append(costObject.costId)
                    if let foundBrand = realm.objects(InvitationCostList.self).filter("costId == \(costObject.costId)").first {
                        try? realm.write {
                            foundBrand.updateInvitationCostList(withSyncedProgram: costObject)
                        }
                    }
                    else {
                        try? realm.write {
                            realm.add(costObject,update: .modified)
                        }
                    }
                }
            }
        }else if type == 3{
            var savedCostIds = [Int]()
            for cost in costs {
                if let costDict = cost as? NSDictionary {
                    let costObject = FBCostList(json: costDict)
                    savedCostIds.append(costObject.costId)
                    if let foundBrand = realm.objects(FBCostList.self).filter("costId == \(costObject.costId)").first {
                        try? realm.write {
                            foundBrand.updateFBCostList(withSyncedProgram: costObject)
                        }
                    }
                    else {
                        try? realm.write {
                            realm.add(costObject,update: .modified)
                        }
                    }
                }
            }
        }else if type == 4{
            var savedCostIds = [Int]()
            for cost in costs {
                if let costDict = cost as? NSDictionary {
                    let costObject = HonorariumCostList(json: costDict)
                    savedCostIds.append(costObject.costId)
                    if let foundBrand = realm.objects(HonorariumCostList.self).filter("costId == \(costObject.costId)").first {
                        try? realm.write {
                            foundBrand.updateHonorariumCostList(withSyncedProgram: costObject)
                        }
                    }
                    else {
                        try? realm.write {
                            realm.add(costObject,update: .modified)
                        }
                    }
                }
            }
        }else{
                var savedCostIds = [Int]()
                for cost in costs {
                    if let costDict = cost as? NSDictionary {
                        let costObject = MiscellaneousCostList(json: costDict)
                        savedCostIds.append(costObject.costId)
                        if let foundBrand = realm.objects(MiscellaneousCostList.self).filter("costId == \(costObject.costId)").first {
                            try? realm.write {
                                foundBrand.updateMiscellaneousCostList(withSyncedProgram: costObject)
                            }
                        }
                        else {
                            try? realm.write {
                                realm.add(costObject,update: .modified)
                            }
                        }
                    }
                }
            }
        
            return true
        }
    
    
    
    private func _saveSpecialities (_ speciality: [NSDictionary]) -> Bool {
        guard let realm = RealmManager.shared.getBackgroundRealm() else {
            return false
        }
        var savedSpecialityIds = [Int]()
        for item in speciality {
            guard let special = item as? NSDictionary else {
                continue
            }
            
            let specialityObject = Specialities(json: special)
            
            savedSpecialityIds.append(specialityObject.specId)
            if let foundSpeciality = realm.objects(Specialities.self).filter("specId == \(specialityObject.specId)").first {
                try? realm.write {
                    foundSpeciality.updateSpeciality(withSyncedSpeciality: specialityObject)
                }
            }
            else {
                try? realm.write {
                    realm.add(specialityObject,update: .modified)
                }
            }

        }
     
        let specialitiesToDelete = realm.objects(Specialities.self).filter("NOT (specId IN %@)", savedSpecialityIds)
        if specialitiesToDelete.count > 0 {
            try? realm.write({
                for item in specialitiesToDelete{
                    realm.delete(item)
                }
            })
        }
        print("saved brands:")
//        guard let realm = RealmManager.shared.getBackgroundRealm() else {
//            return false
//        }
//
//        for special in speciality {
//            if let specialDict = special as? NSDictionary {
//                let specialObject = Specialities(json: specialDict)
//                try? realm.write {
//                    realm.add(specialObject)
//                }
//            } else {
//
//            }
//        }
        
        return true
    }
    
    private func _saveStates (_ states: [NSDictionary]) -> Bool {
  
        guard let realm = RealmManager.shared.getBackgroundRealm() else {
            return false
        }

        for state in states {
            if let stateDict = state as? NSDictionary {
                let stateObject = States(json: stateDict)
                try? realm.write {
                    realm.add(stateObject)
                }
            } else {

            }
        }
        
        return true
    }
    
    private func _saveMyAnalytics(_ myAnalyticsData: NSDictionary) -> Bool{
        guard let realm = RealmManager.shared.getBackgroundRealm() else {
            return false
        }
        guard let myAnalytics = myAnalyticsData[KeychainWrapper.standard.string(forKey: "year") ?? ""] as? NSDictionary else {
            print("caccon get brand array")
            return false
        }
        let myAnalyticsObject = ProgramAnalytics(json: myAnalytics)
        try? realm.write {
            realm.add(myAnalyticsObject)
           
        }
        
      return true
    }
    
    private func _saveProgramRegistrationExpense(_ myExpenseData: NSDictionary) -> Bool{
        guard let realm = RealmManager.shared.getBackgroundRealm() else {
            return false
        }
        
        let myAnalyticsObject = ProgramRegistrationExpenses(json: myExpenseData)
        try? realm.write {
            realm.add(myAnalyticsObject)
           
        }
      return true
    }
    
    
    private func _saveRegistrationAnalytics(_ myAnalyticsData: NSDictionary) -> Bool{
        guard let realm = RealmManager.shared.getBackgroundRealm() else {
            return false
        }
        guard let myAnalytics = myAnalyticsData[KeychainWrapper.standard.string(forKey: "year") ?? ""] as? NSDictionary else {
            print("caccon get brand array")
            return false
        }
        let myAnalyticsObject = RegistrationAnalytics(json: myAnalytics)
        try? realm.write {
            realm.add(myAnalyticsObject)
           
        }
        
      return true
    }
    
    private func _saveExpensesAnalytics(_ myAnalyticsData: NSDictionary) -> Bool{
        guard let realm = RealmManager.shared.getBackgroundRealm() else {
            return false
        }
        guard let myAnalytics = myAnalyticsData[KeychainWrapper.standard.string(forKey: "year") ?? ""] as? NSDictionary else {
            print("caccon get brand array")
            return false
        }
        let myAnalyticsObject = ExpensesAnalytics(json: myAnalytics)
        try? realm.write {
            realm.add(myAnalyticsObject)
           
        }
        
      return true
    }
    
    private func _saveGlobalProgramAnalytics (_ brandData: [GlobalProgramAnalytics]?) -> Bool {
        guard let realm = RealmManager.shared.getBackgroundRealm() else {
            return false
        }
        
       
        var globalProgram = [GlobalProgramAnalytics]()
        globalProgram = brandData ?? []
       
                try? realm.write {
                    realm.add(globalProgram)
                  
                }
        return true
    }
    
    private func _saveGlobalRegistrationAnalytics (_ globalRegistration: [GlobalRegistrationAnalytics]?) -> Bool {
        guard let realm = RealmManager.shared.getBackgroundRealm() else {
            return false
        }
        
                try? realm.write {
                    realm.add(globalRegistration ?? [])
                  
                }
        return true
    }
    
    private func _loadProgramAttendees (_ programs: [NSDictionary], completion: @escaping (Result<(), Error>) -> Void) {
        
        guard let apiToken = KeychainWrapper.standard.string(forKey: .apiToken) else {
            completion(.failure(APIManagerError.notAuthorised))
            return
        }
        
        let group = DispatchGroup()
        let syncQueue = DispatchQueue(label: "synchronise.queue")

        var programsResult = [NSDictionary]()
        var errors = [Error]()
        
        for item in programs {
            guard let programId = item["id"] as? Int else {
                continue
            }
            let idString = "\(programId)"
            guard let url = URL(string: _baseURL + _pathSyncPrograms + "/" + idString) else {
                continue
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
            
            
            group.enter()
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                defer {
                    group.leave()
                }

                //-1009 no internat
                if let error = error {

                    syncQueue.sync {
                        errors.append(error)
                    }
                    
                    return
                }
                
                guard let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 else {

                    syncQueue.sync {
                        errors.append(APIManagerError.notAuthorised)
                    }
                    
                    return
                }
                
                guard let data = data else {

                    syncQueue.sync {
                        errors.append(APIManagerError.internalError)
                    }
                    
                    return
                }

                do {
                    //let jsonString = String(data: data, encoding: .utf8)
                    //print("got attendees: \(jsonString)")
                    if let jsonResult = try JSONSerialization.jsonObject(with: data, options: [.allowFragments, JSONSerialization.ReadingOptions.mutableContainers]) as? NSDictionary {
                        
                        syncQueue.sync {
                            programsResult.append(jsonResult)
                        }
                        
                        //print("got attendees: \(jsonResult)")
                        
                    }
                    else {

                        syncQueue.sync {
                            errors.append(APIManagerError.internalError)
                        }
                        
                    }
                } catch {

                    syncQueue.sync {
                        errors.append(APIManagerError.internalError)
                    }
                    
                }
                
            }
            task.resume()
            
        }
        group.notify(queue: syncQueue) { [weak self] in
            guard let strongSlf = self else {
                DispatchQueue.main.async {
                    completion(.failure(APIManagerError.internalError))
                }
                return
            }
            if programsResult.count > 0 {
                let saved = strongSlf._savePrograms(programsResult)
                DispatchQueue.main.async {
                    if saved {
                        completion(.success(()))
                    }
                    else {
                        completion(.failure(APIManagerError.internalError))
                    }

                }
            }
            else if let lastError = errors.last {
                DispatchQueue.main.async {
                    completion(.failure(lastError))
                }
            }
            else {
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            }
        }
        
    }
    
    private func _savePrograms (_ programs: [NSDictionary]) -> Bool {
        guard let realm = RealmManager.shared.getBackgroundRealm() else {
            return false
        }
        
        for item in programs {
            let program = Program(json: item)
            
            if let array = item["registrations"] as? NSArray {
                for regs in array {
                    if let regsDict = regs as? NSDictionary {
                        let attendee = Attendee(json: regsDict)
                        program.attendees.append(attendee)
                    }
                }
            }
            if let array = item["costs"] as? NSArray {
                for regs in array {
                    if let regsDict = regs as? NSDictionary {
                        let attendee = Costs(json: regsDict)
                        program.costs.append(attendee)
                    }
                }
            }
            
            if let foundProgram = realm.objects(Program.self).filter("programId == \(program.programId)").first {
                try? realm.write {
                    foundProgram.updateProgram(withSyncedProgram: program)
                }
            }
            else {
                try? realm.write {
                    realm.add(program)
                }
            }
        }
        //print(programs)
        return true
    }
    
    private func _markAttendeesUploaded (_ attendees: [ObjectId]) {
        guard let realm = RealmManager.shared.getBackgroundRealm() else {
            return
        }
        
        for item in attendees {
            let attendee = realm.object(ofType: Attendee.self, forPrimaryKey: item)
            try? realm.write {
                attendee?.submitSubmited = true
            }
        }
    }
}


