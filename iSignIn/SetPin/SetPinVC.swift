//
//  SetPinVC.swift
//  EventManagement
//
//  Created by meet sharma on 05/07/23.
//

import UIKit

class SetPinVC: UIViewController {
    
   //MARK: - OUTLETS
    
    @IBOutlet private weak var vwSetPin: UIView!
    @IBOutlet private weak var txtFldConfirmFourthDigit: UITextField!
    @IBOutlet private weak var txtFldConfirmThirdDigit: UITextField!
    @IBOutlet private weak var txtFldConfirmSecondDigit: UITextField!
    @IBOutlet private weak var txtFldConfirmFirstDigit: UITextField!
    @IBOutlet private weak var txtFldNewFourthDigit: UITextField!
    @IBOutlet private weak var txtFldNewThirdDigit: UITextField!
    @IBOutlet private weak var txtFldNewSecondDigit: UITextField!
    @IBOutlet private weak var txtFldNewFirstDiigit: UITextField!
    
    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uiData()
    }
    
    //MARK: - FUNCTION
    
    private func uiData(){
        
        vwSetPin.dropShadow2(cornerRadius: 10)
    }
    
    //MARK: - ACTIONS
    
    @IBAction func actionBackBtn(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSetPin(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    

}
//MARK: - UITextFieldDelegate
extension SetPinVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool {
          
        if (range.length == 0){
            if textField == txtFldNewFirstDiigit {
                txtFldNewSecondDigit?.becomeFirstResponder()
                
            }
            if textField == txtFldNewSecondDigit {
                txtFldNewThirdDigit?.becomeFirstResponder()
            }
            if textField == txtFldNewThirdDigit {
                txtFldNewFourthDigit?.becomeFirstResponder()
            }
            if textField == txtFldNewFourthDigit {
                txtFldNewFourthDigit?.resignFirstResponder()
            }
            textField.text? = string
            if textField == txtFldConfirmFirstDigit {
                txtFldConfirmSecondDigit?.becomeFirstResponder()
                
            }
            if textField == txtFldConfirmSecondDigit {
                txtFldConfirmThirdDigit?.becomeFirstResponder()
            }
            if textField == txtFldConfirmThirdDigit {
                txtFldConfirmFourthDigit?.becomeFirstResponder()
            }
            if textField == txtFldConfirmFourthDigit {
                txtFldNewFourthDigit?.resignFirstResponder()
             
            }
            textField.text? = string
            return false
        }else if (range.length == 1) {
                if textField == txtFldNewFourthDigit {
                    txtFldNewThirdDigit?.becomeFirstResponder()
                }
                if textField == txtFldNewThirdDigit {
                    txtFldNewSecondDigit?.becomeFirstResponder()
                }
                if textField == txtFldNewSecondDigit {
                    txtFldNewFirstDiigit?.becomeFirstResponder()
                }
                if textField == txtFldNewFirstDiigit {
                    txtFldNewFirstDiigit?.resignFirstResponder()
                }
            if textField == txtFldConfirmFourthDigit {
                txtFldConfirmThirdDigit?.becomeFirstResponder()
            }
            if textField == txtFldConfirmThirdDigit {
                txtFldConfirmSecondDigit?.becomeFirstResponder()
            }
            if textField == txtFldConfirmSecondDigit {
                txtFldConfirmFirstDigit?.becomeFirstResponder()
            }
            if textField == txtFldConfirmFirstDigit {
                txtFldConfirmFirstDigit?.resignFirstResponder()
            }
                textField.text? = ""
                return false
        }
        return true
        }
}
