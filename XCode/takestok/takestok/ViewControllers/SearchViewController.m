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
#import "Advert.h"
#import "ImageCacheUrlResolver.h"
#import "BackgroundImageView.h"
#import "NSDate+Extended.h"
#import "AdvertDetailViewController.h"
#import "SearchTitleView.h"
#import "ServerConnectionHelper.h"
#import "SortData.h"
#import "NSDictionary+HandleNil.h"
#import "Settings.h"

#define CellTitleFont [UIFont fontWithName:@"HelveticaNeue-Bold" size:16]
#define CellOtherFont [UIFont fontWithName:@"HelveticaNeue" size:16]
#define CellPriceFont [UIFont fontWithName:@"HelveticaNeue-Bold" size:24]
#define SmallMargin 4
#define LongMargin 10

@implementation SearchViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    _filterData = [NSArray arrayWithObjects:@"Beverages", @"Bakery", @"Sweets & Snacks", @"Finished goods", @"Ingradients", @"Condiments", @"Nuts & dried fruit", @"Herbs, spices & flavourings", @"Other", nil];
    _selectedFilterData = [[NSMutableSet alloc] init];
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    _adverts = [NSMutableArray array];
    int defaultSort = [Settings getSearchSort];
    if (defaultSort > 0){
        NSArray* sortData = [SortData getAll];
        int index = [sortData indexOfObjectPassingTest:^BOOL(SortData*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return obj.ident == defaultSort;
        }];
        if (index != NSNotFound)
            _sortData = [sortData objectAtIndex:index];
    }
    
    if (!_sortData)
        _sortData = [SortData getAll].firstObject;
    
    
    [_searchCollectionView registerNib:[UINib nibWithNibName:@"SearchTitleView" bundle:nil] forSupplementaryViewOfKind:TitleSuplementaryViewKind withReuseIdentifier:TitleSuplementaryViewKind];
    [_searchCollectionView registerNib:[UINib nibWithNibName:@"SearchFilterSortView" bundle:nil] forSupplementaryViewOfKind:SearchFilterSuplementaryViewKind withReuseIdentifier:SearchFilterSuplementaryViewKind];
    
    SerachCollectionViewLayout* layout = (SerachCollectionViewLayout*)_searchCollectionView.collectionViewLayout;
    layout.numberOfColumns = 2;
    layout.cellPadding = 10;
    layout.delegate = self;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = OliveMainColor;
    [_refreshControl addTarget:self action:@selector(reloadData:) forControlEvents:UIControlEventValueChanged];
    [_searchCollectionView addSubview:_refreshControl];
    
    _loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _loadingIndicator.color = OliveMainColor;
    _loadingIndicator.hidesWhenStopped = YES;
    [_loadingIndicator stopAnimating];
    [_searchCollectionView addSubview:_loadingIndicator];
    
    [self reloadData:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.backItem.title = @"Home";
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [_searchCollectionView.collectionViewLayout invalidateLayout];
    [self reposRefreshControl];
}

-(void)reposRefreshControl{
    float height = [SearchTitleView defaultHeight];
    if (_searchFilterSortView){
        height += [_searchFilterSortView height];
    }else{
        height += [SearchFilterSortView defaultHeight];
    }
    CGRect r = [_refreshControl.subviews objectAtIndex:0].frame;
    r.origin.y = height / 2.;
    [[_refreshControl.subviews objectAtIndex:0] setFrame:r];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"AdvertSelectedSegue"]) {
        AdvertDetailViewController* prodVC = (AdvertDetailViewController*)segue.destinationViewController;
        [prodVC setAdvert:sender];
    }
}

