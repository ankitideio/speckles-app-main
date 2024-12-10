//
//  UIButton+Extension.swift
//  iSignIn
//
//  Created by meet sharma on 20/07/23.
//

import Foundation
import UIKit

extension UIButton{
    
@IBInspectable var cornerRadi: CGFloat {
   get {
     return layer.cornerRadius
   }
   set {
     layer.cornerRadius = newValue
     layer.masksToBounds = newValue > 0
   }
 }
func removeBackgroundImage(for state: UIControl.State) {
       setBackgroundImage(nil, for: state)
   }
 @IBInspectable var borderWid: CGFloat {
   get {
     return layer.borderWidth
   }
   set {
     layer.borderWidth = newValue
   }
 }
 @IBInspectable var borderCol: UIColor? {
   get {
     return UIColor(cgColor: layer.borderColor!)
   }
   set {
     layer.borderColor = newValue?.cgColor
   }
 }
   func underline() {
       
     guard let text = self.titleLabel?.text else { return }
     let attributedString = NSMutableAttributedString(string: text)
     attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
     attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
     attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
     self.setAttributedTitle(attributedString, for: .normal)
       
   }
}


