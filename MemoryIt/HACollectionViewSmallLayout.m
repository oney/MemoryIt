//
//  HACollectionViewSmallLayout.m
//  Paper
//
//  Created by Heberti Almeida on 04/02/14.
//  Copyright (c) 2014 Heberti Almeida. All rights reserved.
//

#import "HACollectionViewSmallLayout.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@implementation HACollectionViewSmallLayout

- (id)init
{
    if (!(self = [super init])) return nil;
    
    self.itemSize = CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] bounds])-20, CGRectGetHeight([[UIScreen mainScreen] bounds]));
    self.sectionInset = UIEdgeInsetsMake((iPhone5 ? 314-30 : 224-30), -70, 0, 2);
//    self.minimumInteritemSpacing = 10.0f;
    self.minimumLineSpacing = -145.0f;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return NO;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes* attributes in array) {
        attributes.transform3D = CATransform3DMakeScale(0.5, 0.5, 1.0);
    }
    return array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // returns the layout attributes for the item at the specified index path
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    attributes.transform3D = CATransform3DMakeScale(0.5, 0.5, 1.0);
    return attributes;
}

@end
