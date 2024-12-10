//
//  CreateEventVC.swift
//  EventManagement
//
//  Created by meet sharma on 04/07/23.
//

import UIKit
import SwiftKeychainWrapper
import RealmSwift

class CreateEventVC: UIViewController {
    
    @IBOutlet weak var txtFldLocation: UITextField!
    @IBOutlet weak var txtFldSpeakerName: UITextField!
    @IBOutlet weak var txtFldEstimatedAttendes: UITextField!
    @IBOutlet weak var txtFldTimeZone: UITextField!
    @IBOutlet weak var txtFldTime: UITextField!
    @IBOutlet weak var txtFldDate: UITextField!
    @IBOutlet weak var txtFldProgramType: UITextField!
    @IBOutlet weak var txtFldBrand: UITextField!
    @IBOutlet weak var txtFldPresentation: UITextField!
    @IBOutlet weak var viewActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var txtFldName: UITextField!
    
    let datePicker = UIDatePicker()
    var locationId:String?
    var speakerId:String?
    var brandId:Int?
    var presentationId:Int?
    var timzoneId:Int?
    var programtypeId:Int?
    var date:Date?
    
    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if KeychainWrapper.standard.string(forKey: .locationID) != ""{
            txtFldLocation.text = KeychainWrapper.standard.string(forKey: .locationName)
            locationId = KeychainWrapper.standard.string(forKey: .locationID)
        }
        
