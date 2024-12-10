//
//  AddExpensesVC.swift
//  iSignIn
//
//  Created by meet sharma on 25/07/23.
//

import UIKit
import RealmSwift

class AddExpensesVC: UIViewController {

    //MARK: - OUTLETS

    @IBOutlet weak var txtFldCostName: UITextField!
    @IBOutlet weak var txtFldAmount: UITextField!
    @IBOutlet weak var imgRecipt: UIImageView!
    @IBOutlet weak var btnRecipt: UIButton!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var vwIndigater: UIActivityIndicatorView!
    
    //MARK: - VARIABLES
    var arrReceipt = [UIImage(named: "")]
    var costId = 0
    var programId = 0
    private var data = ""
    
    
    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCross.isHidden = true
        
    }
    

    
    func convertImageToBase64(image: UIImage) -> String? {
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            return imageData.base64EncodedString()
        }
        return nil
    }

    private func _setViewLoading () {
        view.isUserInteractionEnabled = false
        vwIndigater.startAnimating()
    }
    
    private func _setViewNotLoading () {
        view.isUserInteractionEnabled = true
        vwIndigater.stopAnimating()
    }
    
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionCross(_ sender: Any) {
        imgRecipt.image = UIImage(named: "")
        btnCross.isHidden = true
        btnRecipt.isHidden = false
    }
    
    @IBAction func actionCost(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CostPopUpVC") as! CostPopUpVC
        vc.modalPresentationStyle = .popover
        vc.callBack = { (costId , name) in
            self.costId = costId
            self.txtFldCostName.text = name
            print(costId)
        }
        let popOver : UIPopoverPresentationController = vc.popoverPresentationController!
        popOver.sourceView = sender
        popOver.delegate = self
        popOver.permittedArrowDirections = .any
        self.navigationController?.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func actionRecipt(_ sender: UIButton) {
        
        ImagePicker().pickImage(self){ image in
          self.arrReceipt.insert(image, at: 0)
            self.imgRecipt.image = image
            self.btnRecipt.isHidden = true
            self.btnCross.isHidden = false
            if let base64String = self.convertImageToBase64(image: image) {
              self.data = base64String
              print(self.data)
            } else {
              print("Failed to convert image to Base64.")
            }
       
        }
    }
    
    @IBAction func actionSubmit(_ sender: UIButton) {
        if txtFldCostName.text == "" {
            
            _showValidationAlert(message: "Cost name cannot be empty")
            
        }else if txtFldAmount.text == ""{
            
            _showValidationAlert(message: "Amount cannot be empty")
            
        }else{
            let costData = Costs()
            costData.actual = txtFldAmount.text ?? ""
            costData.estimate = txtFldAmount.text ?? ""
            costData.label = txtFldCostName.text ?? ""
            costData.cost_item_id = costId
            costData.programId = programId
            costData.data = data
            
            _setViewLoading ()
            APIManager.shared.createCost(cost:costData) { [weak self] result in
                guard let strongSlf = self else {
                    return
                }
                self?._setViewNotLoading ()
                switch result {
                case .failure(let error):
                    let alert = UIAlertController(title: "Error", message: "Cannot upload Expense. Error: \(error.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    alert.preferredAction = alert.actions.last
                    strongSlf.present(alert, animated: true)
                case .success(_):
                    let alert = UIAlertController(title: "Info", message: "Expense was successfully uploaded.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        
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
    
    }


extension AddExpensesVC : UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
}
