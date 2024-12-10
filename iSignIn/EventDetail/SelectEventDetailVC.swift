//
//  SelectEventDetailVC.swift
//  EventManagement
//
//  Created by meet sharma on 04/07/23.
//

import UIKit
import RealmSwift
import SwiftKeychainWrapper
import Realm
import Kingfisher


class SelectEventDetailVC: UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var imgVwQrCode: UIImageView!
    @IBOutlet private weak var btnQrCode: UIButton!
    @IBOutlet private weak var lblVenueAddress: UILabel!
    @IBOutlet private weak var viewActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var lblVenue: UILabel!
    @IBOutlet private weak var lblRepresentative: UILabel!
    @IBOutlet private weak var lblSpeaker: UILabel!
    @IBOutlet private weak var lblProgramType: UILabel!
    @IBOutlet private weak var lblBrandName: UILabel!
    @IBOutlet private weak var lblProgramDate: UILabel!
    @IBOutlet private weak var lblProgramId: UILabel!
    @IBOutlet private weak var vwDetail: UIView!
    
    //MARK: - VARIABLES
    
    var currentProgram: Program?
    
    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("FetchCurrentProgram"), object: nil)

        vwDetail.dropShadow2(cornerRadius: 10)
        vwDetail.layer.cornerRadius = 10
        vwDetail.layer.shadowColor = UIColor.black.cgColor
        vwDetail.layer.shadowOpacity = 0.2
        vwDetail.layer.shadowOffset = CGSize.zero
        vwDetail.layer.shadowRadius = 5
    
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        eventDetailApi()
    }
    
    private func eventDetailApi(){
        self.viewActivityIndicator.isHidden = true
        self.lblSpeaker.text =  currentProgram?.speakerName
        self.lblProgramId.text = "\(currentProgram?.programId ?? 0)"
        self.lblBrandName.text = currentProgram?.brand
        self.lblProgramType.text = currentProgram?.programType
        self.lblRepresentative.text = currentProgram?.repName
        self.lblVenue.text = currentProgram?.venue
    
        self.lblVenueAddress.text = "\(currentProgram?.address ?? ""),\(currentProgram?.city ?? ""),\(currentProgram?.stateProvince ?? ""),\(currentProgram?.postalCode ?? "")"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        let dateString = dateFormatter.string(from: currentProgram?.startDate ?? Date())
        self.lblProgramDate.text = dateString
        self.imgVwQrCode.imageLoad(imageUrl: currentProgram?.qr_code_download ?? "")
        
        
    }
    //MARK: - ACTIONS
    
    @IBAction func actionScanner(_ sender: UIButton) {
        
    }
    

}
