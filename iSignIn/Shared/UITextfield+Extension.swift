//
//  UITextfield+Extension.swift
//  iSignIn
//
//  Created by meet sharma on 20/07/23.
//

import Foundation
import UIKit

extension UITextField{
    
    @IBInspectable var cornerRadi: CGFloat {
       get {
         return layer.cornerRadius
       }
       set {
         layer.cornerRadius = newValue
         layer.masksToBounds = newValue > 0
       }
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
    
    @IBInspectable var paddingLeftCustom: CGFloat {
         get {
             return leftView!.frame.size.width
         }
         set {
             let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
             leftView = paddingView
             leftViewMode = .always
         }
     }

     @IBInspectable var paddingRightCustom: CGFloat {
         get {
             return rightView!.frame.size.width
         }
         set {
             let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
             rightView = paddingView
             rightViewMode = .always
         }
     }
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    func setupRightImage(imageName:String){
        
      let imageView = UIImageView(frame: CGRect(x: 20, y: 12, width: 15, height: 15))
      imageView.image = UIImage(named: imageName)
      let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
      imageContainerView.addSubview(imageView)
      rightView = imageContainerView
      rightViewMode = .always
      self.tintColor = .lightGray
        
  }
    
    
}

extension NSMutableAttributedString {
    
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)

        // Swift 4.2 and above
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)

        // Swift 4.1 and below
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }

}
