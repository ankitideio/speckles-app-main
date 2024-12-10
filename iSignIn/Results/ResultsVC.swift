//
//  ResultsVC.swift
//  EventManagement
//
//  Created by meet sharma on 04/07/23.
//

import UIKit
import SwiftKeychainWrapper

class ResultsVC: UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet private weak var tblVwResults: UITableView!
    @IBOutlet weak var viewActivityIndicator: UIActivityIndicatorView!
    
    //MARK: - OUTLETS
    
     var currentProgram: Program!
     var serchParam:[String:String]?
     private var _searchResults = [Attendee]()
     private var _searchRunning = false
     private var _selectedAttendee: Attendee?
     private var arrSearchSpeakers = [Speakers]()
     var isCommingFor:String?
     var currentPage = 1
     var totalPageCount:Int?
     var arrLocations = [Locations]()
     var _currentProgram:Program?
    
    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiData()
    }
    
    //MARK: - FUNTIONS
    
    private func uiData(){
        viewActivityIndicator.stopAnimating()
         resultList()
        tblVwResults.estimatedRowHeight = 200
        tblVwResults.rowHeight = UITableView.automaticDimension
    }
    
    func searchLocations(){
       
        APIManager.shared.searchLocations(locationName: serchParam?["label"] as? String ?? "", type: serchParam?["scopes"] as? String ?? "", page: "\(currentPage)", city: serchParam?["city"] as? String ?? "", state: serchParam?["state"] as? String ?? "") { [weak self] result,page  in
             print("Total PAge: \(page)")
            guard let strongSlf = self else {
                return
            }
            
            
            
            switch result {
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                alert.preferredAction = alert.actions.last
                strongSlf.present(alert, animated: true)
            case .success(let attendees):
                strongSlf.arrLocations.append(contentsOf: attendees)
            }
            strongSlf.tblVwResults.reloadData()
            strongSlf.viewActivityIndicator.stopAnimating()
        }
    }
    private func resultList(){
        
        viewActivityIndicator.startAnimating()
        if isCommingFor == "searchSpeakar"{
            APIManager.shared.searchSpeakars(firstName:  serchParam?["firstName"] ?? "", lastName: serchParam?["lastName"] ?? "", npi: serchParam?["npi"] ?? "", degree: serchParam?["degree"] ?? "0", speciality: serchParam?["specialty"] ?? "0") { [weak self] result in
                
                guard let strongSlf = self else {
                    return
                }
                
                strongSlf.arrSearchSpeakers.removeAll()
                
                switch result {
                case .failure(let error):
                    let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    alert.preferredAction = alert.actions.last
                    strongSlf.present(alert, animated: true)
                case .success(let attendees):
                    strongSlf.arrSearchSpeakers.append(contentsOf: attendees)
                }
                strongSlf.tblVwResults.reloadData()
                strongSlf.viewActivityIndicator.stopAnimating()
            }
            
        }else if isCommingFor == "Search Location"{
            arrLocations.removeAll()
            searchLocations()
        }else{
            
            APIManager.shared.searchAttendees(firstName: serchParam?["firstName"] as? String ?? "", lastName: serchParam?["lastName"] as? String ?? "", npi: serchParam?["npi"] as? String ?? "", city: serchParam?["city"] as? String ?? "", state: serchParam?["state"] as? String ?? "") { [weak self] result in
                
                guard let strongSlf = self else {
                    return
                }
                
                strongSlf._searchResults.removeAll()
                
                switch result {
                case .failure(let error):
                    let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    alert.preferredAction = alert.actions.last
                    strongSlf.present(alert, animated: true)
                case .success(let attendees):
                    strongSlf._searchResults.append(contentsOf: attendees)
                }
                strongSlf.tblVwResults.reloadData()
                strongSlf.viewActivityIndicator.stopAnimating()
            }
        }
        
    }
    //MARK: - ACTIONS
    
    @IBAction func actionBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionClearResult(_ sender: UIButton) {
        
    }
    
}

//MARK: - TABLEVIEW DELEGATE AND DATASOURCE

