//
//  HomeVC.swift
//  EventManagement
//
//  Created by meet sharma on 04/07/23.
//

import UIKit
import RealmSwift
import SwiftKeychainWrapper

class EventListVC: UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet private weak var tblVwEvents: UITableView!
    @IBOutlet private weak var viewActivityIndicator: UIActivityIndicatorView!
    
    //MARK: - VARIABLES

    private var _syncInProgress = false
    private var _selectedProgram: Program?
    private var _realmToken: NotificationToken?
    private var _programs: Results<Program>?
    
    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiData()
    }

    //MARK: - FUNCTIONS
    
    private func uiData(){
        
        viewActivityIndicator.isHidden = true
       // let startofToday = Calendar.current.startOfDay(for: Date()) as NSDate
        _programs = RealmManager.shared.getMainRealm()?.objects(Program.self).sorted(byKeyPath: "programId", ascending: false)
        _realmToken = _programs?.observe { [weak self] changes in
            guard let strongSlf = self else {
                return
            }
           
            strongSlf.tblVwEvents.reloadData()
        }
    }
    
    deinit {
        _realmToken?.invalidate()
        _realmToken = nil
    }
    
    //MARK: - ACTIONS
    
    @IBAction func actionAddBtn(_ sender: UIButton) {
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateEventVC") as? CreateEventVC {
            if let navigator = navigationController {
                viewController.hidesBottomBarWhenPushed = false
                navigator.pushViewController(viewController, animated: false)
            }
        }
    }
    
}
//MARK: - TABLEVIEW DELEGATE AND DATA SOURCE

extension EventListVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _syncInProgress ? 0 : _programs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventListTVC", for: indexPath) as! EventListTVC
        if indexPath.row % 3 == 0{
              cell.vwBackground.backgroundColor = UIColor(hexString: "#FFF3EC")
            }else if indexPath.row % 3 == 1{
              cell.vwBackground.backgroundColor = UIColor(hexString:"#ECFFFC")
            }else if indexPath.row % 3 == 2{
              cell.vwBackground.backgroundColor = UIColor(hexString:"#EEF3FF")
            }
        cell.btnSeeMore.addTarget(self, action: #selector(seeMore), for: .touchUpInside)
        cell.btnSeeMore.tag = indexPath.row
        let program = _programs?[indexPath.row]
        cell.lblEventName.text = program?.title
        let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        let dateString = dateFormatter.string(from: program?.startDate ?? Date())
        cell.lblEventDate.text = dateString
        cell.imgVwEvent.imageLoad(imageUrl: program?.program_image_download ?? "")
        
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventDetailVC") as? EventDetailVC {
            if let navigator = navigationController {
                viewController.hidesBottomBarWhenPushed = false
                _selectedProgram =  _programs?[indexPath.row]
                viewController.currentProgram = _selectedProgram
                navigator.pushViewController(viewController, animated: false)
            }
        }
    }
    @objc func seeMore(sender:UIButton){
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventDetailVC") as? EventDetailVC {
            if let navigator = navigationController {
                viewController.hidesBottomBarWhenPushed = false
                _selectedProgram =  _programs?[sender.tag]
                viewController.currentProgram = _selectedProgram
                navigator.pushViewController(viewController, animated: false)
            }
        }

    }
}
