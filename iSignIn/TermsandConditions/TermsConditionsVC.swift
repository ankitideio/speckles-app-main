//
//  TermsConditionsVC.swift
//  EventManagement
//
//  Created by meet sharma on 05/07/23.
//

import UIKit

class TermsConditionsVC: UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet private weak var txtVwTermCondition: UITextView!
    @IBOutlet private weak var lblHeader: UILabel!
    
    //MARK: - VARIABLE
    
    var isComing = ""
    
    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()

       uiSet()
    }
    
    //MARK: - FUNCTIONS
    
    func uiSet(){
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        let attributes = [NSAttributedString.Key.paragraphStyle : style]
        self.txtVwTermCondition.typingAttributes = attributes
        if isComing == "Term"{
            self.lblHeader.text = "Terms and Conditions"
            self.txtVwTermCondition.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever sinceremaining essentially unchanged. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever sinceremaining essentially unchanged. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever sinceremaining essentially unchanged.\n\n Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever sinceremaining essentially unchanged. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever sinceremaining essentially unchanged. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever sinceremaining essentially unchanged.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever sinceremaining essentially unchanged. Lorem Ipsum is simply dummy text of the printing and typesetting industry."
        }else if isComing == "Privacy"{
            self.lblHeader.text = "Privacy & Policy"
            self.txtVwTermCondition.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever sinceremaining essentially unchanged. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever sinceremaining essentially unchanged. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever sinceremaining essentially unchanged.\n\n Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever sinceremaining essentially unchanged. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever sinceremaining essentially unchanged. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever sinceremaining essentially unchanged."
        }else{
            self.lblHeader.text = "About us"
            self.txtVwTermCondition.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever sinceremaining essentially unchanged. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever sinceremaining essentially unchanged. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever sinceremaining essentially unchanged.\n\n Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever sinceremaining essentially unchanged. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever sinceremaining essentially unchanged. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever sinceremaining essentially unchanged."
        }
    }
    
    //MARK: - ACTION
    
    @IBAction func actionBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    

}