extension ResultsVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isCommingFor == "searchSpeakar"{
            return arrSearchSpeakers.count
        }else if isCommingFor == "Search Location"{
            return arrLocations.count
        }else{
            return _searchResults.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsTVC", for: indexPath) as! ResultsTVC
        cell.vwDetail.layer.cornerRadius = 10
        cell.vwDetail.dropShadow2(cornerRadius: 10)
        cell.vwDetail.layer.shadowColor = UIColor.black.cgColor
        cell.vwDetail.layer.shadowOpacity = 0.2
        cell.vwDetail.layer.shadowOffset = CGSize.zero
        cell.vwDetail.layer.shadowRadius = 5
        cell.btnLearnMore.addTarget(self, action: #selector(add), for: .touchUpInside)
        cell.btnLearnMore.tag = indexPath.row
        if isCommingFor == "searchSpeakar"{
            
            let speakers = arrSearchSpeakers[indexPath.row]
            
            cell.lblFirstName.text = speakers.first_name
            cell.lblLastName.text = speakers.last_name
            let degree = speakers.degree.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            cell.lblDegree.text = degree
            cell.lblCityState.text = speakers.specialty
            cell.lblNPI.text = speakers.NPI
            cell.lblCityTitle.text = "Specialty:"
            
        }else if isCommingFor == "Search Location"{
            
            
            let locations = arrLocations[indexPath.row]

            if locations.location_name != ""{
                cell.lblFirstName.text =  locations.location_name
            }else{
                cell.lblFirstName.text =  locations.address_line
            }
            cell.lblFirstNameTitle.text  = "Location:"
            cell.lblLastNameTitle.text = "Type:"
            cell.lblLastName.text = locations.address_type
            cell.lblCityState.text = locations.city_state
            cell.vwNPI.isHidden = true
            cell.vwDegree.isHidden = true
            
        }else{
            let attendee = _searchResults[indexPath.row]
            
            cell.lblFirstName.text = attendee.firstName
            cell.lblLastName.text = attendee.lastName
            let degree = attendee.degree.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            cell.lblDegree.text = degree
            
            var cityState = attendee.city
            let state = attendee.stateProvince
            if !cityState.isEmpty && !state.isEmpty {
                cityState += ", " + state
            }
            else if !state.isEmpty {
                cityState += state
            }
            cell.lblCityState.text = cityState
            
            cell.lblNPI.text = attendee.npi
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isCommingFor == "Search Location"{
           
                let lastItem = self.arrLocations.count - 1
                if indexPath.row == lastItem {
                    if  currentPage > totalPageCount ?? 0{
                        currentPage += 1
                        searchLocations()
                    }
                }
            
            
        }
    }
    @objc func add(sender:UIButton){
        
       
            if isCommingFor == "searchSpeakar"{
                KeychainWrapper.standard.set("\(arrSearchSpeakers[sender.tag].specId)", forKey: KeychainWrapper.Key.speakerID.rawValue)
                KeychainWrapper.standard.set("\(arrSearchSpeakers[sender.tag].preferred_name)", forKey: KeychainWrapper.Key.speakerName.rawValue)
                for controller in self.navigationController!.viewControllers {
                         if controller is CreateEventVC {
                             self.navigationController!.popToViewController(controller, animated: true)
                             break
                         }
                   }
            }else if isCommingFor == "Search Location"{
                KeychainWrapper.standard.set("\(arrLocations[sender.tag].id)", forKey: KeychainWrapper.Key.locationID.rawValue)
                if arrLocations[sender.tag].location_name != ""{
                    KeychainWrapper.standard.set("\(arrLocations[sender.tag].location_name)", forKey: KeychainWrapper.Key.locationName.rawValue)
                }else{
                    KeychainWrapper.standard.set("\(arrLocations[sender.tag].address_line)", forKey: KeychainWrapper.Key.locationName.rawValue)
                }
                for controller in self.navigationController!.viewControllers {
                         if controller is CreateEventVC {
                             self.navigationController!.popToViewController(controller, animated: true)
                             break
                         }
                   }
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateRegistrationVC") as! CreateRegistrationVC
                if isCommingFor != "searchSpeakar"{
                    self._selectedAttendee = _searchResults[sender.tag]

                    vc._searchResults = _selectedAttendee
                    vc.programId = _currentProgram?.programId ?? 0
                    
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }

    }
}
