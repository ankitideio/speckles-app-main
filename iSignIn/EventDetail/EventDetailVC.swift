//
//  EventDetailVC.swift
//  EventManagement
//
//  Created by meet sharma on 04/07/23.
//

import UIKit
import SwiftKeychainWrapper
class EventDetailVC: UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet private weak var btnUpload: UIButton!
    @IBOutlet private weak var scrollVw: UIScrollView!
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var vwRegistration: UIView!
    @IBOutlet weak var imgVwPlus: UIImageView!
    
    
    
    //MARK: - VARIABLES
    var currentProgram: Program?
    
    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let EventDetail: SelectEventDetailVC = self.children[0] as!SelectEventDetailVC
        EventDetail.currentProgram = currentProgram
        let RegistrationList: RegistrationVC = self.children[1] as!RegistrationVC
        RegistrationList.currentProgram = currentProgram
        KeychainWrapper.standard.set(currentProgram?.qr_code_download ?? "", forKey: KeychainWrapper.Key.qrCode.rawValue)
        NotificationCenter.default.post(name: Notification.Name("FetchCurrentProgram"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("FetchCurrentRegistration"), object: nil)
        uiData()
        
    }
    
    //MARK: - FUNCTIONS
    
    private func uiData(){
      
       self.vwRegistration.isHidden = true
        self.segmentControl.layer.cornerRadius = 8
        self.segmentControl.selectedSegmentIndex = 0
        self.segmentControl.selectedSegmentTintColor = UIColor(red: 243/255, green: 118/255, blue: 43/255, alpha: 1.0)
        self.segmentControl.layer.backgroundColor = UIColor(red: 249/255, green: 251/255, blue: 255/255, alpha: 1.0).cgColor
        let selectSegmentColor = [NSAttributedString.Key.font:UIFont(name: "Lato-Bold", size: 14),NSAttributedString.Key.foregroundColor: UIColor.white]
        let unSelectSegmentColor = [NSAttributedString.Key.font:UIFont(name: "Lato-Bold", size: 14),NSAttributedString.Key.foregroundColor: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)]
        segmentControl.setTitleTextAttributes(unSelectSegmentColor as [NSAttributedString.Key : Any], for: .normal)
        segmentControl.setTitleTextAttributes(selectSegmentColor as [NSAttributedString.Key : Any], for: .selected)
        segmentControl.addTarget(self, action: #selector(selectTab), for: .valueChanged)
    }
    
    @objc private func selectTab(sender:UISegmentedControl){
        
        if sender.selectedSegmentIndex == 0{
            self.vwRegistration.isHidden = true
            scrollVw.setContentOffset(.zero, animated: true)
            scrollVw.setContentOffset(CGPoint(x: scrollVw.frame.size.width*0, y: 0), animated: true)
        }else{
            self.vwRegistration.isHidden = false
            scrollVw.setContentOffset(.zero, animated: true)
            scrollVw.setContentOffset(CGPoint(x: scrollVw.frame.size.width*1, y: 0), animated: true)
        }
        
    }
    
    //MARK: - ACTIONS
    
    @IBAction func actionBack(_ sender: UIButton) {
        KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.qrCode.rawValue)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionUpload(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExpenseListVC") as! ExpenseListVC
        vc.currentProgram = currentProgram
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionRegister(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateRegistrationVC") as! CreateRegistrationVC
        vc.programId = currentProgram?.programId ?? 0
        vc.isCreate = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
