//
//  SearchVC.swift
//  EventManagement
//
//  Created by meet sharma on 04/07/23.
//

import UIKit
import RealmSwift

class SearchVC: UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var txtFldDegree: UITextField!
    @IBOutlet private weak var txtFldLastName: UITextField!
    @IBOutlet private weak var txtFldFirstName: UITextField!
    @IBOutlet private weak var txtFldCity: UITextField!
    @IBOutlet private weak var txtFldState: UITextField!
    @IBOutlet private weak var txtFldNPI: UITextField!
    @IBOutlet weak var txtFldSpecialty: UITextField!
    @IBOutlet weak var vwSpecilty: UIView!
    @IBOutlet weak var vwCityState: UIView!
    @IBOutlet weak var btnMedPro: UIButton!
    @IBOutlet weak var vwSearchType: UIView!
    @IBOutlet weak var vwType: UIView!
    @IBOutlet weak var btnCustomerMaster: UIButton!
    @IBOutlet weak var vwNpi: UIView!
    @IBOutlet weak var vwDegree: UIView!
    @IBOutlet weak var vwLastName: UIView!
    @IBOutlet weak var btnVenue: UIButton!
    @IBOutlet weak var btnOffice: UIButton!
    
    //MARK: - VARIABLE
    
    var isComing:String?
    var idDegree:String?
    var idSpecialty:String?
    var iso:String?
    var locationType:String?
    var _currentProgram:Program?
 
    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiSet()
    }
    
    //MARK: - FUNCTION
    
    func uiSet(){
        btnMedPro.isSelected = true
        btnCustomerMaster.isSelected = false
        btnOffice.isSelected = true
        btnVenue.isSelected = false
        locationType = "belongsToHcp"
        
        if isComing == "Search"{
            lblTitle.text = "Search"
            vwSpecilty.isHidden = true
            vwType.isHidden = true
        }else if isComing == "Search Location"{
            lblTitle.text = "Search Location"
            vwSpecilty.isHidden = true
            vwDegree.isHidden = true
            vwLastName.isHidden = true
            vwSearchType.isHidden = true
            vwNpi.isHidden = true
            txtFldFirstName.placeholder = "Location Name"
        }else{
            lblTitle.text = "Search Speaker"
            vwCityState.isHidden = true
            vwSearchType.isHidden = true
            vwType.isHidden = true
        }
        
    }
    
    //MARK: - ACTIONS
    
    @IBAction func actionBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
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
    @IBAction func actionSearch(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResultsVC") as! ResultsVC
        vc._currentProgram = self._currentProgram
        if isComing == "Search"{
            
            vc.serchParam = ["firstName":txtFldFirstName.text ?? "","lastName":txtFldLastName.text ?? "","degree":idDegree ?? "","city":txtFldCity.text ?? "","state":iso ?? "","npi":txtFldNPI.text ?? ""]
            
        } else if isComing == "Search Location"{
            
            vc.isCommingFor = "Search Location"
            vc.serchParam = ["label":txtFldFirstName.text ?? "","scopes":locationType ?? "","city":txtFldCity.text ?? "","state":iso ?? ""]
            
        }else{
            
            vc.isCommingFor = "searchSpeakar"
            vc.serchParam = ["firstName":txtFldFirstName.text ?? "","lastName":txtFldLastName.text ?? "","degree":idDegree ?? "","specialty":idSpecialty ?? "","npi":txtFldNPI.text ?? ""]
            
        }
        
     
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionCustomerMaster(_ sender: UIButton) {
        
        btnMedPro.isSelected = false
        btnCustomerMaster.isSelected = true
   
    }
    
    @IBAction func actionStates(_ sender: UIButton) {
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
    
    @IBAction func actionMedpro(_ sender: UIButton) {
        btnMedPro.isSelected = true
        btnCustomerMaster.isSelected = false
 
    }
    
    @IBAction func actionOffice(_ sender: UIButton) {
        btnVenue.isSelected = false
        btnOffice.isSelected = true
        locationType = "belongsToHcp"
    }
    
    @IBAction func btnVenue(_ sender: UIButton) {
        btnOffice.isSelected = false
        btnVenue.isSelected = true
        locationType = "belongsToVenue"
    }
}

extension SearchVC : UIPopoverPresentationControllerDelegate,SelectBrandViewControllerDelegate,SelectStateViewControllerDelegate {
    
    func selectState(_ selectBrand: SelectBrandViewController, didSelectId: String, title: String, forType: String) {
        txtFldState.text = title
        iso = didSelectId
        dismiss(animated: true)
    }
    
    
    //MARK: - SelectBrandViewControllerDelegate
    
    func selectBrand(_ selectBrand: SelectBrandViewController, didSelectId: Int, title: String, forType: String) {
        print("Success")
        if forType == "Degree" {
            idDegree = "\(didSelectId)"
            txtFldDegree.text = title
        }else if forType == "Speaciality"{
            idSpecialty = "\(didSelectId)"
            txtFldSpecialty.text = title
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
