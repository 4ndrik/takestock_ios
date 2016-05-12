//
//  SerachCollectionViewLayout.m
//  takestok
//
//  Created by Artem on 4/15/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "SerachCollectionViewLayout.h"

@implementation SerachCollectionViewLayout

-(void)prepareLayout{
    _layoutAtributes = [NSMutableArray array];
    
    float startY = 0;
    
    UICollectionViewLayoutAttributes* atribute;
    float h;
    
    _noPaddingAtributes = [NSMutableArray array];
    
    atribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:TitleSuplementaryViewKind withIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    h = [_delegate heightForsuplementaryViewOfKind:TitleSuplementaryViewKind];
    atribute.frame = CGRectMake(0, 0, self.collectionView.frame.size.width, h);
    [_layoutAtributes addObject:atribute];
    startY += h;
    [_noPaddingAtributes addObject:atribute];
    
    atribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:SearchFilterSuplementaryViewKind withIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    h = [_delegate heightForsuplementaryViewOfKind:SearchFilterSuplementaryViewKind];
    atribute.frame = CGRectMake(0, startY, self.collectionView.frame.size.width, h);
    [_layoutAtributes addObject:atribute];
    _alwaysVisibleLayoutAttribute = atribute;
    _alwaysVisibleDefaultY = startY;
    [_noPaddingAtributes addObject:atribute];
    
    startY += h;
    startY += _cellPadding;
    
    float width = (self.collectionView.frame.size.width - _cellPadding * (_numberOfColumns + 1))/2;
    
    float *yOffset = (float *)malloc(sizeof(float) * _numberOfColumns);
    for (int i = 0; i < _numberOfColumns; i++) {
        yOffset[i] = startY;
    }
    
    for (NSInteger index = 0; index < [self.collectionView numberOfItemsInSection:0]; index ++){
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        float height = [_delegate heightForRowAtIndexPath:indexPath];
        
        float x = _cellPadding;
        float y = CGFLOAT_MAX;
        int minIndex = 0;
        for (int i = 0; i < _numberOfColumns; i++) {
            if (y > yOffset[i]){
                y = yOffset[i];
                minIndex = i;
            }
        }
        
        yOffset[minIndex] = y + height + _cellPadding;
        x = width * minIndex + _cellPadding * (minIndex + 1);
        
        UICollectionViewLayoutAttributes* atribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath ];
        atribute.frame = CGRectMake(x, y, width, height);
        
        [_layoutAtributes addObject:atribute];
        
    }
    
    contentHeight = 0;
    for (int i = 0; i < _numberOfColumns; i++) {
        if (contentHeight < yOffset[i]){
            contentHeight = yOffset[i];
        }
    }
    contentHeight = MAX(yOffset[0], yOffset[1]);
}

-(CGSize)collectionViewContentSize{
    return CGSizeMake(self.collectionView.frame.size.width, contentHeight);
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray* result = [NSMutableArray array];
    
    for (UICollectionViewLayoutAttributes* atribute in _layoutAtributes) {
        if (CGRectIntersectsRect(atribute.frame, rect)){
            [result addObject:atribute];
        }
    }
    
    if ([result indexOfObject:_alwaysVisibleLayoutAttribute] == NSNotFound){
        [result addObject:_alwaysVisibleLayoutAttribute];
    }
    
    if (self.collectionView.contentOffset.y < 0){
        float y = 0;
        for (UICollectionViewLayoutAttributes* atribute in _noPaddingAtributes){
            atribute.frame = CGRectMake(0, self.collectionView.contentOffset.y + y, self.collectionView.bounds.size.width, atribute.frame.size.height);
            y += atribute.frame.size.height;
        }
    }else{
        _alwaysVisibleLayoutAttribute.zIndex = 1024;
        _alwaysVisibleLayoutAttribute.frame = CGRectMake(0, self.collectionView.contentOffset.y > _alwaysVisibleDefaultY ? self.collectionView.contentOffset.y : _alwaysVisibleDefaultY, self.collectionView.bounds.size.width, _alwaysVisibleLayoutAttribute.frame.size.height);
    }
    
    return result;
}

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    return YES;
}

@end
