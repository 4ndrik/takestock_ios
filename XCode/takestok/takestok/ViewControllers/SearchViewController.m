//
//  SearchViewController.m
//  takestok
//
//  Created by Artem on 4/8/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchFilterSortView.h"
#import "SearchCollectionViewCell.h"

@implementation SearchViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    _filterData = [NSArray arrayWithObjects:@"Beverages", @"Bakery", @"Sweets & Snacks", @"Finished goods", @"Ingradients", @"Condiments", @"Nuts & dried fruit", @"Herbs, spices & flavourings", @"Other", nil];
    _selectedFilterData = [[NSMutableSet alloc] init];
    _sortData = [NSArray arrayWithObjects:@"Newest post", @"Oldest post", @"Guide price (hight to low)", @"Guide price (low to hight)", @"Soonest expiry date", @"Longest expiry date", nil];
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout*)_searchCollectionView.collectionViewLayout;
    layout.sectionHeadersPinToVisibleBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.backItem.title = @"Home";
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [_searchCollectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0){
        return 0;
    }else
        return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchCollectionViewCell* cell = (SearchCollectionViewCell*)[collectionView
                                                               dequeueReusableCellWithReuseIdentifier:@"SearchCollectionViewCell" forIndexPath:indexPath];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0){
        return UIEdgeInsetsZero;
    }else{
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((collectionView.frame.size.width - 30) / 2 , 300);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 1){
        float height = [SearchFilterSortView defaultHeight];
        if (_searchFilterSortView){
            height = [_searchFilterSortView height];
        }
        return CGSizeMake(collectionView.frame.size.width, height);
            
    }else{
        return CGSizeZero;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0){
        return CGSizeMake(collectionView.frame.size.width, 150);
    }else
        return CGSizeZero;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        if (!_searchFilterSortView){
            _searchFilterSortView = (SearchFilterSortView*)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SearchFilterSortView" forIndexPath:indexPath];
            _searchFilterSortView.delegate = self;
        }
        reusableview = _searchFilterSortView;
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"SearchTitleView" forIndexPath:indexPath];
        
        reusableview = footerview;
    }
    
    return reusableview;
}

#pragma mark = SerachFilterSortDelegate

-(float)panelWidth{
    return _searchCollectionView.frame.size.width;
}

-(void)panelTypeChanged{
    [self.view setNeedsUpdateConstraints];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    [_searchCollectionView reloadData];
}

-(NSArray*)filterData{
    return _filterData;
}

-(NSMutableSet*)selectedFilterData{
    return _selectedFilterData;
}

-(void)filterItem:(NSString*)item selected:(BOOL)selected{
    if (selected){
        [_selectedFilterData addObject:item];
    }else{
        [_selectedFilterData removeObject:item];
    }
}

-(NSArray*)sortData{
    return _sortData;
}

-(void)sortItemSelected:(NSString*)item{
    
}

@end
