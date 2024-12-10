//
//  OtpVC.swift
//  EventManagement
//
//  Created by meet sharma on 10/07/23.
//

import UIKit

class OtpVC: UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet private weak var btnResent: UIButton!
    @IBOutlet private weak var txtFldFourth: UITextField!
    @IBOutlet private weak var txtFldThird: UITextField!
    @IBOutlet private weak var txtFldSecond: UITextField!
    @IBOutlet private weak var txtFldFirst: UITextField!
    @IBOutlet private weak var lblEmail: UILabel!
    
    //MARK: - VARIABLE
    
    var callBack:(()->())?
    var email:String?
    var forResetPassword = false
    
    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()

      uiSet()
        
    }
    
    //MARK: - STATUSBAR STYLE
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    //MARK: - FUNCTION
    
    func uiSet(){
        
        btnResent.underline()
    }
  

    //MARK: - ACTIONS
    
    @IBAction func actionResent(_ sender: UIButton) {
        
    }
    
    @IBAction func actionSubmit(_ sender: UIButton) {
        self.dismiss(animated: false)
        self.callBack?()

        
        
    }
    
}

//MARK: - UITextFieldDelegate

extension OtpVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool {
          
        if (range.length == 0){
            if textField == txtFldFirst {
                txtFldSecond?.becomeFirstResponder()
            }
            if textField == txtFldSecond {
                txtFldThird?.becomeFirstResponder()
            }
            if textField == txtFldThird {
                txtFldFourth?.becomeFirstResponder()
            }
            if textField == txtFldFourth {
                txtFldFourth?.resignFirstResponder()
            }
            textField.text? = string
            return false
        }else if (range.length == 1) {
                if textField == txtFldFourth {
                    txtFldThird?.becomeFirstResponder()
                }
                if textField == txtFldThird {
                    txtFldSecond?.becomeFirstResponder()
                }
                if textField == txtFldSecond {
                    txtFldFirst?.becomeFirstResponder()
                }
                if textField == txtFldFirst {
                    txtFldFirst?.resignFirstResponder()
                }
           
                textField.text? = ""
                return false
        }
        return true
        }
}
