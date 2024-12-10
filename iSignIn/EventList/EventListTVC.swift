//
//  EventListTVC.swift
//  EventManagement
//
//  Created by meet sharma on 04/07/23.
//

import UIKit

class EventListTVC: UITableViewCell {
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var vwBackground: UIView!
    @IBOutlet weak var lblEventDate: UILabel!
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var imgVwEvent: UIImageView!
    @IBOutlet weak var btnSeeMore: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
