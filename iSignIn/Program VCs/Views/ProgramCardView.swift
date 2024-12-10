//
//  ProgramCardView.swift
//  iSignIn
//
//  Created by Dmitrij on 2023-02-08.
//

import UIKit

class ProgramCardView: UIView {
    
    @IBOutlet weak var viewBox: UIView!
    @IBOutlet weak var labelProgramId: UILabel!
    @IBOutlet weak var viewSpeakerBackground: UIView!
    @IBOutlet weak var labelSpeaker: UILabel!
    @IBOutlet weak var labelRepTitle: UILabel!
    @IBOutlet weak var labelRepValue: UILabel!
    @IBOutlet weak var labelBrandTitle: UILabel!
    @IBOutlet weak var labelBrandValue: UILabel!
    @IBOutlet weak var labelVenueTitle: UILabel!
    @IBOutlet weak var labelVenueValue: UILabel!
    @IBOutlet weak var buttonOpenProgram: UIButton!
    
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
        viewBox.layer.masksToBounds = false
       viewBox.layer.shadowColor = UIColor.gray.cgColor
        viewBox.layer.shadowOffset =  CGSize.zero
       viewBox.layer.shadowOpacity = 0.5
       viewBox.layer.shadowRadius = 4
        labelProgramId.textColor = .textColorBlue()
        viewSpeakerBackground.layer.cornerRadius = 4.0
        viewSpeakerBackground.backgroundColor = .mainNavigationBarColor()
        labelSpeaker.textColor = .mainTextGradientColor(bounds: CGRect(origin: CGPoint.zero, size: labelSpeaker.sizeThatFits(CGSize.zero)))
        labelRepTitle.text = "Representative"
        labelBrandTitle.text = "Brand"
        labelVenueTitle.text = "Venue"
        buttonOpenProgram.layer.cornerRadius = 4.0
        buttonOpenProgram.layer.borderColor = UIColor.tertiaryLabel.cgColor
        buttonOpenProgram.layer.borderWidth = 1.0
        
    }

    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ProgramCardView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

}
