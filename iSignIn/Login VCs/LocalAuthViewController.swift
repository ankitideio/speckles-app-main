//
//  LocalAuthViewController.swift
//  iSignIn
//
//  Created by Dmitrij on 2022-12-29.
//

import UIKit
import LocalAuthentication
import SwiftKeychainWrapper

class LocalAuthViewController: UIViewController, EnterPasscodeViewControllerDelegate {
    
    @IBOutlet weak var buttonLogout: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        buttonLogout.isHidden = true
        view.backgroundColor = .mainNavigationBarColor()
        
        let biometricsEnabled = !(KeychainWrapper.standard.string(forKey: .applicationBiometricsEnabled) ?? "").isEmpty
        
        guard biometricsEnabled else {
            _showPasscode()
            return
        }
        
         let context = LAContext()
         var error: NSError?
         guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
             _showPasscode()
             return
         }
         
         Task {
             do {
                 try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Log in to your account")
                 dismiss(animated: true)
             } catch {
                 _showPasscode()
             }
         }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "OpenPasscode" {
            let destination = segue.topLevelDestinationViewController() as? EnterPasscodeViewController
            destination?.controllerState = .validatePasscode
            destination?.delegate = self
        }
    }
    
    
    //MARK: - Actions
    
    @IBAction func closeAction () {
        APIManager.shared.logout()
    }
    
    private func _showPasscode () {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.performSegue(withIdentifier: "OpenPasscode", sender: nil)
        }
    }
    
    //MARK: - EnterPasscodeViewControllerDelegate
    
    func passcodeValidatedWithResult(_ result: Bool) {
        if result {
            presentingViewController?.dismiss(animated: true)
        }
    }

}
