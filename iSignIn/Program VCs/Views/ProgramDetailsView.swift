//
//  ProgramDetailsView.swift
//  iSignIn
//
//  Created by Dmitrij on 2023-02-09.
//

import UIKit

class ProgramDetailsView: UIView {
    
    @IBOutlet weak var labelProgramId: UILabel!
    @IBOutlet weak var labelProgramDate: UILabel!
    @IBOutlet weak var labelBrand: UILabel!
    @IBOutlet weak var labelRep: UILabel!
    @IBOutlet weak var labelProgramType: UILabel!
    @IBOutlet weak var labelSpeaker: UILabel!
    @IBOutlet weak var labelVenue: UILabel!
    @IBOutlet weak var labelVenueAddress: UILabel!
    @IBOutlet weak var buttonContinue: UIButton!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var viewProgramType: UIView!
    @IBOutlet weak var viewSpeaker: UIView!
    @IBOutlet weak var viewBox: UIView!

    var contentView: UIView?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
        
        viewBox.layer.borderWidth = 1.0
        viewBox.layer.borderColor = UIColor.tertiaryLabel.cgColor
        viewBox.layer.cornerRadius = 4.0
        
        viewProgramType.layer.cornerRadius = 4.0
        
        viewSpeaker.layer.cornerRadius = 4.0
        
        buttonBack.layer.borderWidth = 1.0
        buttonBack.layer.borderColor = UIColor.tertiaryLabel.cgColor
        buttonBack.layer.cornerRadius = 4.0
        buttonBack.setAttributedTitle(NSAttributedString(string: "Back", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16.0, weight: .semibold), NSAttributedString.Key.foregroundColor : UIColor.label]), for: .normal)
        
        buttonContinue.layer.cornerRadius = 4.0
        buttonContinue.backgroundColor = .buttonBackgroundGradientColor1(bounds: buttonContinue.bounds)
        buttonContinue.setAttributedTitle(NSAttributedString(string: "Continue", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16.0, weight: .semibold), NSAttributedString.Key.foregroundColor : UIColor.white]), for: .normal)
        
        labelProgramId.textColor = .textColorBlue()
        
        
       
        
    }

    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ProgramDetailsView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

}
