//
//  RegistrationTVC.swift
//  EventManagement
//
//  Created by meet sharma on 04/07/23.
//

import UIKit

class RegistrationTVC: UITableViewCell {
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var lblAddres: UILabel!
    @IBOutlet weak var vwDetail: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhoneNo: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
