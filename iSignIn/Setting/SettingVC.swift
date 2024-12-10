//
//  SettingVC.swift
//  EventManagement
//
//  Created by meet sharma on 05/07/23.
//

import UIKit

class SettingVC: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet private weak var tblVwSetting: UITableView!
    
    //MARK: - VARIABLES
    
    private var arrSetting = [SettingsModel]()
    
    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uiData()
    }
    
    //MARK: - FUNTIONS
    
    private func uiData(){
        
        arrSetting.append(SettingsModel(title: "Set Pin",img: "Group 128"))
        arrSetting.append(SettingsModel(title: "Face ID",img: "2639811_face_id_icon 1"))
        arrSetting.append(SettingsModel(title: "Change Password",img: "Group 128"))
        arrSetting.append(SettingsModel(title: "Contact Us",img: "address-book-solid 1"))
        arrSetting.append(SettingsModel(title: "About us",img: "Group 131"))
        arrSetting.append(SettingsModel(title: "Terms and conditions",img: "file-lines-regular 1"))
        arrSetting.append(SettingsModel(title: "Privacy & Policy",img: "file-lines-regular 1"))
        arrSetting.append(SettingsModel(title: "Logout",img: "Vector 1"))
    }
}

//MARK: - TABLEVIEW DELEGATE AND DATASOURCE

extension SettingVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSetting.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTVC", for: indexPath) as! SettingTVC
        
        cell.lblSetting.text = arrSetting[indexPath.row].title ?? ""
        cell.imgVwSetting.image = UIImage(named: arrSetting[indexPath.row].img ?? "")
        if indexPath.row == 0{
            cell.vwSetting.backgroundColor = UIColor(hexString: "#F3762B")
        }else if indexPath.row == 1{
            cell.vwSetting.backgroundColor = UIColor(hexString: "#5DA8DD")
        }else if indexPath.row == 2{
            cell.vwSetting.backgroundColor = UIColor(hexString: "#0D1B3E")
        }else if indexPath.row == 3{
            cell.vwSetting.backgroundColor = UIColor(hexString: "#F3762B")
        }else if indexPath.row == 4{
            cell.vwSetting.backgroundColor = UIColor(hexString: "#5DA8DD")
        }else if indexPath.row == 5{
            cell.vwSetting.backgroundColor = UIColor(hexString: "#0D1B3E")
        }else if indexPath.row == 6{
            cell.vwSetting.backgroundColor = UIColor(hexString: "#F3762B")
        }else{
            cell.vwSetting.backgroundColor = UIColor(hexString: "#5DA8DD")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 73
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
            
        case 0:
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SetPinVC") as? SetPinVC {
                if let navigator = navigationController {
                    viewController.hidesBottomBarWhenPushed = false
                    navigator.pushViewController(viewController, animated: false)
                }
            }
        case 1:
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddFaceVC") as? AddFaceVC {
                if let navigator = navigationController {
                    viewController.hidesBottomBarWhenPushed = false
                    navigator.pushViewController(viewController, animated: false)
                }
            }
        case 2:
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChangePasswordVC") as? ChangePasswordVC {
                if let navigator = navigationController {
                    viewController.hidesBottomBarWhenPushed = false
                    navigator.pushViewController(viewController, animated: false)
                }
            }
        case 3:
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactUsVC") as? ContactUsVC {
                if let navigator = navigationController {
                    viewController.hidesBottomBarWhenPushed = false
                    navigator.pushViewController(viewController, animated: false)
                }
            }
        case 4:
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TermsConditionsVC") as? TermsConditionsVC {
                if let navigator = navigationController {
                    viewController.hidesBottomBarWhenPushed = false
                    viewController.isComing = "About"
                    navigator.pushViewController(viewController, animated: false)
                }
            }
          
        case 5:
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TermsConditionsVC") as? TermsConditionsVC {
                if let navigator = navigationController {
                    viewController.hidesBottomBarWhenPushed = false
                    viewController.isComing = "Term"
                    navigator.pushViewController(viewController, animated: false)
                }
            }
           
        case 6:
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TermsConditionsVC") as? TermsConditionsVC {
                if let navigator = navigationController {
                    viewController.hidesBottomBarWhenPushed = false
                    viewController.isComing = "Privacy"
                    navigator.pushViewController(viewController, animated: false)
                }
            }
        case 7:
            let vc = storyboard?.instantiateViewController(withIdentifier: "LogoutPopUpVC") as! LogoutPopUpVC
                    vc.hidesBottomBarWhenPushed = false
                    vc.modalPresentationStyle = .overFullScreen
                    self.navigationController?.present(vc, animated: true)
              
           
        default:
            print("default")
        }
    }
}
