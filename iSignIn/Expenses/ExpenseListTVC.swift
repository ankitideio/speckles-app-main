//
//  ExpenseListTVC.swift
//  iSignIn
//
//  Created by Apple on 25/07/23.
//

import UIKit

class ExpenseListTVC: UITableViewCell {
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var lblCostItem: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

}
