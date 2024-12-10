//
//  ProgramsCollectionViewFlowLayout.swift
//  iSignIn
//
//  Created by Dmitrij on 2023-03-13.
//

import Foundation
import UIKit

class ISCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private var _cellHeight: CGFloat
    
    init(cellHeight: CGFloat) {
        self._cellHeight = cellHeight
        super.init()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }

    func widestCellWidth(bounds: CGRect) -> CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }

        let insets = collectionView.contentInset
        var width = (bounds.width - insets.left - insets.right - 10.0) / 2.0
        if UIDevice.current.userInterfaceIdiom == .phone {
            width = (bounds.width - insets.left - insets.right)
        }
        
        if width < 0 { return 0 }
        else { return width }
    }
    
    func updateEstimatedItemSize(bounds: CGRect) {
        estimatedItemSize = CGSize(
            width: widestCellWidth(bounds: bounds),
            height: _cellHeight
        )
    }

    override func prepare() {
        super.prepare()

        let bounds = collectionView?.bounds ?? .zero
        updateEstimatedItemSize(bounds: bounds)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else {
            return false
        }
        
        let oldSize = collectionView.bounds.size
        guard oldSize != newBounds.size else { return false }
        
        updateEstimatedItemSize(bounds: newBounds)
        return true
    }
}
