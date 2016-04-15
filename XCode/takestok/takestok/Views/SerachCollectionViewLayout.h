//
//  SerachCollectionViewLayout.h
//  takestok
//
//  Created by Artem on 4/15/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TitleSuplementaryViewKind @"TitleSuplementaryViewKind"
#define SearchFilterSuplementaryViewKind @"SearchFilterSuplementaryViewKind"

@protocol SerachCollectionViewLayoutProtocol <NSObject>

@required
-(int)heightForRowAtIndexPath:(NSIndexPath*)indexPath;
-(int)heightForsuplementaryViewOfKind:(NSString*)kind;

@end

@interface SerachCollectionViewLayout : UICollectionViewLayout{
    float contentHeight;
    NSMutableArray* _layoutAtributes;
    UICollectionViewLayoutAttributes* _alwaysVisibleLayoutAttribute;
    float _alwaysVisibledefaultY;
}

@property int numberOfColumns;
@property int cellPadding;
@property (weak) id<SerachCollectionViewLayoutProtocol>delegate;

@end
