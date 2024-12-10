//
//  SignUpVC.swift
//  EventManagement
//
//  Created by meet sharma on 10/07/23.
//

import UIKit

class SignUpVC: UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet private weak var btnConfirmPasswordEye: UIButton!
    @IBOutlet private weak var btnPasswordEye: UIButton!
    @IBOutlet private weak var txtFldConfirmPassword: UITextField!
    @IBOutlet private weak var txtFldPassword: UITextField!
    @IBOutlet private weak var txtFldPhoneNumber: UITextField!
    @IBOutlet private weak var txtFldEmail: UITextField!
    @IBOutlet private weak var txtFldFullName: UITextField!
    
    //MARK: - VARIABLES
    
    var userId = ""
    
    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    //MARK: - STATUSBAR STYLE
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    
    //MARK: - ACTIONS
    
    @IBAction func actionSignUp(_ sender: UIButton) {
     
    }
    
    @IBAction func actionLogin(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionPasswordEye(_ sender: UIButton) {
       
        if sender.isSelected{
            btnPasswordEye.setImage(UIImage(named: "Eye Closed"), for: .normal)
            txtFldPassword.isSecureTextEntry = true
        }else{
            btnPasswordEye.setImage(UIImage(named: "openEye"), for: .normal)
            txtFldPassword.isSecureTextEntry = false
        }
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func actionConfirmPasswordEye(_ sender: UIButton) {
        
        if sender.isSelected{
            btnConfirmPasswordEye.setImage(UIImage(named: "Eye Closed"), for: .normal)
            txtFldConfirmPassword.isSecureTextEntry = true
        }else{
            btnConfirmPasswordEye.setImage(UIImage(named: "openEye"), for: .normal)
            txtFldConfirmPassword.isSecureTextEntry = false
        }
        sender.isSelected = !sender.isSelected
    }
}
