//
//  PKDrawing+Extensions.swift
//  iSignIn
//
//  Created by Dmitrij on 2023-01-05.
//

import PencilKit

extension PKDrawing {
  
  func image(from rect: CGRect, scale: CGFloat, userInterfaceStyle: UIUserInterfaceStyle) -> UIImage {
    let currentTraits = UITraitCollection.current
    UITraitCollection.current = UITraitCollection(userInterfaceStyle: userInterfaceStyle)
    let image = self.image(from: rect, scale: scale)
    UITraitCollection.current = currentTraits
    return image
  }
}
