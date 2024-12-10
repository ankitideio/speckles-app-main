//
//  SettingsViewController.swift
//  iSignIn
//
//  Created by Dmitrij on 2022-12-26.
//

import UIKit
import SwiftKeychainWrapper
import LocalAuthentication

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableViewMenu: UITableView!
    
    private var _passcodeUsed: Bool {
        guard let passcode = KeychainWrapper.standard.string(forKey: .applicationPasscode) else {
            return false
        }
        return !passcode.isEmpty
    }
    private var _biometricsUsed: Bool {
        guard let bio = KeychainWrapper.standard.string(forKey: .applicationBiometricsEnabled) else {
            return false
        }
        return !bio.isEmpty
    }
    private var _bioTitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(_closeAction))
        navigationItem.leftBarButtonItem = closeButton
        
        navigationItem.title = "Settings"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let context = LAContext()
        _ = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        switch context.biometryType {
        case .touchID:
            _bioTitle = "Touch ID"
        case .faceID:
            _bioTitle = "Face ID"
        default:
            break
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableViewMenu.reloadData()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "OpenChangePasscode" {
            let destination = segue.topLevelDestinationViewController() as? EnterPasscodeViewController
            destination?.controllerState = .changeOldPasscode
        }
        else if segue.identifier == "OpenEnterPasscode" && sender == nil {
            let destination = segue.topLevelDestinationViewController() as? EnterPasscodeViewController
            destination?.enableBiometricsAtFinish = true
        }
    }
    
    
    //MARK: - Actions
    
    @IBAction func switchAction(_ sender: UISwitch) {
        guard let index = tableViewMenu.indexPathForRow(at: tableViewMenu.convert(sender.bounds.origin, from: sender))?.row else {
            return
        }
        if index == 0 {
            if sender.isOn {
                sender.isOn = false
                performSegue(withIdentifier: "OpenEnterPasscode", sender: self)
            }
            else {
                let _ = KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.applicationPasscode.rawValue)
                let _ = KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.applicationBiometricsEnabled.rawValue)
                tableViewMenu.reloadData()
            }
        }
        else if index == 1 {
            if sender.isOn {
                if _passcodeUsed {
                    KeychainWrapper.standard.set("yes", forKey: KeychainWrapper.Key.applicationBiometricsEnabled.rawValue)
                }
                else {
                    sender.isOn = false
                    let alert = UIAlertController(title: "Info", message: "To enable \(_bioTitle) you have to enable Passcode first.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "No, Thanks", style: .cancel))
                    alert.addAction(UIAlertAction(title: "Enable Passcode and \(_bioTitle)", style: .default) { [weak self] _ in
                        guard let strongSlf = self else {
                            return
                        }
                        strongSlf.performSegue(withIdentifier: "OpenEnterPasscode", sender: nil)
                    })
                    alert.preferredAction = alert.actions.last
                    present(alert, animated: true)
                }
            }
            else {
                let _ = KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.applicationBiometricsEnabled.rawValue)
            }
        }
    }
    
    @objc private func _closeAction () {
        dismiss(animated: true)
    }
    
    //MARK: - UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if _passcodeUsed {
            return 3
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
                let biomType = LAContext().biometryType
                switch biomType {
                case .touchID, .faceID:
                    return 2
                default:
                    return 1
                }
            }
            else {
                return 1
            }
            
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let baseCell = tableView.dequeueReusableCell(withIdentifier: "cellSwitch", for: indexPath)
            guard let cell = baseCell as? SettingsSwitchTableViewCell else {
                return baseCell
            }
            
            var title = ""
            if indexPath.row == 0 {
                title = "Use Passcode"
                cell.switchControl.isOn = _passcodeUsed
            }
            else if indexPath.row == 1 {
                title = "Use \(_bioTitle)"
                cell.switchControl.isOn = _biometricsUsed
            }
            cell.textLabel?.text = title
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.accessoryType = .disclosureIndicator
            let title = _passcodeUsed ? "Change Passcode" : "Logout"
            var config = cell.defaultContentConfiguration()
            config.text = title
            cell.contentConfiguration = config
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.accessoryType = .disclosureIndicator
            let title = "Logout"
            var config = cell.defaultContentConfiguration()
            config.text = title
            cell.contentConfiguration = config
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Application Security"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 44.0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            if _passcodeUsed {
                performSegue(withIdentifier: "OpenChangePasscode", sender: self)
            }
            else {
                APIManager.shared.logout()
            }
        }
        else if indexPath.section == 2 && indexPath.row == 0 {
            APIManager.shared.logout()
        }
    }

}

class SettingsSwitchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var switchControl: UISwitch!
    
}
