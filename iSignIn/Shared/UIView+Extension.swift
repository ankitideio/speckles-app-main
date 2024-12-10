//
//  UIView+Extension.swift
//  iSignIn
//
//  Created by meet sharma on 20/07/23.
//

import Foundation
import UIKit

extension UIView{
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    @IBInspectable var cornerRadis: CGFloat {
       get {
         return layer.cornerRadius
       }
       set {
         layer.cornerRadius = newValue
         layer.masksToBounds = newValue > 0
       }
     }
    @IBInspectable var topCornerRadius: CGFloat {
        get {
          return layer.cornerRadius
        }
        set {
          layer.cornerRadius = newValue
          layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
      }
    @IBInspectable var scornerRadibotton: CGFloat {
        get {
          return layer.cornerRadius
        }
        set {
          layer.cornerRadius = newValue
          layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
      }
      @IBInspectable var sTopBottomcornerRadibotton: CGFloat {
        get {
          return layer.cornerRadius
        }
        set {
          layer.cornerRadius = newValue
          layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        }
      }
      @IBInspectable var sbothTopcornerRadibotton: CGFloat {
        get {
          return layer.cornerRadius
        }
        set {
          layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        }
      }
      @IBInspectable var sbothbottomcornerRadibotton: CGFloat {
        get {
          return layer.cornerRadius
        }
        set {
          layer.cornerRadius = newValue
          layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
      }
      @IBInspectable var sbothleftCornerRadibotton: CGFloat {
        get {
          return layer.cornerRadius
        }
        set {
          layer.cornerRadius = newValue
          layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
      }
    
    @discardableResult
    func addLineDashedStroke(pattern: [NSNumber]?, radius: CGFloat, color: CGColor,view:UIView) -> CALayer {
        let borderLayer = CAShapeLayer()

        borderLayer.strokeColor = color
        borderLayer.lineDashPattern = pattern
        borderLayer.frame = bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius)).cgPath

        layer.addSublayer(borderLayer)
        return borderLayer
    }
    
    func dropShadow2(scale: Bool = true,cornerRadius: Float) {
           self.layer.masksToBounds = false
           self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.09).cgColor
           self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 4
       }
  
}


