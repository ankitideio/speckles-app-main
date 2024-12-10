//
//  LogoutPopUpVC.swift
//  EventManagement
//
//  Created by meet sharma on 05/07/23.
//

import UIKit


class LogoutPopUpVC: UIViewController {
    
    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    //MARK: - ACTIONS
    
    @IBAction func actionLogout(_ sender: UIButton) {

        APIManager.shared.logout()
        
    }
    
    @IBAction func actionCancel(_ sender: UIButton) {
        
        self.dismiss(animated: true)
    }
    
    @IBAction func actionCross(_ sender: UIButton) {

            self.dismiss(animated: true)
    }
}
