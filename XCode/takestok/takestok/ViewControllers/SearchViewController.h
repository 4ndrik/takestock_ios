//
//  SearchViewController.h
//  takestok
//
//  Created by Artem on 4/8/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SearchFilterSortView.h"
#import "SearchTitleView.h"
#import "SearchCollectionViewLayout.h"
#import "CategoryViewController.h"
#import "SearchCollectionViewCell.h"

@class SortData;
@class TSBaseDictionaryEntity;

@interface SearchViewController : BaseViewController{
    UILabel* _titleLabel;
    
    __weak IBOutlet UIButton *_sortButton;
    __weak IBOutlet UIButton *_categoryButton;
    __weak IBOutlet UICollectionView *_searchCollectionView;
    
    NSMutableArray* _adverts;
    NSString* _searchText;
    TSBaseDictionaryEntity* _searchCategory;
    UIRefreshControl *_refreshControl;
    SortData* _sortData;
    int _page;
    UIActivityIndicatorView* _loadingIndicator;
    
    UIView* _sortView;
}

-(void)setSearchText:(NSString*)searchText;
-(void)setCategory:(TSBaseDictionaryEntity*)category;
- (IBAction)selectCategory:(id)sender;
- (IBAction)selectSort:(id)sender;


@end
