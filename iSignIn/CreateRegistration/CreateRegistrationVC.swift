//
//  CreateRegistrationVC.swift
//  EventManagement
//
//  Created by meet sharma on 04/07/23.
//

import UIKit
import RealmSwift
import PencilKit

class CreateRegistrationVC: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var scrollVw: UIScrollView!
    @IBOutlet private weak var txtFldLicenseState: UITextField!
    @IBOutlet private weak var txtFldLicense: UITextField!
    @IBOutlet private weak var txtFldDegree: UITextField!
    @IBOutlet private weak var txtFldEmail: UITextField!
    @IBOutlet private weak var txtFldFirsName: UITextField!
    @IBOutlet private weak var txtFldLastName: UITextField!
    @IBOutlet private weak var txtFldAddress: UITextField!
    @IBOutlet private weak var txtFldCity: UITextField!
    @IBOutlet private weak var txtFldZip: UITextField!
    @IBOutlet private weak var txtFldState: UITextField!
    @IBOutlet private weak var txtFldPhoneNumber: UITextField!
    @IBOutlet private weak var txtFldSpeciality: UITextField!
    @IBOutlet private weak var txtFldNPI: UITextField!
    @IBOutlet private weak var txtFldMiddleName: UITextField!
    @IBOutlet private weak var btnYes: UIButton!
    @IBOutlet private weak var btnNo: UIButton!
    @IBOutlet private weak var switchMN: UISwitch!
    @IBOutlet private weak var switchNJ: UISwitch!
    @IBOutlet private weak var switchVT: UISwitch!
    @IBOutlet private weak var vwSign: PKCanvasView!
    @IBOutlet private weak var switchNoShow: UISwitch!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imgVwBack: UIImageView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    //MARK: - Veriables
    
    private var canvasInUse = false
    private var stateLisanceISO:String?
    var programId:Int?
    var _currentProgram:Program?
    var isCreate = false
    var _searchResults:Attendee?
    private var isSignature = false
    var callBack:((_ attendee:Program)->())?
    var idDegree:Int?
    var idSpeciality:Int?
    var mealConsumption = false
    var stateMN = false
    var stateNJ = false
    var stateVT = false
    var stateiSO:String?
    
    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiData()
   
    }

    //MARK: - FUNCTIONS
    
    private func uiData(){
        indicator.isHidden = true
        if isCreate == false{
            
            imgVwBack.image = UIImage(named: "Vector 2")
            print(self._currentProgram ?? "")
            print(self._searchResults ?? "")
            self.txtFldFirsName.text = _searchResults?.firstName
            self.txtFldMiddleName.text = _searchResults?.middleName
            self.txtFldLastName.text = _searchResults?.lastName
            self.txtFldAddress.text = _searchResults?.address
            self.txtFldCity.text = _searchResults?.city
            self.txtFldZip.text =  _searchResults?.postalCode
            self.txtFldState.text =  _searchResults?.stateProvince
            self.txtFldPhoneNumber.text = _searchResults?.phone
            self.txtFldEmail.text = _searchResults?.email
            self.txtFldDegree.text = _searchResults?.degree
            self.txtFldSpeciality.text = _searchResults?.speciality
            self.txtFldNPI.text = _searchResults?.npi
            self.txtFldLicense.text = _searchResults?.licenceNumber
            self.txtFldLicenseState.text = _searchResults?.licenceState
            self.stateiSO = _searchResults?.stateProvince
            self.stateLisanceISO = _searchResults?.licenceState
            self.idDegree = Int(_searchResults?.degreeType ?? "")
            if let data = _searchResults?.submitSignatureDrawingData {
                if let drawing = try? PKDrawing(data: data) {
                vwSign.drawing = drawing
                }
            }
            if self._searchResults?.submitMealConsumtion == true{
                self.btnYes.isSelected = true
                self.btnNo.isSelected = false
                self.mealConsumption = true
            }else{
                self.btnYes.isSelected = false
                self.btnNo.isSelected = true
                self.mealConsumption = false
            }
            if _searchResults?.submitLicenseMN == true{
                self.switchMN.isOn = true
                stateMN = true
            }else{
                self.switchMN.isOn = false
                stateMN = false
            }
            if _searchResults?.submitLicenseNJ == true{
                self.switchNJ.isOn = true
                stateNJ = true
            }else{
                self.switchNJ.isOn = false
                stateNJ = false
            }
            if _searchResults?.submitLicenseVT == true{
                self.switchVT.isOn = true
                stateVT = true
            }else{
                self.switchVT.isOn = false
                stateVT = false
            }
        }else{
            btnNo.isSelected = true
            btnYes.isSelected = false
            mealConsumption = false
        }
           vwSign.layer.cornerRadius = 8.0
           vwSign.layer.borderWidth = 1.0
           vwSign.layer.borderColor = UIColor.tertiaryLabel.cgColor
           vwSign.overrideUserInterfaceStyle = .light
           vwSign.tool = PKInkingTool(.pen, color: .darkText, width: 10)
           vwSign.drawingPolicy = .anyInput
           vwSign.delegate = self
    }
    
    private func _setViewLoading () {
        indicator.isHidden = false
        view.isUserInteractionEnabled = false
        indicator.startAnimating()
    }
    
    private func _setViewNotLoading () {
        indicator.isHidden = true
        view.isUserInteractionEnabled = true
        indicator.stopAnimating()
    }
    
    
    private func _validateData(){
        if txtFldFirsName.text == ""{
            showValidationAlert(message: "First name cannot be empty")
        }else if txtFldLastName.text == ""{
            showValidationAlert(message: "Last name cannot be empty")
        }else if txtFldAddress.text == ""{
            showValidationAlert(message: "Address cannot be empty")
        }else if txtFldCity.text == ""{
            showValidationAlert(message: "City cannot be empty")
        }else if txtFldZip.text == ""{
            showValidationAlert(message: "Zip code cannot be empty")
        }else if txtFldState.text == ""{
            showValidationAlert(message: "State cannot be empty")
        }else if txtFldDegree.text == ""{
            showValidationAlert(message: "Degree cannot be empty")
        }else if txtFldSpeciality.text == ""{
            showValidationAlert(message: "Speciality cannot be empty")
        }else{
            let image = vwSign.drawing.image(from: vwSign.bounds, scale: 1.0, userInterfaceStyle: .light)
            
            guard let imageData = image.jpegData(compressionQuality: 1.0), !vwSign.drawing.bounds.isEmpty else {
                let alert = UIAlertController(title: "Error", message: "Signature is missed. Please sign here before submit attendee.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                alert.preferredAction = alert.actions.last
                present(alert, animated: true)
                return
            }
            let signatureStr = imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters) ?? ""
            
            let drawingData = vwSign.drawing.dataRepresentation()
            
            let attendee = Attendee()
            attendee.firstName = txtFldFirsName.text ?? ""
            attendee.middleName = txtFldMiddleName.text ?? ""
            attendee.middleInitials = txtFldMiddleName.text ?? ""
            attendee.lastName = txtFldLastName.text ?? ""
            attendee.address = txtFldAddress.text ?? ""
            attendee.city = txtFldCity.text ?? ""
            attendee.postalCode = txtFldZip.text ?? ""
            attendee.stateProvince = stateiSO ?? ""
            attendee.phone = txtFldPhoneNumber.text ?? ""
            attendee.email = txtFldEmail.text ?? ""
            attendee.degree = txtFldDegree.text ?? ""
            attendee.degreeType = "\(idDegree ?? 0)"
            attendee.speciality = txtFldSpeciality.text ?? ""
            attendee.npi = txtFldNPI.text ?? ""
            attendee.licenceNumber = txtFldLicense.text ?? ""
            attendee.submitMealConsumtion = mealConsumption
            attendee.submitLicenseMN = stateMN
            attendee.submitLicenseNJ = stateNJ
            attendee.submitLicenseVT = stateVT
            attendee.signature = signatureStr
            attendee.attId = _searchResults?.attId ?? 0
            attendee.profileId = _searchResults?.profileId ?? 0
            attendee.licenceState = stateLisanceISO ?? ""
            _setViewLoading ()
            APIManager.shared.uploadAttendees(programID: programId, attendee: attendee) { [weak self] result in
                guard let strongSlf = self else {
                    return
                }
                self?._setViewNotLoading()
                switch result {
                case .failure(let error):
                    let alert = UIAlertController(title: "Error", message: "Cannot register. Error: \(error.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    alert.preferredAction = alert.actions.last
                    strongSlf.present(alert, animated: true)
                case .success(_):
                    let alert = UIAlertController(title: "Info", message: "Registration was successfully submitted.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                      
                        strongSlf.navigationController?.popViewController(animated: true)
                    }))
                    alert.preferredAction = alert.actions.last
                    strongSlf.present(alert, animated: true)
                }
            }
            
        }
        
        
    }
    
    private func showValidationAlert (message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        alert.preferredAction = alert.actions.last
        present(alert, animated: true)
    }
    //MARK: - ACTIONS
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionState(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectBrandViewController") as! SelectBrandViewController
        vc.modalPresentationStyle = .popover
      
       
        if let realm = RealmManager.shared.getMainRealm() {
           
                vc.selectionSource = "State"
                let objects = realm.objects(States.self)
                vc.preferredContentSize = CGSize(width: sender.frame.width, height: CGFloat(objects.count*45))
                
            }
        vc.delegateState = self
        let popOver : UIPopoverPresentationController = vc.popoverPresentationController!
        popOver.sourceView = sender
        popOver.delegate = self
        popOver.permittedArrowDirections = .any
        self.navigationController?.present(vc, animated: false, completion: nil)
    }
    @IBAction func actionDegree(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectBrandViewController") as! SelectBrandViewController
        vc.modalPresentationStyle = .popover
      
       
        if let realm = RealmManager.shared.getMainRealm() {
           
                vc.selectionSource = "Degree"
                let objects = realm.objects(Degrees.self)
                vc.preferredContentSize = CGSize(width: sender.frame.width, height: CGFloat(objects.count*45))
                
            }
        vc.delegate = self
        let popOver : UIPopoverPresentationController = vc.popoverPresentationController!
        popOver.sourceView = sender
        popOver.delegate = self
        popOver.permittedArrowDirections = .any
        self.navigationController?.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func actionSubmit(_ sender: UIButton) {
    
        _validateData()
    }
    
    @IBAction func actionLicenseState(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectBrandViewController") as! SelectBrandViewController
        vc.modalPresentationStyle = .popover
      
       
        if let realm = RealmManager.shared.getMainRealm() {
           
                vc.selectionSource = "StateLicance"
                let objects = realm.objects(States.self)
                vc.preferredContentSize = CGSize(width: sender.frame.width, height: CGFloat(objects.count*45))
                
            }
        vc.delegateState = self
        let popOver : UIPopoverPresentationController = vc.popoverPresentationController!
        popOver.sourceView = sender
        popOver.delegate = self
        popOver.permittedArrowDirections = .any
        self.navigationController?.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func actionSpeciality(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectBrandViewController") as! SelectBrandViewController
        vc.modalPresentationStyle = .popover
      
       
        if let realm = RealmManager.shared.getMainRealm() {
           
                vc.selectionSource = "Speaciality"
                let objects = realm.objects(Specialities.self)
                vc.preferredContentSize = CGSize(width: sender.frame.width, height: CGFloat(objects.count*45))
                
            }
        vc.delegate = self
        let popOver : UIPopoverPresentationController = vc.popoverPresentationController!
        popOver.sourceView = sender
        popOver.delegate = self
        popOver.permittedArrowDirections = .any
        self.navigationController?.present(vc, animated: false, completion: nil)
    }
    
    
    @IBAction func ActionYes(_ sender: UIButton) {
        self.btnYes.isSelected = true
        self.btnNo.isSelected = false
        mealConsumption = true

    }
    
    @IBAction func ActionNo(_ sender: UIButton) {
        self.btnYes.isSelected = false
        self.btnNo.isSelected = true
        mealConsumption = false
    }
    
    @IBAction func actionMN(_ sender: UISwitch) {
        if switchMN.isOn == true{
            stateMN = true
        }else{
            stateMN = false
        }
        
    }
    
    @IBAction func actionNJ(_ sender: UISwitch) {
        if switchNJ.isOn == true{
            stateNJ = true
        }else{
            stateNJ = false
        }
    }
    
    @IBAction func actionVT(_ sender: UISwitch) {
        if switchVT.isOn == true{
            stateVT = true
        }else{
            stateVT = false
        }
    }
    
    @IBAction func actionClear(_ sender: UIButton) {
        vwSign.drawing = PKDrawing()
    }
    
    @IBAction func actionNoShow(_ sender: UISwitch) {
        
    }
}

extension CreateRegistrationVC : UIPopoverPresentationControllerDelegate,SelectBrandViewControllerDelegate,SelectStateViewControllerDelegate {

    //MARK: - SelectBrandViewControllerDelegate
    
    func selectBrand(_ selectBrand: SelectBrandViewController, didSelectId: Int, title: String, forType: String) {
        print("Success")
        if forType == "Degree" {
            idDegree = didSelectId
            txtFldDegree.text = title
        }else if forType == "Speaciality"{
            txtFldSpeciality.text = title
            idSpeciality = didSelectId
        }
        
        dismiss(animated: true)
    }
    
    func selectState(_ selectBrand: SelectBrandViewController, didSelectId: String, title: String, forType: String) {
        if forType == "StateLicance"{
            txtFldLicenseState.text = title
            stateLisanceISO = didSelectId
        }else{
            txtFldState.text = title
            stateiSO = didSelectId
        }
       
        dismiss(animated: true)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
}

extension CreateRegistrationVC:PKCanvasViewDelegate{
    //MARK: - PKCanvasViewDelegate
    func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
        canvasInUse = true
        scrollVw.isScrollEnabled = false
    }
    func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
        canvasInUse = false
        guard UIDevice.current.userInterfaceIdiom != .pad else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if !self.canvasInUse {
                self.scrollVw.isScrollEnabled = true
            }
        }
    }
}
