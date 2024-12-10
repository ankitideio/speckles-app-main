//
//  AttendeeCardView.swift
//  iSignIn
//
//  Created by Dmitrij on 2023-02-10.
//

import UIKit

class AttendeeCardView: UIView {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDegree: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelCityState: UILabel!
    
    @IBOutlet weak var buttonOpenAttendee: UIButton!
    
    @IBOutlet weak var imageViewStatus: UIImageView!
    
    @IBOutlet weak var viewBox: UIView!
    @IBOutlet weak var viewButtonBox: UIView!
    
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

        viewButtonBox.layer.cornerRadius = 4.0
        viewButtonBox.layer.borderWidth = 1.0
        viewButtonBox.layer.borderColor = UIColor.tertiaryLabel.cgColor
        
        buttonOpenAttendee.setTitle("", for: .normal)
        
    }

    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AttendeeCardView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

}