        if KeychainWrapper.standard.string(forKey: .speakerID) != ""{
            txtFldSpeakerName.text = KeychainWrapper.standard.string(forKey: .speakerName)
            speakerId = KeychainWrapper.standard.string(forKey: .speakerID)
        }
        
    }
    
    //MARK: - FUNCTIONS
    
    
    private func _setViewLoading () {
        view.isUserInteractionEnabled = false
        viewActivityIndicator.startAnimating()
       // buttonLogin.alpha = 0.5
    }
    
    private func _setViewNotLoading () {
        view.isUserInteractionEnabled = true
        viewActivityIndicator.stopAnimating()
       // buttonLogin.alpha = 1.0
    }
    
    @objc func doneDatePickerAction(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        txtFldDate.text = formatter.string(from: datePicker.date)
        date = datePicker.date
        self.view.endEditing(true)
    }
    
    @objc func doneTimePickerAction(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        txtFldTime.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }

          
    @objc func cancelDatePickerAction() {
        self.view.endEditing(true)
        
    }
    
    private func validateData () {
        
        let name = txtFldName.text ?? ""
        let brand = txtFldBrand.text ?? ""
        let programType = txtFldProgramType.text ?? ""
        let Presentation = txtFldPresentation.text ?? ""
        let date = txtFldDate.text ?? ""
        let time = txtFldTime.text ?? ""
        let timezone = txtFldTimeZone.text ?? ""
        let speaker = txtFldSpeakerName.text ?? ""
        let location = txtFldLocation.text ?? ""
        let attendees = txtFldEstimatedAttendes.text ?? ""
        
        if name == "" {
        
                _showValidationAlert(message: "Event name cannot be empty")
        
        }else if brand == "" {
        
                _showValidationAlert(message: "Brand cannot be empty")
        
        }else if programType == ""{
            
                _showValidationAlert(message: "Program Type cannot be empty")
           
        } else if Presentation == ""{

                _showValidationAlert(message: "Presentation cannot be empty")

        }else if  date == ""{
           
                _showValidationAlert(message: "Date cannot be empty")
           
        }else if time  == ""{
           
                _showValidationAlert(message: "Time cannot be empty")
           
        }else if timezone == ""{
           
                _showValidationAlert(message: "Timezone cannot be empty")
           
        }else if  speaker == ""{
         
                _showValidationAlert(message: "Speaker Name cannot be empty")
         
        }else if programType == "" {
           
                _showValidationAlert(message: "Program cannot be empty")
         
        }else if  location == ""{
            
                _showValidationAlert(message: "Location cannot be empty")
          
        }else if attendees == ""{
           
                _showValidationAlert(message: "Attendees cannot be empty")
         
        }else{
          
            let program = Program()
            program.speakerName = txtFldSpeakerName.text ?? ""
            program.programType = txtFldProgramType.text ?? ""
            program.address = txtFldLocation.text ?? ""
            program.attandeesCount = Int(txtFldEstimatedAttendes.text ?? "") ?? 0
            program.brand = txtFldBrand.text ?? ""
            program.label = txtFldName.text ?? ""
            program.brandId = brandId ?? 0
            program.programTypeId = programtypeId ?? 0
            program.presentationId = presentationId ?? 0
            program.eventDate = txtFldDate.text ?? ""
            program.eventTime = txtFldTime.text ?? ""
            program.timzoneId = timzoneId ?? 0
            program.speakerId = speakerId ?? ""
            program.locationId = locationId ?? ""
            _setViewLoading()
            APIManager.shared.uploadProgram(program: program) { [weak self] result in
                guard let strongSlf = self else {
                    return
                }
                self?._setViewNotLoading()
                switch result {
                case .failure(let error):
                    let alert = UIAlertController(title: "Error", message: "Cannot submit Event. Error: \(error.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    alert.preferredAction = alert.actions.last
                    strongSlf.present(alert, animated: true)
                case .success(_):
                    let alert = UIAlertController(title: "Info", message: "Event was successfully submitted.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.speakerID.rawValue)
                        KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.speakerName.rawValue)
                        KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.locationID.rawValue)
                        KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.locationName.rawValue)
                        strongSlf.navigationController?.popViewController(animated: true)
                    }))
                    alert.preferredAction = alert.actions.last
                    strongSlf.present(alert, animated: true)
                }
            }
          
        }
       
    }
    
    private func _showValidationAlert (message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        alert.preferredAction = alert.actions.last
        present(alert, animated: true)
    }

    
    
    //MARK: - ACTIONS
    
    @IBAction func actionCross(_ sender: UIButton) {
        
        KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.speakerID.rawValue)
        KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.speakerName.rawValue)
        KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.locationID.rawValue)
        KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.locationName.rawValue)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionLocation(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        vc.isComing = "Search Location"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonSelectDateAction(_ sender: UIButton) {
       
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
           
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePickerAction))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePickerAction))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)

        txtFldDate.inputAccessoryView = toolbar
        txtFldDate.inputView = datePicker
        txtFldDate.becomeFirstResponder()
       
    }
    
    
    @IBAction func buttonSelectTimeAction(_ sender: UIButton) {
       
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
        datePicker.minuteInterval = 15
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTimePickerAction))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePickerAction))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)

        txtFldTime.inputAccessoryView = toolbar
        txtFldTime.inputView = datePicker
        txtFldTime.becomeFirstResponder()
        
    }
    
    @IBAction func actionSpeaker(_ sender: UIButton) {
      
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        vc.isComing = "Speaker"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionSubmitEvent(_ sender: Any) {
        validateData ()
  
}
    
    @IBAction func actionSelectionSource(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectBrandViewController") as! SelectBrandViewController
        vc.modalPresentationStyle = .popover
      
        if sender.tag == 1 || sender.tag == 2 {
            guard let brandId = brandId else {
                var fieldString = "Presentation"
                if sender.tag == 1 {
                    fieldString = "Program Type"
                }
                let alert = UIAlertController(title: "Warning", message: "Please select Brand before selecting \(fieldString)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
                return
            }
            vc.selectedBrandId = brandId
        }
        if let realm = RealmManager.shared.getMainRealm() {
            if sender.tag == 0 {
                vc.selectionSource = "brand"
                let objects = realm.objects(Brand.self)
                vc.preferredContentSize = CGSize(width: sender.frame.width, height: CGFloat(objects.count*45))
            }
            else if sender.tag == 2 {
                vc.selectionSource = "type"
                if let object = realm.objects(Brand.self).filter("brandId == %@", vc.selectedBrandId).first {
                    var count = 0
                    for item in object.programTypes {
                    count += 1
                    vc.preferredContentSize = CGSize(width: sender.frame.width, height: CGFloat(count*40))
                    }
                }
            }
            else if sender.tag == 1 {
                vc.selectionSource = "presentationId"
                if let object = realm.objects(Brand.self).filter("brandId == %@", vc.selectedBrandId).first {
                    var count = 0
                    for item in object.presentations {
                        count += 1
                        vc.preferredContentSize = CGSize(width: sender.frame.width, height: CGFloat(count*45))
                        }
                    }
                }
            
            else if sender.tag == 3 {
                vc.selectionSource = "timezone"
                let objects = realm.objects(TimeZone.self)
                vc.preferredContentSize = CGSize(width: sender.frame.width, height: CGFloat(objects.count*45))
                
            }
        }

        vc.delegate = self
        let popOver : UIPopoverPresentationController = vc.popoverPresentationController!
        popOver.sourceView = sender
        popOver.delegate = self
        popOver.permittedArrowDirections = .any
        self.navigationController?.present(vc, animated: false, completion: nil)
    }
    
}


extension CreateEventVC : UIPopoverPresentationControllerDelegate,SelectBrandViewControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
     
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
     
    }
    //MARK: - SelectBrandViewControllerDelegate
    
    func selectBrand(_ selectBrand: SelectBrandViewController, didSelectId: Int, title: String, forType: String) {
        print("Success")
        if forType == "brand" {
          
            brandId = didSelectId
            txtFldBrand.text = title
        }
        else if forType == "type" {
            programtypeId = didSelectId
            txtFldProgramType.text = title
        }
        else if forType == "presentationId" {
            presentationId = didSelectId
            txtFldPresentation.text = title
        }
        else if forType == "timezone" {
            timzoneId = didSelectId
            txtFldTimeZone.text = title
        }
        dismiss(animated: true)
    }
}

