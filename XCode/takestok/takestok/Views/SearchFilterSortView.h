//
//  SearchHeaderView.h
//  takestok
//
//  Created by Artem on 4/8/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NibLoadView.h"

@class SortData;

@protocol SearchFilterSortDelegate <NSObject>

@required
-(float)panelWidth;
-(void)panelTypeChanged;
-(NSArray*)filterData;
-(NSMutableSet*)selectedFilterData;
-(void)filterItem:(NSString*)item selected:(BOOL)selected;

-(NSArray*)sortItems;
-(SortData*)getSelectedSortItem;
-(void)sortItemSelected:(SortData*)item;

@end

typedef enum {
    kNone,
    kFilter,
    kSort
} PanelType;

@interface SearchFilterSortView : UICollectionReusableView<UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate>{
    
    __weak IBOutlet UIButton *_filterButton;
    __weak IBOutlet UIButton *_sortButton;
    __weak IBOutlet UIView *_contentView;
    PanelType _paneltype;
    float height;
}

@property (nonatomic ,assign)id<SearchFilterSortDelegate>delegate;

+(float)defaultHeight;
-(float)height;

- (IBAction)showFilterPanelAction:(id)sender;
- (IBAction)showSortPanelAction:(id)sender;

@end
