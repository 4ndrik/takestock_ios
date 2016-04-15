//
//  ProductDetailViewController.m
//  takestok
//
//  Created by Artem on 4/13/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ImageCollectionViewCell.h"
#import "Advert.h"
#import "BackgroundImageView.h"
#import "TitleTextContainerView.h"
#import "NSDate+Extended.h"

@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController

-(void)setAdvert:(Advert*)advert{
    _advert = advert;
    
    if (self.isViewLoaded){
        [self refreshAdData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_advert)
        [self refreshAdData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshAdData{
    _priceTextContainerView.text = [NSString stringWithFormat:@"%.02f", _advert.guidePrice];
    [_priceTextContainerView setNeedsDisplay];
    
    _minimumOrderTextContainerView.text = @"";
    if (_minimumOrderTextContainerView.text.length == 0){
        _minimumOrderHeightConstraint.constant = 0;
    }
    _qtyAvailableTextContainerView.text = @"";
    if (_qtyAvailableTextContainerView.text.length == 0){
        _qtyAvailableHeightConstraint.constant = 0;
        [_qtyAvailableTextContainerView setNeedsUpdateConstraints];
    }
    _descriptionTextView.text = _advert.adDescription;
    _locationTextContainerView.text = _advert.location;
    if (_locationTextContainerView.text.length == 0){
        _locationHeightConstraint.constant = 0;
    }
    _shippingTextContainerView.text = @"";
    if (_shippingTextContainerView.text.length == 0){
        _shippingHeightConstraint.constant = 0;
    }
    _expiryTextContainerView.text = [NSDate stringFromTimeInterval:_advert.expires];
    _certeficationTextContainerView.text = @"";
    if (_certeficationTextContainerView.text.length == 0){
        _certificationHeightConstraint.constant = 0;
    }
    _conditionTextContainerView.text = @"";
    if (_conditionTextContainerView.text.length == 0){
        _conditionHeightConstraint.constant = 0;
    }
    [self.view setNeedsUpdateConstraints];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _advert.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCollectionViewCell* cell = (ImageCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageViewCell" forIndexPath:indexPath];
    [(BackgroundImageView*)cell.imageView loadImage:[_advert.images objectAtIndex:indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width - 40, collectionView.frame.size.height - 40);
}


@end
