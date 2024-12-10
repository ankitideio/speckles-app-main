//
//  AttendeeSigninViewController.swift
//  iSignIn
//
//  Created by Dmitrij on 2022-12-26.
//

import UIKit
import PencilKit

class AttendeeSigninViewController: UIViewController, UITextFieldDelegate, PKCanvasViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    var currentAttendee: Attendee!
    var currentProgram: Program!
    
    var tableContentOffset: CGPoint?
    
    private var _dateFormatter = DateFormatter()
    
    private var _canvasInUse = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Sign In"
        
        let buttonBack = UIBarButtonItem(image: UIImage(named: "BackButtonImage")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(buttonBackAction(_:)))
        navigationItem.leftBarButtonItem = buttonBack
        
        _dateFormatter.dateStyle = .long
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(_keyboardWillShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(_keyboardWillHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    
    //MARK: - Actions
    
    @objc func buttonBackAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonNoShowAction () {
        if let realm = currentAttendee.realm {
            try? realm.write {
                currentAttendee.submitSignature = nil
                currentAttendee.submitSignatureDrawingData = nil
                currentAttendee.submitStatus = .readyNoShow
            }
        }
//        SyncManager.shared.notifyRequiresUpSync()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonSubmitAction (_ sender: UIButton) {
        
        guard let indexPath = tableView.indexPathForRow(at: tableView.convert(sender.bounds.origin, from: sender)) else {
            return
        }
        
        guard let cell = tableView.cellForRow(at: indexPath) as? AttendeeSigninIndex1TableViewCell else {
            return
        }
        
        let image = cell.canvasView.drawing.image(from: cell.canvasView.bounds, scale: 1.0, userInterfaceStyle: .light)
        
        guard let imageData = image.jpegData(compressionQuality: 1.0), !cell.canvasView.drawing.bounds.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Signature is missed. Please sign here before submit attendee.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            alert.preferredAction = alert.actions.last
            present(alert, animated: true)
            return
        }
        //print("ImageData\(imageData)")
        let drawingData = cell.canvasView.drawing.dataRepresentation()
        
        if let realm = currentAttendee.realm {
            try? realm.write {
                currentAttendee.submitSignatureDrawingData = drawingData
              currentAttendee.submitSignature = imageData
                currentAttendee.submitStatus = .readySigned
            }
        }
        
//        SyncManager.shared.notifyRequiresUpSync()
        
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func mealSwitchAction(_ sender: UISwitch) {
        
        if let realm = currentAttendee.realm {
            try? realm.write {
                currentAttendee.submitMealConsumtion = sender.isOn
            }
        }
        
        guard let indexPath = tableView.indexPathForRow(at: tableView.convert(sender.bounds.origin, from: sender)) else {
            return
        }
        
        guard let cell = tableView.cellForRow(at: indexPath) as? AttendeeSigninIndex1TableViewCell else {
            return
        }
        
        _configureCell1(cell)
    }
    
    @IBAction func mnSwitchAction(_ sender: UISwitch) {
        
        if let realm = currentAttendee.realm {
            try? realm.write {
                currentAttendee.submitLicenseMN = sender.isOn
            }
        }
        
        guard let indexPath = tableView.indexPathForRow(at: tableView.convert(sender.bounds.origin, from: sender)) else {
            return
        }
        
        guard let cell = tableView.cellForRow(at: indexPath) as? AttendeeSigninIndex1TableViewCell else {
            return
        }
        
        _configureCell1(cell)
    }
    @IBAction func njSwitchAction(_ sender: UISwitch) {
        
        if let realm = currentAttendee.realm {
            try? realm.write {
                currentAttendee.submitLicenseNJ = sender.isOn
            }
        }
        
        guard let indexPath = tableView.indexPathForRow(at: tableView.convert(sender.bounds.origin, from: sender)) else {
            return
        }
        
        guard let cell = tableView.cellForRow(at: indexPath) as? AttendeeSigninIndex1TableViewCell else {
            return
        }
        
        _configureCell1(cell)
        
    }
    
    @IBAction func vtSwitchAction(_ sender: UISwitch) {
        
        if let realm = currentAttendee.realm {
            try? realm.write {
                currentAttendee.submitLicenseVT = sender.isOn
            }
        }
        
        guard let indexPath = tableView.indexPathForRow(at: tableView.convert(sender.bounds.origin, from: sender)) else {
            return
        }
        
        guard let cell = tableView.cellForRow(at: indexPath) as? AttendeeSigninIndex1TableViewCell else {
            return
        }
        
        _configureCell1(cell)
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func textFieldEmailDidChange (_ textField: UITextField) {
        if let realm = currentAttendee.realm {
            try? realm.write {
                currentAttendee.email = textField.text ?? ""
            }
        }
    }
    
    @IBAction func textFieldNpiDidChange (_ textField: UITextField) {
        if let realm = currentAttendee.realm {
            try? realm.write {
                currentAttendee.npi = textField.text ?? ""
            }
        }
    }
    
    //MARK: - PKCanvasViewDelegate
    
    func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
        _canvasInUse = true
        tableView.isScrollEnabled = false
    }
    
    func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
        _canvasInUse = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if !self._canvasInUse {
                self.tableView.isScrollEnabled = true
            }
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
        
        let baseCell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        guard let cell = baseCell as? AttendeeSigninIndex1TableViewCell else {
            return baseCell
        }
        
        _configureCell1(cell)
        return cell
    }
    
    private func _configureCell1(_ cell: AttendeeSigninIndex1TableViewCell) {
        
        cell.labelProgramId.text = "\(currentProgram.programId)"
        if let date = currentProgram.startDate {
            cell.labelProgramDate.text = _dateFormatter.string(from: date)
        }
        else {
            cell.labelProgramDate.text = "--"
        }
        cell.labelProgramLocation.text = currentProgram.venue
        
        var cityState = currentProgram.city
        let state = currentProgram.stateProvince
        if !cityState.isEmpty && !state.isEmpty {
            cityState += ", " + state
        }
        else if !state.isEmpty {
            cityState += state
        }
        cell.labelProgramCityState.text = cityState
        
        cell.labelMiddleInitials.text = currentAttendee.middleName.isEmpty ? " " : currentAttendee.middleName
        cell.labelFirstName.text = currentAttendee.firstName.isEmpty ? " " : currentAttendee.firstName
        cell.labelLastName.text = currentAttendee.lastName.isEmpty ? " " : currentAttendee.lastName
        cell.labelDegree.text = currentAttendee.degree.isEmpty ? " " : currentAttendee.degree
        cell.labelSpeciality.text = currentAttendee.speciality.isEmpty ? " " : currentAttendee.speciality
        cell.labelBusinessAddress.text = currentAttendee.address.isEmpty ? " " : currentAttendee.address
        cell.labelCity.text = currentAttendee.city.isEmpty ? " " : currentAttendee.city
        cell.labelState.text = currentAttendee.stateProvince.isEmpty ? " " : currentAttendee.stateProvince
        cell.labelZip.text = currentAttendee.postalCode.isEmpty ? " " : currentAttendee.postalCode
        cell.labelLicenseState.text = currentAttendee.licenceState.isEmpty ? " " : currentAttendee.licenceState
        cell.labelStateLicenceNr.text = currentAttendee.licenceNumber.isEmpty ? " " : currentAttendee.licenceNumber
        
        cell.switchMN.isOn = currentAttendee.submitLicenseMN
        cell.switchNJ.isOn = currentAttendee.submitLicenseNJ
        cell.switchVT.isOn = currentAttendee.submitLicenseVT
        cell.switchMeal.isOn = currentAttendee.submitMealConsumtion
        
        cell.labelMeal.text = currentAttendee.submitMealConsumtion ? "Yes" : "No"
        
        cell.textFieldEmail.text = currentAttendee.email
        cell.textFieldNPI.text = currentAttendee.npi
        
        cell.textFieldEmail.isEnabled = !currentAttendee.submitSubmited
        cell.switchMeal.isEnabled = !currentAttendee.submitSubmited
        cell.textFieldNPI.isEnabled = !currentAttendee.submitSubmited
        cell.switchMN.isEnabled = !currentAttendee.submitSubmited
        cell.switchNJ.isEnabled = !currentAttendee.submitSubmited
        cell.switchVT.isEnabled = !currentAttendee.submitSubmited
        cell.canvasView.isUserInteractionEnabled = !currentAttendee.submitSubmited
        
        cell.canvasView.overrideUserInterfaceStyle = .light
        cell.canvasView.tool = PKInkingTool(.pen, color: .darkText, width: 10)
        
        cell.canvasView.drawingPolicy = .anyInput
        
        cell.canvasView.delegate = self
        
        if let data = currentAttendee.submitSignatureDrawingData {
            if let drawing = try? PKDrawing(data: data) {
                cell.canvasView.drawing.append(drawing)
            }
        }
    }
    
    private func _configureCell0(_ cell: AttendeeSigninIndex0TableViewCell) {
        
        _dateFormatter.dateFormat = "MMM d, yyyy"
        
        var cityString = currentProgram.city
        if !currentProgram.stateProvince.isEmpty {
            cityString += ", " + currentProgram.stateProvince
        }
        
        if UIDevice.current.userInterfaceIdiom == .phone {

            let titleBoldAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18.0), .foregroundColor : UIColor.label]
            let titleItalicAttributes = [NSAttributedString.Key.font : UIFont.italicSystemFont(ofSize: 18.0), .foregroundColor : UIColor.label]
            
            
            let idString = NSAttributedString(string: "#" + "\(currentProgram.programId)", attributes: titleBoldAttributes)
            cell.labelProgramIdValue.attributedText = idString
            
            if let date = currentProgram.startDate {
                let dateString = NSAttributedString(string: "\(_dateFormatter.string(from: date))", attributes: titleBoldAttributes)
                cell.labelDateValue.attributedText = dateString
            }
            else {
                cell.labelDateValue.text = nil
            }
            
            let venueAttachment = NSTextAttachment()
            venueAttachment.image = UIImage(systemName: "house")
            let venueString = NSMutableAttributedString(attachment: venueAttachment)
            venueString.append(NSAttributedString(string: " " +  (currentProgram.venue), attributes: titleItalicAttributes))
            cell.labelLocationValue.attributedText = venueString
            
            let addressAttachment = NSTextAttachment()
            addressAttachment.image = UIImage(systemName: "mappin.and.ellipse")
            let addressString = NSMutableAttributedString(attachment: addressAttachment)
            addressString.append(NSAttributedString(string: " " + cityString, attributes: titleItalicAttributes))
            cell.labelCityValue.attributedText = addressString
            
        }
        else {
            
            cell.labelProgramIdValue.text = "\(currentProgram.programId)"
            if let date = currentProgram.startDate {
                cell.labelDateValue.text = _dateFormatter.string(from: date)
            }
            else {
                cell.labelDateValue.text = ""
            }
            cell.labelLocationValue.text = currentProgram.venue
            
            cell.labelCityValue.text = cityString
            
            cell.labelProgramId.layer.borderColor = UIColor.mainYellowColor2().cgColor
            cell.labelDate.layer.borderColor = UIColor.mainYellowColor2().cgColor
            cell.labelLocation.layer.borderColor = UIColor.mainYellowColor2().cgColor
            cell.labelCity.layer.borderColor = UIColor.mainYellowColor2().cgColor
            
            cell.labelProgramId.layer.borderWidth = 1
            cell.labelDate.layer.borderWidth = 1
            cell.labelLocation.layer.borderWidth = 1
            cell.labelCity.layer.borderWidth = 1
        }
        
    }
}


