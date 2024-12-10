//
//  CostPopUpVC.swift
//  iSignIn
//
//  Created by meet sharma on 26/07/23.
//

import UIKit

class CostPopUpVC: UIViewController {

    //MARK: - OUTLETS
    
    @IBOutlet private weak var tblVwCostList: UITableView!
    
    //MARK: - VARIABLES
    
    private var selectIndex = -1
    private var arrHeader = ["AV","Travel","Invitations","FB","Honorarium","Miscellaneous"]
    private var arrAV = [CostListItem]()
    private var arrTravelList = [TravelCostList]()
    private var arrInvitaion = [InvitationCostList]()
    private var arrFB = [FBCostList]()
    private var arrHonorarium = [HonorariumCostList]()
    private var arrMiscellaneous = [MiscellaneousCostList]()
    var callBack:((_ costId:Int,_ itemName:String)->())?
    
    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uiset()
     }
     
     func uiset(){
         if let realm = RealmManager.shared.getMainRealm() {
             let objects = realm.objects(CostListItem.self)
             for i in objects{
                 self.arrAV.append(i)
             }
         }
         print(arrAV.count)
         if let realm = RealmManager.shared.getMainRealm() {
             let objects = realm.objects(TravelCostList.self)
             for i in objects{
                 self.arrTravelList.append(i)
             }
         }
         print(arrTravelList.count)
         if let realm = RealmManager.shared.getMainRealm() {
             let objects = realm.objects(InvitationCostList.self)
             for i in objects{
                 self.arrInvitaion.append(i)
             }
         }
         print(arrInvitaion.count)
         if let realm = RealmManager.shared.getMainRealm() {
             let objects = realm.objects(FBCostList.self)
             for i in objects{
                 self.arrFB.append(i)
             }
         }
         print(arrFB.count)
         if let realm = RealmManager.shared.getMainRealm() {
             let objects = realm.objects(HonorariumCostList.self)
             for i in objects{
                 self.arrHonorarium.append(i)
             }
         }
         print(arrHonorarium.count)
         if let realm = RealmManager.shared.getMainRealm() {
             let objects = realm.objects(MiscellaneousCostList.self)
             for i in objects{
                 self.arrMiscellaneous.append(i)
             }
         }
         print(arrMiscellaneous.count)
     }
    

 }

 extension CostPopUpVC: UITableViewDelegate,UITableViewDataSource{
      
     func numberOfSections(in tableView: UITableView) -> Int {
         return arrHeader.count
     }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if section == 0 {
             return arrAV.count
         }else if section == 1{
             return arrTravelList.count
         }else if section == 2{
             return arrInvitaion.count
         }else if section == 3{
             return arrFB.count
         }else if section == 4{
             return arrHonorarium.count
         }else{
             return arrMiscellaneous.count
         }
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             let cell = tableView.dequeueReusableCell(withIdentifier: "CostListTVC") as!  CostListTVC
         if indexPath.section == 0 {
             cell.lblCost.text = arrAV[indexPath.row].label
         }else if indexPath.section == 1{
             cell.lblCost.text = arrTravelList[indexPath.row].label
         }else if indexPath.section == 2{
             cell.lblCost.text = arrInvitaion[indexPath.row].label
         }else if indexPath.section == 3{
             cell.lblCost.text = arrFB[indexPath.row].label
         }else if indexPath.section == 4{
             cell.lblCost.text = arrHonorarium[indexPath.row].label
         }else{
             cell.lblCost.text = arrMiscellaneous[indexPath.row].label
         }
    
             return cell
         }
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         let header = tableView.dequeueReusableCell(withIdentifier: "CostHeaderTVC") as!  CostHeaderTVC
        header.btnHeader.setTitle(arrHeader[section], for: .normal)

         return header
     }
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return 50
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 40
         }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         dismiss(animated: true)
         if indexPath.section == 0 {
             callBack?(arrAV[indexPath.row].costId, arrAV[indexPath.row].label)
         }else if indexPath.section == 1{
             callBack?(arrTravelList[indexPath.row].costId, arrTravelList[indexPath.row].label)
         }else if indexPath.section == 2{
             callBack?(arrInvitaion[indexPath.row].costId, arrInvitaion[indexPath.row].label)
         }else if indexPath.section == 3{
             callBack?(arrFB[indexPath.row].costId, arrFB[indexPath.row].label)
         }else if indexPath.section == 4{
             callBack?(arrHonorarium[indexPath.row].costId, arrHonorarium[indexPath.row].label)
         }else{
             callBack?(arrMiscellaneous[indexPath.row].costId, arrMiscellaneous[indexPath.row].label)
         }
     }
     }

