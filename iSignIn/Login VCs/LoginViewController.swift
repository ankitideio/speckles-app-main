//
//  LoginViewController.swift
//  iSignIn
//
//  Created by Dmitrij on 2022-12-26.
//

import UIKit
import SwiftKeychainWrapper

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var buttonEye: UIButton!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private var _validationStarted = false

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        activityIndicator.stopAnimating()
        let date = DateFormatter()
        date.dateFormat = "yyyy"
     
    }
    //MARK: - STATUSBAR STYLE
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Actions
    
    @IBAction func loginAction(_ sender: Any) {
        guard _validateData(withAlert: true) else {
            _validationStarted = true
            return
        }
        
        _setViewLoading()
        let username = textFieldEmail.text ?? ""
        let password = textFieldPassword.text ?? ""
        //username = "testfield@flssol.com"
        //password = "Welcome"
      
        
        APIManager.shared.loginWith(username: username, password: password) { [weak self] result in
            switch result {
            case .success():
           
                let delegate = UIApplication.shared.delegate as? AppDelegate
                delegate?.changeStoryboard()
                print("Success")
            case .failure(let error):
                //show error message
                guard let strongSlf = self else {
                    return
                }
                strongSlf._setViewNotLoading()
                strongSlf._showValidationAlert(message: "Cannot login. \(error.localizedDescription)")
                strongSlf._validationStarted = true
            }
        }
        
    }
    
    @IBAction func actionRegister(_ sender: UIButton) {
       
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func actionForgotPassword(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        vc.callBack = {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtpVC") as! OtpVC
            vc.callBack = {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            vc.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(vc, animated: false)
        }
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: false)
        
    }
    
 
    
    @IBAction func actionPasswordHideShow(_ sender: UIButton) {
       
        if sender.isSelected{
        buttonEye.setImage(UIImage(named: "eye"), for: .normal)
        textFieldPassword.isSecureTextEntry = true
        }else{
        buttonEye.setImage(UIImage(named: "openEye"), for: .normal)
        textFieldPassword.isSecureTextEntry = false
        }
        sender.isSelected = !sender.isSelected
        
    }
    //MARK: - Methods
    
    private func _validateData (withAlert: Bool) -> Bool {
        let email = textFieldEmail.text ?? ""
        let password = textFieldPassword.text ?? ""
        guard !email.isEmpty else {
            let emailErrorText = "Email cannot be empty"
            if withAlert {
                _showValidationAlert(message: emailErrorText)
            }
            return false
        }
        guard !password.isEmpty else {
            let passwordErrorText = "Password cannot be empty"
            if withAlert {
                _showValidationAlert(message: passwordErrorText)
            }
            return false
        }
        return true
    }
    
    private func _showValidationAlert (message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        alert.preferredAction = alert.actions.last
        present(alert, animated: true)
    }
    
    private func _setViewLoading () {
        view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        buttonLogin.alpha = 0.5
    }
    
    private func _setViewNotLoading () {
        view.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
        buttonLogin.alpha = 1.0
    }
    
   
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldEmail {
            textFieldPassword.becomeFirstResponder()
        }
        else if textField == textFieldPassword {
            if !(textFieldEmail.text ?? "").isEmpty && !(textFieldPassword.text ?? "").isEmpty {
                DispatchQueue.main.async {
                    self.loginAction(self)
                }
            }
            textField.resignFirstResponder()
            return true
        }
        
        return false
    }
    
    @IBAction func textFieldDidChange(_ textfield: UITextField) {
        if _validationStarted {
            if _validateData(withAlert: false) {
                _validationStarted = false
            }
        }
    }

}
