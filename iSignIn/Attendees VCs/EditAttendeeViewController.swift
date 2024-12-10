//
//  EditAttendeeViewController.swift
//  iSignIn
//
//  Created by Dmitrij on 2023-01-06.
//

import UIKit

class EditAttendeeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableContentOffset: CGPoint?
    
    var currentAttendee: Attendee!
    var currentProgram: Program!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            tableView.alwaysBounceVertical = false
        }
        
        navigationItem.title = "Attendee"
        
        let buttonBack = UIBarButtonItem(image: UIImage(named: "BackButtonImage")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(buttonBackAction(_:)))
        navigationItem.leftBarButtonItem = buttonBack
        
        NotificationCenter.default.addObserver(self, selector: #selector(_keyboardWillShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(_keyboardWillHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    //MARK: - Actions
    
    @objc func buttonBackAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func buttonSignInAction () {
        
        let validationMessage = _validateData()
        
        guard validationMessage.isEmpty else {
            let alert = UIAlertController(title: "Info", message: validationMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            alert.preferredAction = alert.actions.last
            present(alert, animated: true)
            return
        }
        
        guard let realm = RealmManager.shared.getMainRealm() else {
            return
        }
        
        
        try? realm.write {
            currentProgram.attendees.append(currentAttendee)
            realm.add(currentAttendee)
        }
        
        
        var lastAddress = [String:String]()
        lastAddress["address"] = currentAttendee.address
        lastAddress["city"] = currentAttendee.city
        lastAddress["postalCode"] = currentAttendee.postalCode
        lastAddress["stateProvince"] = currentAttendee.stateProvince
        UserDefaults.standard.setValue(lastAddress, forKey: "iSignInAddAttendeeLastUsedAddress")
        
        guard let signInViewController = storyboard?.instantiateViewController(withIdentifier: "signature") as? AttendeeSigninViewController, var viewControllers = navigationController?.viewControllers else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        signInViewController.currentAttendee = currentAttendee
        signInViewController.currentProgram = currentProgram
        viewControllers.removeLast()
        viewControllers.append(signInViewController)
        navigationController?.setViewControllers(viewControllers, animated: true)

    }
    
    @IBAction func buttonCancelAction () {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Methods
    
    @objc private func _keyboardWillShow(notification: NSNotification) {

        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            tableContentOffset = tableView.contentOffset
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            
      }
    }
        
    @objc private func _keyboardWillHide(notification: NSNotification) {

        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if let offset = tableContentOffset {
            tableView.setContentOffset(offset, animated: true)
        }
        else {
            tableView.setContentOffset(CGPoint.zero, animated: true)
        }
        
    }
    
    private func _validateData () -> String {
        
        var fieldArray = [String]()
        
        if currentAttendee.firstName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            fieldArray.append("First Name")
        }
        if currentAttendee.lastName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            fieldArray.append("Last Name")
        }
        if currentAttendee.address.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            fieldArray.append("Practice Address")
        }
        if currentAttendee.city.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            fieldArray.append("City")
        }
        if currentAttendee.postalCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            fieldArray.append("Zip")
        }
        if currentAttendee.stateProvince.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            fieldArray.append("State")
        }
        if currentAttendee.speciality.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            fieldArray.append("Speciality")
        }
        if currentAttendee.degree.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            fieldArray.append("License / Degree")
        }
        
        if fieldArray.count == 0 {
            return ""
        }
        else if fieldArray.count == 1 {
            return "Cannot save New Attendee. Please enter \(fieldArray.first ?? "") required field."
        }
        else if fieldArray.count == 2 {
            return "Cannot save New Attendee. Please enter \(fieldArray.first ?? "") and \(fieldArray[1]) required fields."
        }
        else {
            return "Cannot save New Attendee. Please enter \(fieldArray.first ?? "") and \(fieldArray.count - 1) more required fields."
        }
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let baseCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let cell = baseCell as? EditAttendeeTableViewTableViewCell else {
            return baseCell
        }

        _configureCell(cell)

        return cell
    }
    
    
    private func _configureCell (_ cell: EditAttendeeTableViewTableViewCell) {
        cell.attendee = currentAttendee
        cell.setupCell()
    }
    

}

class EditAttendeeTableViewTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    var attendee: Attendee!
    
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldMiddleIntials: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldCity: UITextField!
    @IBOutlet weak var textFieldPostalCode: UITextField!
    @IBOutlet weak var textFieldPracticeAddress: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldLicenseNo: UITextField!
    @IBOutlet weak var textFieldNpi: UITextField!
    @IBOutlet weak var textFieldOther: UITextField!
    
    
    @IBOutlet weak var buttonState: UIButton!
    @IBOutlet weak var buttonLicenseState: UIButton!
    @IBOutlet weak var buttonSpeciality: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonSignIn: UIButton!
    
    @IBOutlet weak var viewButtonCancel: UIView!
    @IBOutlet weak var viewButtonSignIn: UIView!

    @IBOutlet weak var switchPrevAddress: UISwitch!
    @IBOutlet weak var switchLicenceMD: UISwitch!
    @IBOutlet weak var switchLicenceDO: UISwitch!
    @IBOutlet weak var switchLicenceDPM: UISwitch!
    @IBOutlet weak var switchLicenceNP: UISwitch!
    @IBOutlet weak var switchLicencePA: UISwitch!
    @IBOutlet weak var switchLicenceRN: UISwitch!
    @IBOutlet weak var switchLicencePharmD: UISwitch!
    @IBOutlet weak var switchLicenceOPH: UISwitch!
    @IBOutlet weak var switchLicenceOD: UISwitch!
    @IBOutlet weak var switchCompanyEmployee: UISwitch!
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewBackgroundHeader: UIView!
    
    @IBOutlet weak var labelPrevAddress: UILabel!
    
    private var _lastUsedAddress: [String : String]?
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            textField.resignFirstResponder()
            return true
        }
        
        if textField == textFieldFirstName {
            textFieldMiddleIntials.becomeFirstResponder()
        }
        else if textField == textFieldMiddleIntials {
            textFieldLastName.becomeFirstResponder()
        }
        else if textField == textFieldLastName {
            textFieldPracticeAddress.becomeFirstResponder()
        }
        else if textField == textFieldPracticeAddress {
            textFieldCity.becomeFirstResponder()
        }
        else if textField == textFieldCity {
            textFieldPostalCode.becomeFirstResponder()
        }
        else if textField == textFieldPostalCode {
            textFieldEmail.becomeFirstResponder()
        }
        else if textField == textFieldEmail {
            textFieldLicenseNo.becomeFirstResponder()
        }
        else if textField == textFieldLicenseNo {
            textFieldNpi.becomeFirstResponder()
        }
        else if textField == textFieldNpi {
            textFieldOther.becomeFirstResponder()
        }
        else  {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    //MARK: - Actions
    
    @objc func textFieldDidChange (_ sender: UITextField) {
        if sender == textFieldFirstName {
            attendee.firstName = sender.text ?? ""
        }
        else if sender == textFieldMiddleIntials {
            attendee.middleName = sender.text ?? ""
            attendee.middleInitials = sender.text ?? ""
        }
        else if sender == textFieldLastName {
            attendee.lastName = sender.text ?? ""
        }
        else if sender == textFieldCity {
            attendee.city = sender.text ?? ""
        }
        else if sender == textFieldPostalCode {
            attendee.postalCode = sender.text ?? ""
        }
        else if sender == textFieldPracticeAddress {
            attendee.address = sender.text ?? ""
        }
        else if sender == textFieldEmail {
            attendee.email = sender.text ?? ""
        }
        else if sender == textFieldLicenseNo {
            attendee.licenceNumber = sender.text ?? ""
        }
        else if sender == textFieldNpi {
            attendee.npi = sender.text ?? ""
        }
        else if sender == textFieldOther {
            attendee.other = sender.text ?? ""
        }
    }
    
    @objc func switchAction (_ sender: UISwitch) {
        contentView.endEditing(true)
        if sender == switchPrevAddress {
            _switchPrevAddressAction(sender.isOn)
        }
        else if sender == switchCompanyEmployee {
            attendee.isCompanyEmployee = sender.isOn
        }
        else {
            _switchDegreeAction(sender)
        }
    }
    
    
    
    //MARK: - Setup methods
    
    func setupCell () {
        let textFieldArray = [textFieldFirstName, textFieldMiddleIntials, textFieldLastName, textFieldCity, textFieldPostalCode, textFieldPracticeAddress, textFieldEmail, textFieldLicenseNo, textFieldNpi, textFieldOther]
        let switchArray = [switchPrevAddress, switchLicenceMD, switchLicenceDO, switchLicenceDPM, switchLicenceNP, switchLicencePA, switchLicenceRN, switchLicencePharmD, switchLicenceOPH, switchLicenceOD, switchCompanyEmployee]
        let buttonArray = [buttonState, buttonSpeciality, buttonLicenseState]
        
        for item in textFieldArray {
            if let textField = item {
                textField.delegate = self
                textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                
                textField.backgroundColor = UIColor.textFieldBackgroundDefaultColor()
                textField.layer.borderColor = UIColor.textFieldBorderDefaultColor().cgColor
                textField.layer.borderWidth = 1.0
                textField.layer.cornerRadius = 4.0
                
            }
        }
        for item in switchArray {
            if let switchC = item {
                switchC.addTarget(self, action: #selector(switchAction(_:)), for: .valueChanged)
                switchC.isOn = false
            }
        }
        
        for item in buttonArray {
            if let button = item {
                button.backgroundColor = UIColor.textFieldBackgroundDefaultColor()
                button.layer.borderColor = UIColor.textFieldBorderDefaultColor().cgColor
                button.layer.borderWidth = 1.0
                button.layer.cornerRadius = 4.0
                button.setTitle("", for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
            }
        }
        
        viewBackground.layer.borderColor = UIColor.tertiaryLabel.cgColor
        viewBackground.layer.borderWidth = 1.0
        viewBackground.layer.cornerRadius = 4.0
        viewBackground.clipsToBounds = true
        viewBackgroundHeader.backgroundColor = UIColor.textFieldBorderDefaultColor()
        
        buttonCancel.setTitle("", for: .normal)
        buttonSignIn.setTitle("", for: .normal)
        
        viewButtonCancel.layer.cornerRadius = 4.0
        viewButtonCancel.layer.borderColor = UIColor.tertiaryLabel.cgColor
        viewButtonCancel.layer.borderWidth = 1.0
        
        viewButtonSignIn.layer.cornerRadius = 4.0
        viewButtonSignIn.backgroundColor = UIColor.buttonBackgroundGradientColor1(bounds: viewButtonSignIn.bounds)
        
        _addLicenseStateMenu()
        _addStateMenu()
        _addSpecialityMenu()
        
        switchPrevAddress.isEnabled = false
        if let lastAddress = UserDefaults.standard.object(forKey: "iSignInAddAttendeeLastUsedAddress") as? [String : String] {
            _lastUsedAddress = lastAddress
            switchPrevAddress.isEnabled = true
        }
        
        labelPrevAddress.text = switchPrevAddress.isOn ? "Yes" : "No"
        
        
    }
    
    private func _addLicenseStateMenu () {
        
        let fontAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16.0), NSAttributedString.Key.foregroundColor : UIColor.label]
        let stateList =  RealmManager.shared.getStateList()
        
        var menuItems = [UIAction]()
        
        let clearItem = UIAction(title: "Clear") { [weak self] action in
            guard let strongSlf = self else {
                return
            }
            strongSlf.buttonLicenseState.setTitle("", for: .normal)
            strongSlf.attendee.licenceState = ""
        }
        menuItems.append(clearItem)
        
        for state in stateList {
            let menuItem = UIAction(title: state) { [weak self] (action) in
                guard let strongSlf = self else {
                    return
                }
                strongSlf.buttonLicenseState.setAttributedTitle(NSAttributedString(string: state, attributes: fontAttributes), for: .normal)
                strongSlf.attendee.licenceState = state
            }
            menuItems.append(menuItem)
        }
        
        let menu = UIMenu(title: "States", options: .displayInline, children: menuItems)
        buttonLicenseState.menu = menu
        buttonLicenseState.showsMenuAsPrimaryAction = true
        
    }
    
    private func _addStateMenu () {
        
        let fontAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16.0), NSAttributedString.Key.foregroundColor : UIColor.label]
        let stateList =  RealmManager.shared.getStateList()
        
        var menuItems = [UIAction]()
        
        for state in stateList {
            let menuItem = UIAction(title: state) { [weak self] (action) in
                guard let strongSlf = self else {
                    return
                }
                strongSlf.buttonState.setAttributedTitle(NSAttributedString(string: state, attributes: fontAttributes), for: .normal)
                strongSlf.attendee.stateProvince = state
            }
            menuItems.append(menuItem)
        }
        
        let menu = UIMenu(title: "States", options: .displayInline, children: menuItems)
        buttonState.menu = menu
        buttonState.showsMenuAsPrimaryAction = true
    }
    
    private func _addSpecialityMenu () {
        
        let fontAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16.0), NSAttributedString.Key.foregroundColor : UIColor.label]
        let specList =  RealmManager.shared.getSpecialityList()
        
        var menuItems = [UIAction]()
        
        for spec in specList {
            let menuItem = UIAction(title: spec) { [weak self] (action) in
                guard let strongSlf = self else {
                    return
                }
                strongSlf.buttonSpeciality.setAttributedTitle(NSAttributedString(string: spec, attributes: fontAttributes), for: .normal)
                strongSlf.attendee.speciality = spec
            }
            menuItems.append(menuItem)
        }
        
        let menu = UIMenu(title: "Specialities", options: .displayInline, children: menuItems)
        buttonSpeciality.menu = menu
        buttonSpeciality.showsMenuAsPrimaryAction = true
    }
    
    //MARK: - Switch Methods
    
    private func _switchPrevAddressAction(_ isOn: Bool) {
        if isOn {
            attendee.address = _lastUsedAddress?["address"] ?? ""
            textFieldPracticeAddress.text = _lastUsedAddress?["address"] ?? ""
            attendee.city = _lastUsedAddress?["city"] ?? ""
            textFieldCity.text = _lastUsedAddress?["city"] ?? ""
            attendee.postalCode = _lastUsedAddress?["postalCode"] ?? ""
            textFieldPostalCode.text = _lastUsedAddress?["postalCode"] ?? ""
            attendee.stateProvince = _lastUsedAddress?["stateProvince"] ?? ""
            buttonState.setTitle(_lastUsedAddress?["stateProvince"] ?? "", for: .normal)
        }
        else {
            attendee.address = ""
            textFieldPracticeAddress.text = ""
            attendee.city = ""
            textFieldCity.text = ""
            attendee.postalCode = ""
            textFieldPostalCode.text = ""
            attendee.stateProvince = ""
            buttonState.setTitle("", for: .normal)
        }
        buttonState.isEnabled = !switchPrevAddress.isOn
        labelPrevAddress.text = switchPrevAddress.isOn ? "Yes" : "No"
        
    }
    
    private func _switchDegreeAction(_ sender: UISwitch) {
        
        let switchArray = [switchLicenceMD, switchLicenceDO, switchLicenceDPM, switchLicenceNP, switchLicencePA, switchLicenceRN, switchLicencePharmD, switchLicenceOPH, switchLicenceOD]
        
        if sender.isOn {
            switchArray.forEach { switchC in
                switchC?.isOn = false
            }
            sender.isOn = true
        }
        
        attendee.degree = _getDegreeString()
        
    }
    
    private func _getDegreeString () -> String {
        let switchArray = [switchLicenceMD, switchLicenceDO, switchLicenceDPM, switchLicenceNP, switchLicencePA, switchLicenceRN, switchLicencePharmD, switchLicenceOPH, switchLicenceOD]
        let degreeArray = ["MD", "DO", "DPM", "NP", "PA", "RN", "PharmD", "OPH", "OD"]
        var degreeString = ""
        
        for i in 0..<switchArray.count {
            if let sw = switchArray[i], sw.isOn {
                degreeString = degreeArray[i]
            }
        }
        
        return degreeString
    }
    
}

