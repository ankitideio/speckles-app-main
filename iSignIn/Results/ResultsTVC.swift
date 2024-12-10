//
//  ResultsTVC.swift
//  EventManagement
//
//  Created by meet sharma on 04/07/23.
//

import UIKit

class ResultsTVC: UITableViewCell {
    
    //MARK: - OUTLETS
    @IBOutlet weak var lblCityTitle: UILabel!
    @IBOutlet weak var lblCityState: UILabel!
    @IBOutlet weak var lblDegree: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblNPI: UILabel!
    @IBOutlet weak var btnLearnMore: UIButton!
    @IBOutlet weak var vwDetail: UIView!
    @IBOutlet weak var vwDegree: UIView!
    @IBOutlet weak var vwNPI: UIView!
    @IBOutlet weak var lblFirstNameTitle: UILabel!
    @IBOutlet weak var lblLastNameTitle: UILabel!
    @IBOutlet weak var hightBtn: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
   
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
