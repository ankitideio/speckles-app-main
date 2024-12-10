//
//  ScannerVC.swift
//  EventManagement
//
//  Created by meet sharma on 04/07/23.
//

import UIKit

class ScannerVC: UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet private weak var vwScanner: UIView!
    @IBOutlet private weak var lblHeader: UILabel!
    
    //MARK: - VARIABLES
    
    var isComing = false
    
    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     uiData()
      
    }
    
    //MARK: - STATUSBAR STYLE
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    //MARK: - FUNCTIONS
    
    private func uiData(){
        
        if isComing == true{
            lblHeader.text = "Scan QR Code"
        }else{
            lblHeader.text = "Scan ID"
        }
        vwScanner.addLineDashedStroke(pattern: [3, 3], radius: 24, color: UIColor.white.cgColor, view: vwScanner)
    }
    
    //MARK: - ACTIONS
    
    @IBAction func actionBtnCamera(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    

}

