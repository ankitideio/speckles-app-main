//
//  ForgotPasswordVC.swift
//  EventManagement
//
//  Created by meet sharma on 10/07/23.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    //MARK: - OUTLET
    
    @IBOutlet private weak var txtFldEmail: UITextField!
    
    //MARK: - VARIABLE
    
    var callBack:(()->())?
    
    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    //MARK: - STATUSBAR STYLE
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    
    //MARK: - ACTIONS
    
    @IBAction func actionSendEmail(_ sender: UIButton) {
        self.dismiss(animated: false)
        self.callBack?()

    }
    
    @IBAction func actionLogin(_ sender: UIButton) {
        
        dismiss(animated: false)
        
    }
    
}
