//
//  ChangePasswordVC.swift
//  EventManagement
//
//  Created by meet sharma on 05/07/23.
//

import UIKit

class ChangePasswordVC: UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet private weak var btnEyeConfirm: UIButton!
    @IBOutlet private weak var txtFldConfirm: UITextField!
    @IBOutlet private weak var btnEyeNew: UIButton!
    @IBOutlet private weak var txtFldNew: UITextField!
    @IBOutlet private weak var btnEyeCurrent: UIButton!
    @IBOutlet private weak var txtFldCurrent: UITextField!
    
    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
    }
    
    //MARK: - ACTIONS
    
    @IBAction func actionSubmit(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func actionBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
   

}
