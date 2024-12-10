//
//  AddFaceVC.swift
//  EventManagement
//
//  Created by meet sharma on 05/07/23.
//

import UIKit

class AddFaceVC: UIViewController {

    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    //MARK: - ACTIONS
    
    @IBAction func actionBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionScanMyFace(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SuccesPopUpVC") as! SuccesPopUpVC
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true)
    }
    
}
