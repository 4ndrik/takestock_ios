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
    _sortData = [NSArray arrayWithObjects:@"Newest post", @"Oldest post", @"Guide price (hight to low)", @"Guide price (low to hight)", @"Soonest expiry date", @"Longest expiry date", nil];
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    _adverts = [NSMutableArray array];
    
//    _adverts = [Advert getAll];
    
    [_searchCollectionView registerNib:[UINib nibWithNibName:@"SearchTitleView" bundle:nil] forSupplementaryViewOfKind:TitleSuplementaryViewKind withReuseIdentifier:TitleSuplementaryViewKind];
    [_searchCollectionView registerNib:[UINib nibWithNibName:@"SearchFilterSortView" bundle:nil] forSupplementaryViewOfKind:SearchFilterSuplementaryViewKind withReuseIdentifier:SearchFilterSuplementaryViewKind];
    
    SerachCollectionViewLayout* layout = (SerachCollectionViewLayout*)_searchCollectionView.collectionViewLayout;
    layout.numberOfColumns = 2;
    layout.cellPadding = 10;
    layout.delegate = self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(reloadData:) forControlEvents:UIControlEventValueChanged];
    [_searchCollectionView addSubview:refreshControl];
    
//    UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout*)_searchCollectionView.collectionViewLayout;
//    if ([layout respondsToSelector:@selector(setSectionHeadersPinToVisibleBounds:)])
//        layout.sectionHeadersPinToVisibleBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.backItem.title = @"Home";
    [[ServerConnectionHelper sharedInstance] loadAdverb:^(NSArray *adverbs, NSError *error) {
        if (error){
            
        }
        else
        {
            [_adverts addObjectsFromArray:adverbs];
            [_searchCollectionView reloadData];
        }
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [_searchCollectionView.collectionViewLayout invalidateLayout];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"AdvertSelectedSegue"]) {
        AdvertDetailViewController* prodVC = (AdvertDetailViewController*)segue.destinationViewController;
        [prodVC setAdvert:sender];
    }
}

-(void)reloadData:(id)owner{
    NSLog(@"dadas");
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
    Image* image = [adv.images firstObject];
    float height = 164;
    height += image.height * (_searchCollectionView.frame.size.width - 30) / 2 / image.width;
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
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:TitleSuplementaryViewKind withReuseIdentifier:TitleSuplementaryViewKind forIndexPath:indexPath];
        reusableview = footerview;
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

-(NSArray*)sortData{
    return _sortData;
}

-(void)sortItemSelected:(NSString*)item{
    
}

@end
