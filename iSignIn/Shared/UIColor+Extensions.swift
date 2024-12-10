//
//  UIColor+Extensions.swift
//  iSignIn
//
//  Created by Dmitrij on 2022-12-26.
//

import Foundation
import UIKit
import Kingfisher

extension UIColor {
    
    static func mainNavigationBarColor () -> UIColor {
        return UIColor(red: 254.0 / 255.0, green: 241.0 / 255.0, blue: 243.0 / 255.0, alpha: 1.0)
    }
    
    static func mainOrangeColor () -> UIColor {
        return UIColor(red: 243.0 / 255.0, green: 118.0 / 255.0, blue: 43.0 / 255.0, alpha: 1.0)
    }
    
    static func mainYellowColor () -> UIColor {
        return UIColor(red: 254.0 / 255.0, green: 192.0 / 255.0, blue: 24.0 / 255.0, alpha: 1.0)
    }
    
    static func mainYellowColorWithAlpha (_ alpha: CGFloat) -> UIColor {
        return UIColor(red: 254.0 / 255.0, green: 192.0 / 255.0, blue: 24.0 / 255.0, alpha: alpha)
    }
    
    static func mainYellowColor2 () -> UIColor {
        return UIColor(red:252/255.0, green: 180/255, blue:21/255, alpha:1.0)
    }
    
    static func greenTitleColor () -> UIColor {
        return UIColor(red: 21.0 / 255.0, green: 85.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)
    }
    
    static func greenSubtitleColor () -> UIColor {
        return UIColor(red: 76.0 / 255.0, green: 114.0 / 255.0, blue: 120.0 / 255.0, alpha: 1.0)
    }
    
    static func mainGradientColor1(alpha: Double) -> UIColor {
        return UIColor(red: 252.0 / 255.0, green: 180.0 / 255.0, blue: 21.0 / 255.0, alpha: alpha)
    }
    
    static func mainGradientColor2(alpha: Double) -> UIColor {
        return UIColor(red: 241.0 / 255.0, green: 115.0 / 255.0, blue: 135.0 / 255.0, alpha: alpha)
    }
    
    static func mainGradientColor3(alpha: Double) -> UIColor {
        return UIColor(red: 189.0 / 255.0, green: 103.0 / 255.0, blue: 156.0 / 255.0, alpha: alpha)
    }
    
    static func mainGradientColor4(alpha: Double) -> UIColor {
        return UIColor(red: 243.0 / 255.0, green: 128.0 / 255.0, blue: 111.0 / 255.0, alpha: alpha)
    }
    
    static func textGradientColor1(alpha: Double) -> UIColor {
        return UIColor(red: 222.0 / 255.0, green: 111.0 / 255.0, blue: 143.0 / 255.0, alpha: alpha)
    }
    
    static func textGradientColor2(alpha: Double) -> UIColor {
        return UIColor(red: 191.0 / 255.0, green: 103.0 / 255.0, blue: 158.0 / 255.0, alpha: alpha)
    }
    
    static func textFieldBackgroundDefaultColor () -> UIColor {
        return UIColor(red: 248.0 / 255.0, green: 246.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
    }
    
    static func backgroundGrayColor () -> UIColor {
        return UIColor(red: 249.0 / 255.0, green: 249.0 / 255.0, blue: 249.0 / 255.0, alpha: 1.0)
    }
    
    static func textFieldBorderDefaultColor () -> UIColor {
        return UIColor(red: 226.0 / 255.0, green: 224.0 / 255.0, blue: 223.0 / 255.0, alpha: 1.0)
    }
    
    static func textColorBlue () -> UIColor {
        return UIColor(red: 11.0 / 255.0, green: 128.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }
    
    static func textColorRed () -> UIColor {
        return UIColor(red: 216.0 / 255.0, green: 40.0 / 255.0, blue: 79.0 / 255.0, alpha: 1.0)
    }
    
    static func textFieldBackgroundHighlightedColor (bounds: CGRect) -> UIColor {
        let gradient = UIImage.gradientImage(bounds: bounds, colors: [.mainGradientColor1(alpha: 0.1), .mainGradientColor2(alpha: 0.1), .mainGradientColor3(alpha: 0.1)])
        return UIColor(patternImage: gradient)
    }
    
    static func textFieldBorderHighlightedColor (bounds: CGRect) -> UIColor {

        let gradient = UIImage.gradientImage(bounds: bounds, colors: [.mainGradientColor3(alpha: 1.0), .mainGradientColor2(alpha: 1.0), .mainGradientColor1(alpha: 1.0)])
        return UIColor(patternImage: gradient)
    }
    
    static func buttonBackgroundGradientColor1 (bounds: CGRect) -> UIColor {
        let gradient = UIImage.gradientImage(bounds: bounds, colors: [.mainGradientColor1(alpha: 1.0), .mainGradientColor4(alpha: 1.0)])
        return UIColor(patternImage: gradient)
    }
    
    static func buttonBackgroundGradientColor2 (bounds: CGRect) -> UIColor {
        let gradient = UIImage.gradientImage(bounds: bounds, colors: [UIColor(red: 255.0 / 255.0, green: 248.0 / 255.0, blue: 232.0 / 255.0, alpha: 1.0), UIColor(red: 253.0 / 255.0, green: 242.0 / 255.0, blue: 240.0 / 255.0, alpha: 1.0)])
        return UIColor(patternImage: gradient)
    }
    
    static func programBackgroundGradientColor1 (bounds: CGRect) -> UIColor {
        let gradient = UIImage.gradientImage(bounds: bounds, colors: [UIColor(red: 254.0 / 255.0, green: 241.0 / 255.0, blue: 242.0 / 255.0, alpha: 1.0), UIColor(red: 248.0 / 255.0, green: 240.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)])
        return UIColor(patternImage: gradient)
    }
    
    static func programBackgroundGradientColor2 (bounds: CGRect) -> UIColor {
        let gradient = UIImage.gradientImage(bounds: bounds, colors: [UIColor(red: 240.0 / 255.0, green: 114.0 / 255.0, blue: 135.0 / 255.0, alpha: 1.0), UIColor(red: 189.0 / 255.0, green: 103.0 / 255.0, blue: 156.0 / 255.0, alpha: 1.0)])
        return UIColor(patternImage: gradient)
    }
    
    static func mainTextGradientColor (bounds: CGRect) -> UIColor {
        let gradient = UIImage.gradientImage(bounds: bounds, colors: [.textGradientColor1(alpha: 1.0), .textGradientColor2(alpha: 1.0)])
        return UIColor(patternImage: gradient)
    }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
}

extension UIImage {
    static func gradientImage(bounds: CGRect, colors: [UIColor]) -> UIImage {
        guard colors.count > 1 else {
            return UIImage()
        }

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map(\.cgColor)
        
        var location = 0.0
        let step = 1.0 / Double(colors.count - 1)
        var locations = [NSNumber]()
        for _ in colors {
            locations.append(NSNumber(value: location))
            location += step
        }

        let renderer = UIGraphicsImageRenderer(bounds: bounds)

        return renderer.image { ctx in
            gradientLayer.render(in: ctx.cgContext)
        }
    }
}

extension UIImageView{
    func imageLoad(imageUrl:String)   {
        let url = URL(string:imageUrl)
        self.kf.indicatorType = .activity
        
        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: "Image 1"),
            options: [.cacheOriginalImage,
                .transition(.fade(0.25)),
                .cacheOriginalImage
            ])
      }
}
