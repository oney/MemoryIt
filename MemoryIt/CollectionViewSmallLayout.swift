//
//  CollectionViewSmallLayout.swift
//  MemoryIt
//
//  Created by SpoonRocket on 2014/10/27.
//  Copyright (c) 2014年 one. All rights reserved.
//

import UIKit

class CollectionViewSmallLayout: UICollectionViewFlowLayout {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.itemSize = CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds)-20, CGRectGetHeight(UIScreen.mainScreen().bounds))
        self.sectionInset = UIEdgeInsetsMake(314-30, -70, 0, 2);
        //    self.minimumInteritemSpacing = 10.0f;
        self.minimumLineSpacing = -145.0
        self.scrollDirection = UICollectionViewScrollDirection.Horizontal
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return false
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var array: [UICollectionViewLayoutAttributes] = super.layoutAttributesForElementsInRect(rect) as [UICollectionViewLayoutAttributes]
        for attributes: UICollectionViewLayoutAttributes in array {
            attributes.transform3D = CATransform3DMakeScale(0.5, 0.5, 1.0);
        }
        return array
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        var attributes: UICollectionViewLayoutAttributes = super.layoutAttributesForItemAtIndexPath(indexPath)
        attributes.transform3D = CATransform3DMakeScale(0.5, 0.5, 1.0)
        return attributes
    }
}
