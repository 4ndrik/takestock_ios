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

#import "SerachCollectionViewLayout.h"

@interface SearchViewController : BaseViewController<SerachCollectionViewLayoutProtocol, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, SerachFilterSortDelegate>{
    
    __weak IBOutlet UICollectionView *_searchCollectionView;
    NSArray* _filterData;
    NSMutableSet* _selectedFilterData;
    NSArray* _sortData;
    SearchFilterSortView* _searchFilterSortView;
    NSMutableArray* _adverts;
    NSString* _searchText;
    UIRefreshControl *_refreshControl;
}

-(void)setSearchText:(NSString*)searchText;

@end
