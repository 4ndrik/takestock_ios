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
#import "ProductDetailViewController.h"

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
    
    _adverts = [Advert getAll];
    UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout*)_searchCollectionView.collectionViewLayout;
    if ([layout respondsToSelector:@selector(setSectionHeadersPinToVisibleBounds:)])
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"AdvertSelectedSegue"]) {
        ProductDetailViewController* prodVC = (ProductDetailViewController*)segue.destinationViewController;
        [prodVC setAdvert:sender];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0){
        return 0;
    }else
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
    
    cell.imageHeightConstraint.constant = image.height * (collectionView.frame.size.width - 30) / 2 / image.width;
    
    [cell.imageView loadImage:image];
    
    cell.titleLabel.text = adv.name;
    cell.locationLabel.text = adv.location;
    
    cell.dateLabel.text = [NSDate stringFromTimeInterval:adv.expires];
    
    cell.priceLabel.text = [NSString stringWithFormat:@"%.02f", adv.guidePrice];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0){
        return UIEdgeInsetsZero;
    }else{
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float width = (collectionView.frame.size.width - 30) / 2;
    float height = 0;
    Advert* adv = [_adverts objectAtIndex:indexPath.row];
    Image* image = [adv.images firstObject];
    
    height += image.height * (collectionView.frame.size.width - 30) / 2 / image.width;
    
    CGSize labelSize = CGSizeMake(width - 8, CGFLOAT_MAX);
    
    //title height
    height += LongMargin;
    height += [adv.name boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:CellTitleFont} context:nil].size.height;
    
    //Location height
    height += SmallMargin;
    height += [adv.location boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:CellOtherFont} context:nil].size.height;
    
    //Date height
    height += SmallMargin;
    height += [[NSDate stringFromTimeInterval:adv.expires] boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:CellOtherFont} context:nil].size.height;
    
    //Price
    height += LongMargin;
    height += [@"Guide price" boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:CellOtherFont} context:nil].size.height;
    
    height += SmallMargin;
    height += [@"per Kg" boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:CellOtherFont} context:nil].size.height;
    
    height += SmallMargin;
    height += [[NSString stringWithFormat:@"%.02f", adv.guidePrice] boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:CellPriceFont} context:nil].size.height;
    height += LongMargin;
    return CGSizeMake((collectionView.frame.size.width - 30) / 2 , height);
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
