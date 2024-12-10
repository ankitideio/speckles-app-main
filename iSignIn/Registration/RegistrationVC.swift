//
//  RegistrationVC.swift
//  EventManagement
//
//  Created by meet sharma on 04/07/23.
//

import UIKit
import RealmSwift
import SwiftKeychainWrapper

class RegistrationVC: UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet private weak var heightTblVw: NSLayoutConstraint!
    @IBOutlet private weak var imgVwQRCode: UIImageView!
    @IBOutlet private weak var viewActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var txtFldSearch: UITextField!
    @IBOutlet private weak var tblVwRegistration: UITableView!
    
    //MARK: - VARIABLES
    
    var currentProgram: Program?
    private var _attendeeList: Results<Attendee>?
    private var _notificationtoken: NotificationToken?
    private var programId = 0

    
    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("FetchCurrentRegistration"), object: nil)
        
       
        
        print(currentProgram?.qr_code_download ?? "")
        
        _attendeeList = currentProgram?.attendees.sorted(by: [SortDescriptor(keyPath: "submitSubmited", ascending: true), SortDescriptor(keyPath: "submitStatus", ascending: true), SortDescriptor(keyPath: "firstName", ascending: true), SortDescriptor(keyPath: "lastName", ascending: true)])
        _notificationtoken = _attendeeList?.observe { [weak self] changes in
              guard let strongSlf = self else {
                return
              }
              
                strongSlf.heightTblVw.constant = CGFloat((strongSlf.currentProgram?.attendees.count ?? 0)*130)
                strongSlf.tblVwRegistration.reloadData()
                strongSlf.viewActivityIndicator.isHidden = true
            }
     
        
    }
    
    
    //MARK: - FUNCTION
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        
        self.imgVwQRCode.imageLoad(imageUrl: KeychainWrapper.standard.string(forKey: .qrCode) ?? "")
        
    }
   
    //MARK: - ACTIONS
    
    @IBAction func actionSearch(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
            vc.isComing = "Search"
        vc._currentProgram = currentProgram
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionScanID(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScannerVC") as! ScannerVC
        vc.isComing = false
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true)
    }
}

//MARK: - TABLEVIEW DELEGATE AND DATASOURCE

extension RegistrationVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  currentProgram?.attendees.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationTVC", for: indexPath) as! RegistrationTVC
       
        cell.vwDetail.layer.cornerRadius = 10
        cell.vwDetail.layer.shadowColor = UIColor.black.cgColor
        cell.vwDetail.layer.shadowOpacity = 0.2
        cell.vwDetail.layer.shadowOffset = CGSize.zero
        cell.vwDetail.layer.shadowRadius = 5
        cell.lblName.text = "\(currentProgram?.attendees[indexPath.row].firstName ?? "") \(currentProgram?.attendees[indexPath.row].lastName ?? "")"
        if currentProgram?.attendees[indexPath.row].suffix ?? "" != ""{
            cell.lblStatus.text = "(\(currentProgram?.attendees[indexPath.row].suffix ?? ""))"
        }else{
            cell.lblStatus.text = ""
        }
        cell.lblEmail.text = currentProgram?.attendees[indexPath.row].email ?? ""
        cell.lblPhoneNo.text = currentProgram?.attendees[indexPath.row].phone ?? ""
        cell.lblAddres.text = "\(currentProgram?.attendees[indexPath.row].city ?? ""),\(currentProgram?.attendees[indexPath.row].stateProvince ?? "")"
        heightTblVw.constant = CGFloat(tblVwRegistration.contentSize.height+80)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateRegistrationVC") as! CreateRegistrationVC
        vc._searchResults = currentProgram?.attendees[indexPath.row]
        vc.programId = currentProgram?.programId ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
      
    }
    
}

