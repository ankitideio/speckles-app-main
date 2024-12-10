//
//  ContactUsVC.swift
//  EventManagement
//
//  Created by meet sharma on 05/07/23.
//

import UIKit

class ContactUsVC: UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet private weak var txtVwMessage: UITextView!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var txtFldEmail: UITextField!
    @IBOutlet private weak var txtFldName: UITextField!
    
    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uiSet()
    }
    
    //MARK: - FUNCTION
    
    private func uiSet(){
        txtVwMessage.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        let stringValue = "We’re here to help! Send us your query via the form below or send us an email at frictionlesssolutions@gmail.com for any issue you’re facing"
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
        attributedString.setColorForText(textForAttribute: "We’re here to help! Send us your query via the form below or send us an email at", withColor: UIColor.black)
        attributedString.setColorForText(textForAttribute: "frictionlesssolutions@gmail.com", withColor: UIColor(red: 243/255, green: 118/255, blue: 43/255, alpha: 1.0))
        attributedString.setColorForText(textForAttribute: "for any issue you’re facing", withColor: UIColor.black)
        lblTitle.font = UIFont(name: "Lato-Regular", size: 14.0)
        lblTitle.attributedText = attributedString
        
    }
    
    //MARK: - ACTIONS
    
    @IBAction func actionBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func actionSubmit(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    

}

