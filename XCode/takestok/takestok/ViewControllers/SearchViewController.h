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
#import "SerachCollectionViewLayout.h"

@class SortData;
@interface SearchViewController : BaseViewController<SerachCollectionViewLayoutProtocol, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, SerachFilterSortDelegate>{
    
    __weak IBOutlet UICollectionView *_searchCollectionView;
    NSArray* _filterData;
    NSMutableSet* _selectedFilterData;
    SearchFilterSortView* _searchFilterSortView;
    SearchTitleView* _searchTitleView;
    NSMutableArray* _adverts;
    NSString* _searchText;
    UIRefreshControl *_refreshControl;
    BOOL _loading;
    SortData* _sortData;
    int _page;
    UIActivityIndicatorView* _loadingIndicator;
}

-(void)setSearchText:(NSString*)searchText;

@end
