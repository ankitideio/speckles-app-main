//
//  EnterPasscodeViewController.swift
//  iSignIn
//
//  Created by Dmitrij on 2022-12-28.
//

import UIKit
import SwiftKeychainWrapper

protocol EnterPasscodeViewControllerDelegate: AnyObject {
    func passcodeValidatedWithResult(_ result: Bool)
}

class EnterPasscodeViewController: UIViewController {
    
    enum EnterPasscodeViewControllerState: Int {
        case newEnterPasscode, newReenterPasscode, validatePasscode, changeOldPasscode, changeNewPasscode, changeReenterPasscode
    }
    
    @IBOutlet weak var viewChar1: UIView!
    @IBOutlet weak var viewChar2: UIView!
    @IBOutlet weak var viewChar3: UIView!
    @IBOutlet weak var viewChar4: UIView!
    
    @IBOutlet weak var labelInfo: UILabel!
    @IBOutlet weak var viewPasscodeSecure: UIView!
    
    weak var delegate: EnterPasscodeViewControllerDelegate?
    
    private var _passcode = "" {
        didSet {
            let charViews = [viewChar1, viewChar2, viewChar3, viewChar4]
            for view in charViews {
                view?.backgroundColor = .clear
            }
            for i in 0..<_passcode.count {
                let view = charViews[i]
                view?.backgroundColor = UIColor.systemGray
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self._finishEnterPasscode()
            }
        }
    }
    
    private var _validationAttempt = 0
    
    var testPasscode = ""
    var enableBiometricsAtFinish = false
    
    var controllerState: EnterPasscodeViewControllerState = .newEnterPasscode

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        switch controllerState {
        case .newEnterPasscode:
            navigationItem.title = "Enter Passcode"
            labelInfo.text = "Enter Passcode"
        case .newReenterPasscode:
            labelInfo.text = "Reenter Passcode"
        case .validatePasscode:
            labelInfo.text = "Enter Passcode"
        case .changeOldPasscode:
            labelInfo.text = "Enter Old Passcode"
        case .changeNewPasscode:
            labelInfo.text = "Enter New Passcode"
        case .changeReenterPasscode:
            labelInfo.text = "Reenter New Passcode"
        }
        
        navigationItem.title = "Passcode"
        
        for view in [viewChar1, viewChar2, viewChar3, viewChar4] {
            _configureCharView(view!)
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Methods
    
    private func _configureCharView(_ charView: UIView) {
        charView.layer.borderWidth = 1.0
        charView.layer.borderColor = UIColor.systemGray.cgColor
        charView.backgroundColor = .clear
        
        DispatchQueue.main.async {
            charView.layer.cornerRadius = charView.bounds.height / 2.0
        }
    }
    
    private func _finishEnterPasscode() {
        guard _passcode.count == 4 else {
            return
        }
        switch controllerState {
        case .newEnterPasscode:
            if let reenterVc = storyboard?.instantiateViewController(withIdentifier: "enterPasscode") as? EnterPasscodeViewController, var viewControllers = navigationController?.viewControllers {
                reenterVc.controllerState = .newReenterPasscode
                reenterVc.testPasscode = _passcode
                reenterVc.enableBiometricsAtFinish = enableBiometricsAtFinish
                viewControllers.removeLast()
                viewControllers.append(reenterVc)
                navigationController?.setViewControllers(viewControllers, animated: true)
            }
            
        case .newReenterPasscode:
            guard _passcode == testPasscode else {
                _animateWrongPasscode()
                return
            }
            KeychainWrapper.standard.set(_passcode, forKey: KeychainWrapper.Key.applicationPasscode.rawValue)
            if enableBiometricsAtFinish {
                KeychainWrapper.standard.set("yes", forKey: KeychainWrapper.Key.applicationBiometricsEnabled.rawValue)
            }
            navigationController?.popViewController(animated: true)
        case .validatePasscode:
            guard KeychainWrapper.standard.string(forKey: .applicationPasscode) == _passcode else {
                _animateWrongPasscode()
                _validationAttempt += 1
                if _validationAttempt > 3 {
                    APIManager.shared.logout()
                }
                return
            }
            delegate?.passcodeValidatedWithResult(true)
        case .changeOldPasscode:
            guard KeychainWrapper.standard.string(forKey: .applicationPasscode) == _passcode else {
                _animateWrongPasscode()
                return
            }
            if let enterVc = storyboard?.instantiateViewController(withIdentifier: "enterPasscode") as? EnterPasscodeViewController, var viewControllers = navigationController?.viewControllers {
                enterVc.controllerState = .changeNewPasscode
                enterVc.enableBiometricsAtFinish = enableBiometricsAtFinish
                viewControllers.removeLast()
                viewControllers.append(enterVc)
                navigationController?.setViewControllers(viewControllers, animated: true)
            }
        case .changeNewPasscode:
            if let reenterVc = storyboard?.instantiateViewController(withIdentifier: "enterPasscode") as? EnterPasscodeViewController, var viewControllers = navigationController?.viewControllers {
                reenterVc.controllerState = .changeReenterPasscode
                reenterVc.testPasscode = _passcode
                reenterVc.enableBiometricsAtFinish = enableBiometricsAtFinish
                viewControllers.removeLast()
                viewControllers.append(reenterVc)
                navigationController?.setViewControllers(viewControllers, animated: true)
            }
        case .changeReenterPasscode:
            guard _passcode == testPasscode else {
                _animateWrongPasscode()
                return
            }
            KeychainWrapper.standard.set(_passcode, forKey: KeychainWrapper.Key.applicationPasscode.rawValue)
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func _animateWrongPasscode () {
        
        CATransaction.begin()
        view.isUserInteractionEnabled = false
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: viewPasscodeSecure.center.x - 10, y: viewPasscodeSecure.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: viewPasscodeSecure.center.x + 10, y: viewPasscodeSecure.center.y))
        CATransaction.setCompletionBlock{ [weak self] in
            guard let strongSlf = self else {
                return
            }
            strongSlf.view.isUserInteractionEnabled = true
            strongSlf._passcode = ""
            
        }
        
        viewPasscodeSecure.layer.add(animation, forKey: "position")
        CATransaction.commit()
        
    }
    
    
    //MARK: - Actions
    
    @IBAction func clickOnDelete(sender: UIButton) {
        if _passcode.count > 0 {
             _passcode.removeLast()
        }
    }

    
    @IBAction func digitClicked(sender: UIButton) {
        guard let newChar = sender.currentTitle, _passcode.count < 4 else {
            return
        }
        _passcode += newChar
    }

}