class AttendeeSigninIndex0TableViewCell: UITableViewCell {

    @IBOutlet weak var labelProgramIdValue: UILabel!
    @IBOutlet weak var labelDateValue: UILabel!
    @IBOutlet weak var labelLocationValue: UILabel!
    @IBOutlet weak var labelCityValue: UILabel!

    @IBOutlet weak var labelProgramId: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelCity: UILabel!

}

class AttendeeSigninIndex1TableViewCell: UITableViewCell {
    
    @IBOutlet var viewsProgramBoxCollection: [UIView]!
    @IBOutlet var viewsProgramSideCollection: [UIView]!
    @IBOutlet var buttonsCollection: [UIButton]!
    
    @IBOutlet weak var labelProgramId: UILabel!
    @IBOutlet weak var labelProgramDate: UILabel!
    @IBOutlet weak var labelProgramLocation: UILabel!
    @IBOutlet weak var labelProgramCityState: UILabel!
    
    @IBOutlet weak var viewBox: UIView!
    @IBOutlet weak var viewBoxHeader: UIView!
    @IBOutlet weak var viewBoxEmail: UIView!
    @IBOutlet weak var viewBoxSignature: UIView!
    
    
    @IBOutlet weak var labelInfo: UILabel!
    
    @IBOutlet weak var labelFirstName: UILabel!
    @IBOutlet weak var labelMiddleInitials: UILabel!
    @IBOutlet weak var labelLastName: UILabel!
    @IBOutlet weak var labelDegree: UILabel!
    @IBOutlet weak var labelSpeciality: UILabel!
    @IBOutlet weak var labelBusinessAddress: UILabel!
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var labelState: UILabel!
    @IBOutlet weak var labelZip: UILabel!
    @IBOutlet weak var labelLicenseState: UILabel!
    @IBOutlet weak var labelStateLicenceNr: UILabel!
    @IBOutlet weak var labelMeal: UILabel!
    @IBOutlet weak var labelButtonClear: UILabel!
    
