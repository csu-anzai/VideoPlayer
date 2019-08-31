//
//  TopAlignedCollectionViewFlowLayout.swift
//  QuipperVideoPlayer
//
//  Created by Ahmed Ali on 2019/08/31.
//  Copyright © 2019 Ahmed Ali. All rights reserved.
//

import UIKit

/// A UICollectionViewFlowLayout that ensures all cells are top aligned.
///
/// This is particularly very helpful when you have cells with dynamic heights
/// and you want to ensure they are all top algined instead of the default center alignemnt.
class TopAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)?
            .map { $0.copy() } as? [UICollectionViewLayoutAttributes]
        
        attributes?
            .filter { $0.representedElementCategory == .cell }
            .reduce([:]) { accumulatedDictionary, cellAttribute in
                // convert to dictionary of type [CGFloat: Array<UICollectionViewLayoutAttributes>]
                // All cells with the same center.y will be in the same array.
                accumulatedDictionary.merging([ceil(cellAttribute.center.y): [cellAttribute]]) { $0 + $1 }
            }
            .values.forEach { row in
                let maxHeightY = row.max {
                    $0.frame.size.height < $1.frame.size.height
                    }?.frame.origin.y
                
                row.forEach { // adjust offset for each cell in row so that they all top align.
                    $0.frame = $0.frame.offsetBy(
                        dx: 0,
                        dy: (maxHeightY ?? $0.frame.origin.y) - $0.frame.origin.y
                    )
                }
        }
        
        return attributes
    }
    
}
