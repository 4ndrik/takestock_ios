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

@interface SearchViewController : BaseViewController<SearchCollectionViewLayoutProtocol, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, SearchFilterSortDelegate, CategoryProtocol, WatchListProtocol>{
    
    __weak IBOutlet UICollectionView *_searchCollectionView;
    NSArray* _filterData;
    NSMutableSet* _selectedFilterData;
    SearchFilterSortView* _searchFilterSortView;
    SearchTitleView* _searchTitleView;
    NSMutableArray* _adverts;
    NSString* _searchText;
    TSBaseDictionaryEntity* _searchCategory;
    UIRefreshControl *_refreshControl;
    SortData* _sortData;
    int _page;
    UIActivityIndicatorView* _loadingIndicator;
}

-(void)setSearchText:(NSString*)searchText;
-(void)setCategory:(TSBaseDictionaryEntity*)category;

@end