    @IBOutlet weak var switchMN: UISwitch!
    @IBOutlet weak var switchVT: UISwitch!
    @IBOutlet weak var switchNJ: UISwitch!
    @IBOutlet weak var switchMeal: UISwitch!
    
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldNPI: UITextField!
    
    @IBOutlet weak var viewButtonCancel: UIView!
    @IBOutlet weak var viewButtonClear: UIView!
    @IBOutlet weak var viewButtonNoShow: UIView!
    @IBOutlet weak var viewButtonSubmit: UIView!
    
    override func awakeFromNib() {
        for item in viewsProgramBoxCollection {
            item.backgroundColor = .programBackgroundGradientColor1(bounds: item.bounds)
        }
        for item in viewsProgramSideCollection {
            item.backgroundColor = .programBackgroundGradientColor2(bounds: item.bounds)
        }
        
        viewBox.layer.cornerRadius = 4.0
        viewBox.layer.borderColor = UIColor.tertiaryLabel.cgColor
        viewBox.layer.borderWidth = 1.0
        viewBox.clipsToBounds = true
        viewBoxEmail.layer.cornerRadius = 4.0
        viewBoxEmail.layer.borderColor = UIColor.tertiaryLabel.cgColor
        viewBoxEmail.layer.borderWidth = 1.0
        viewBoxSignature.layer.cornerRadius = 4.0
        viewBoxSignature.layer.borderColor = UIColor.tertiaryLabel.cgColor
        viewBoxSignature.layer.borderWidth = 1.0
        canvasView.layer.cornerRadius = 4.0
        canvasView.layer.borderColor = UIColor.tertiaryLabel.cgColor
        canvasView.layer.borderWidth = 1.0
        viewButtonCancel.layer.cornerRadius = 4.0
        viewButtonCancel.layer.borderColor = UIColor.tertiaryLabel.cgColor
        viewButtonCancel.layer.borderWidth = 1.0
        viewButtonNoShow.layer.cornerRadius = 4.0
        viewButtonNoShow.layer.borderColor = UIColor.tertiaryLabel.cgColor
        viewButtonNoShow.layer.borderWidth = 1.0
        viewButtonClear.layer.cornerRadius = 4.0
        viewButtonClear.layer.borderColor = UIColor.tertiaryLabel.cgColor
        viewButtonClear.layer.borderWidth = 1.0
        
        viewButtonSubmit.layer.cornerRadius = 4.0
        
        viewBoxHeader.backgroundColor = .textFieldBorderDefaultColor()
        viewBoxEmail.backgroundColor = .backgroundGrayColor()
        viewBoxSignature.backgroundColor = .backgroundGrayColor()
        viewButtonClear.backgroundColor = .mainNavigationBarColor()
        viewButtonSubmit.backgroundColor = UIColor.buttonBackgroundGradientColor1(bounds: viewButtonSubmit.bounds)
        
        labelInfo.textColor = .mainTextGradientColor(bounds: CGRect(origin: CGPoint.zero, size: labelInfo.sizeThatFits(CGSize.zero)))
        labelProgramId.textColor = .textColorBlue()
        
        textFieldEmail.backgroundColor = UIColor.textFieldBackgroundDefaultColor()
        textFieldEmail.layer.borderColor = UIColor.textFieldBorderDefaultColor().cgColor
        textFieldEmail.layer.borderWidth = 1.0
        textFieldEmail.layer.cornerRadius = 4.0
        
        textFieldNPI.backgroundColor = UIColor.textFieldBackgroundDefaultColor()
        textFieldNPI.layer.borderColor = UIColor.textFieldBorderDefaultColor().cgColor
        textFieldNPI.layer.borderWidth = 1.0
        textFieldNPI.layer.cornerRadius = 4.0
        
        for item in buttonsCollection {
            item.setTitle("", for: .normal)
        }
        
        labelButtonClear.textColor = .textColorRed()
        
        
    }
    
    @IBOutlet weak var canvasView: PKCanvasView!
    
    @IBAction func buttonClearAction () {
        canvasView.drawing = PKDrawing()
    }
    
}




