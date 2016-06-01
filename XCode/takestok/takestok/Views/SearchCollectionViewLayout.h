//
//  SearchCollectionViewLayout.h
//  takestok
//
//  Created by Artem on 4/15/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TitleSuplementaryViewKind @"TitleSuplementaryViewKind"
#define SearchFilterSuplementaryViewKind @"SearchFilterSuplementaryViewKind"

@protocol SearchCollectionViewLayoutProtocol <NSObject>

@required
-(int)heightForRowAtIndexPath:(NSIndexPath*)indexPath;
-(int)heightForsuplementaryViewOfKind:(NSString*)kind;

@end

@interface SearchCollectionViewLayout : UICollectionViewLayout{
    float contentHeight;
    NSMutableArray* _layoutAtributes;
    NSMutableArray* _noPaddingAtributes;
    UICollectionViewLayoutAttributes* _alwaysVisibleLayoutAttribute;
    float _alwaysVisibleDefaultY;
}

@property int numberOfColumns;
@property int cellPadding;
@property (weak) id<SearchCollectionViewLayoutProtocol>delegate;

@end