-(void)loadData{
    [[ServerConnectionHelper sharedInstance] loadAdvertWithSortData:_sortData page:_page compleate:^(NSArray *adverbs, NSDictionary* additionalData, NSError *error) {
        if (error){
            _page = 0;
            UIAlertController* errorController = [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* closeAction = [UIAlertAction
                                          actionWithTitle:@"Ok"
                                          style:UIAlertActionStyleCancel
                                          handler:^(UIAlertAction * action)
                                          {
                                              [errorController dismissViewControllerAnimated:YES completion:nil];
                                              
                                          }];
            
            
            [errorController addAction:closeAction];
            
            [self presentViewController:errorController animated:YES completion:nil];
        }
        else
        {
            _searchTitleView.countResultLabel.text = [NSString stringWithFormat:@"%@",[additionalData objectForKeyNotNull:@"count"]];
            if ([additionalData objectForKeyNotNull:@"next"]){
                _page ++;
            }else{
                _page = 0;
            };
            [_adverts addObjectsFromArray:adverbs];
            [_searchCollectionView reloadData];
        }
        [_loadingIndicator stopAnimating];
        if (_refreshControl.isRefreshing)
            [_refreshControl endRefreshing];
        _searchCollectionView.contentInset = UIEdgeInsetsZero;
    }];
}

-(void)reloadData:(id)owner{
    _page = 1;
     _searchTitleView.countResultLabel.text = @"Loading...";
    [_adverts removeAllObjects];
    [_searchCollectionView reloadData];
    [_refreshControl beginRefreshing];
    [self loadData];
}

-(void)setSearchText:(NSString*)searchText{
    _searchText = searchText;
    if (self.isViewLoaded)
        [self reloadData:nil];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _adverts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchCollectionViewCell* cell = (SearchCollectionViewCell*)[collectionView
                                                               dequeueReusableCellWithReuseIdentifier:@"SearchCollectionViewCell" forIndexPath:indexPath];
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    if (_page > 0 && indexPath.row > _adverts.count -2){
        _loadingIndicator.center = CGPointMake(_searchCollectionView.center.x, _searchCollectionView.contentSize.height + 22);
        _searchCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
        [_loadingIndicator startAnimating];
        [self loadData];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(SearchCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    Advert* adv = [_adverts objectAtIndex:indexPath.row];
    Image* image = [adv.images firstObject];
    
    [cell.imageView loadImage:image];
    
    cell.titleLabel.text = adv.name;
    cell.locationLabel.text = adv.location;
    
    cell.dateLabel.text = [NSDate stringFromTimeInterval:adv.expires];
    
    cell.priceLabel.text = [NSString stringWithFormat:@"%.02f", adv.guidePrice];
}

-(int)heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    Advert* adv = [_adverts objectAtIndex:indexPath.row];
    float height = 172;
    Image* image = [adv.images firstObject];
    if (image){
        height += image.height * (_searchCollectionView.frame.size.width - 30) / 2 / image.width;
    }else{
        height += 176;
    }
    return height;
}

-(int)heightForsuplementaryViewOfKind:(NSString*)kind{
    if ([kind isEqualToString:SearchFilterSuplementaryViewKind]) {
        float height = [SearchFilterSortView defaultHeight];
        if (_searchFilterSortView){
            height = [_searchFilterSortView height];
        }
        return height;
    }
    else if ([kind isEqualToString:TitleSuplementaryViewKind]) {
        return [SearchTitleView defaultHeight];
    }
    return 0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if ([kind isEqualToString:SearchFilterSuplementaryViewKind]) {
        if (!_searchFilterSortView){
            _searchFilterSortView = (SearchFilterSortView*)[collectionView dequeueReusableSupplementaryViewOfKind:SearchFilterSuplementaryViewKind withReuseIdentifier:SearchFilterSuplementaryViewKind forIndexPath:indexPath];
            _searchFilterSortView.delegate = self;
        }
        reusableview = _searchFilterSortView;
    }
    else if ([kind isEqualToString:TitleSuplementaryViewKind]) {
        if (!_searchTitleView){
            _searchTitleView = (SearchTitleView*)[collectionView dequeueReusableSupplementaryViewOfKind:TitleSuplementaryViewKind withReuseIdentifier:TitleSuplementaryViewKind forIndexPath:indexPath];
        }
        _searchTitleView.searchWordLabel.text = _searchText.length > 0 ? _searchText : @"SHOW ALL";
        reusableview = _searchTitleView;
    }
    
    return reusableview;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"AdvertSelectedSegue" sender:[_adverts objectAtIndex:indexPath.row]];
}

#pragma mark - SerachFilterSortDelegate

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

-(NSArray*)sortItems{
    return [SortData getAll];
}

-(SortData*)getSelectedSortItem{
    return _sortData;
}

-(void)sortItemSelected:(SortData*)item{
    if (item.ident != _sortData.ident){
        _sortData = item;
        [Settings setSearchSort:_sortData.ident];
        [self reloadData:nil];
    }
}

@end
