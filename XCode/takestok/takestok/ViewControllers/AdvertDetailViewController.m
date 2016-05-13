//
//  ProductDetailViewController.m
//  takestok
//
//  Created by Artem on 4/13/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "AdvertDetailViewController.h"
#import "ImageCollectionViewCell.h"
#import "Advert.h"
#import "BackgroundImageView.h"
#import "TitleTextContainerView.h"
#import "NSDate+Extended.h"
#import "ImagesCollectionViewController.h"
#import "TopBottomStripesLabel.h"
#import "BackgroundImageView.h"
#import "RatingView.h"
#import "AppSettings.h"
#import "QAViewController.h"
#import "ServerConnectionHelper.h"
#import "UIViewController+BackButtonHandler.h"

@interface AdvertDetailViewController ()

@end

@implementation AdvertDetailViewController

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(BOOL)navigationShouldPopOnBackButton{
    if (_popToRootViewController){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    return YES;
}

-(void)refreshAdData{
    _titleLabel.text = _advert.name;
    
    _priceTextContainerView.text = [NSString stringWithFormat:@"%.02f £", _advert.guidePrice];
    [_priceTextContainerView setNeedsDisplay];
    
    _minimumOrderTextContainerView.text = [NSString stringWithFormat:@"%i %@", _advert.minOrderQuantity, _advert.packaging ? _advert.packaging.title: @""];
    if (_minimumOrderTextContainerView.text.length == 0){
        _minimumOrderHeightConstraint.constant = 0;
    }
    _qtyAvailableTextContainerView.text = [NSString stringWithFormat:@"%i %@", _advert.count, _advert.packaging ? _advert.packaging.title: @""];
    if (_qtyAvailableTextContainerView.text.length == 0){
        _qtyAvailableHeightConstraint.constant = 0;
        [_qtyAvailableTextContainerView setNeedsUpdateConstraints];
    }
    _descriptionTextView.text = _advert.adDescription;
    _locationTextContainerView.text = _advert.location;
    if (_locationTextContainerView.text.length == 0){
        _locationHeightConstraint.constant = 0;
    }
    _shippingTextContainerView.text = _advert.shipping.title;
    if (_shippingTextContainerView.text.length == 0){
        _shippingHeightConstraint.constant = 0;
    }
    _expiryTextContainerView.text = [NSDate stringFromTimeInterval:_advert.expires];
    
    NSMutableString* certString = [[NSMutableString alloc] initWithString:_advert.certification.title];
    if (_advert.certificationOther.length > 0){
        [certString appendFormat:@", %@", _advert.certificationOther];
    }
    
    _certeficationTextContainerView.text = certString;
    if (_certeficationTextContainerView.text.length == 0){
        _certificationHeightConstraint.constant = 0;
    }
    _conditionTextContainerView.text = _advert.condition.title;
    if (_conditionTextContainerView.text.length == 0){
        _conditionHeightConstraint.constant = 0;
    }
    
    _userName.text = _advert.author.userName;
    [_ratingView setRate:_advert.author.rating];
    
    if (_advert.ident <= 0){
        [_makeButton setTitle:@"Create advert" forState:UIControlStateNormal];
    }else if (_advert.author.ident == [User getMe].ident){
        [_makeButton setBackgroundColor:[UIColor lightGrayColor]];
        _makeButton.enabled = NO;
    }
    
    [self.view setNeedsUpdateConstraints];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

-(void)createOrder{
    return;
    UIAlertController* orderController = [UIAlertController alertControllerWithTitle:@"" message:@"Set price and quantity" preferredStyle:UIAlertControllerStyleAlert];
    [orderController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = @"$1.0";
    }];
    [orderController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = @"kg 1";
    }];
    
    UIAlertAction* makeOrderAction = [UIAlertAction
                                      actionWithTitle:@"Make order"
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction * action)
                                      {
                                          [orderController dismissViewControllerAnimated:YES completion:nil];
                                          
                                      }];
    
    UIAlertAction* cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction * action)
                                   {
                                       [orderController dismissViewControllerAnimated:YES completion:nil];
                                       
                                   }];
    
    [orderController addAction:makeOrderAction];
    [orderController addAction:cancelAction];
    
    [self presentViewController:orderController animated:YES completion:nil];
}

-(void)createAdvert{
    [self showLoading];
    [[ServerConnectionHelper sharedInstance] createAdvert:_advert compleate:^(NSError *error) {
        [self hideLoading];
        NSString* title = @"";
        NSString* message = @"Advert created";
        if (error){
            title = @"Error";
            message = [error localizedDescription];
        }else{
            [_makeButton setBackgroundColor:[UIColor lightGrayColor]];
            _makeButton.enabled = NO;
            _popToRootViewController = YES;
        }
        UIAlertController* errorController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* closeAction = [UIAlertAction
                                      actionWithTitle:@"Ok"
                                      style:UIAlertActionStyleCancel
                                      handler:^(UIAlertAction * action)
                                      {
                                          [errorController dismissViewControllerAnimated:YES completion:nil];
                                          
                                      }];
        
        
        [errorController addAction:closeAction];
        
        [self presentViewController:errorController animated:YES completion:nil];
        

    }];
    
}

- (IBAction)makeAction:(id)sender {
    if (_advert.ident > 0){
        [self createOrder];
    }else {
        [self createAdvert];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ImageSelectedSegue"]) {
        ImagesCollectionViewController* imageVC = (ImagesCollectionViewController*)segue.destinationViewController;
        [imageVC setImages:[_advert.images array] withCurrentIndex:((NSIndexPath*)sender).row];
    }else if ([segue.identifier isEqualToString:@"AQSegue"]){
        QAViewController* aqVC = (QAViewController*)segue.destinationViewController;
        [aqVC setAdvert:_advert];
    }
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"ImageSelectedSegue" sender:indexPath];
}


@end
