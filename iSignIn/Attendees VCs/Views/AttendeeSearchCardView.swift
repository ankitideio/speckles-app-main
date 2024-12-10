//
//  AttendeeSearchCardView.swift
//  iSignIn
//
//  Created by Dmitrij on 2023-02-14.
//

import UIKit

class AttendeeSearchCardView: UIView {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDegree: UILabel!
    @IBOutlet weak var labelCityState: UILabel!
    @IBOutlet weak var labelNPI: UILabel!
        
    
    @IBOutlet weak var viewBox: UIView!
    
    var contentView: UIView?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
        
        viewBox.layer.cornerRadius = 4.0
        viewBox.layer.borderWidth = 1.0
        viewBox.layer.borderColor = UIColor.tertiaryLabel.cgColor
        
    }

    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AttendeeSearchCardView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

}
