//
//  ProductDetailViewController.m
//  takestok
//
//  Created by Artem on 4/13/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "AdvertDetailViewController.h"
#import "ImageCollectionViewCell.h"
#import "TSAdvert.h"
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
#import "PaddingTextField.h"
#import "Offer.h"
#import "OfferStatus.h"
#import "UserDetailsViewController.h"
#import "LoginViewController.h"
#import "TSUserEntity.h"
#import "UserServiceManager.h"

@interface AdvertDetailViewController ()

@end

@implementation AdvertDetailViewController

#pragma mark - Life cycle

-(void)setAdvert:(TSAdvert*)advert{
    _advert = advert;
    
    if (self.isViewLoaded){
        [self refreshAdData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
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

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [_priceTextContainerView invalidateIntrinsicContentSize];
    [_minimumOrderTextContainerView invalidateIntrinsicContentSize];
    [_qtyAvailableTextContainerView invalidateIntrinsicContentSize];
    [_locationTextContainerView invalidateIntrinsicContentSize];
    [_shippingTextContainerView invalidateIntrinsicContentSize];
    [_expiryTextContainerView invalidateIntrinsicContentSize];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:ADVERT_IMAGES_SEGUE]) {
        ImagesCollectionViewController* imageVC = (ImagesCollectionViewController*)segue.destinationViewController;
        [imageVC setImages:_advert.photos withCurrentIndex:((NSIndexPath*)sender).row];
    }else if ([segue.identifier isEqualToString:@"QuestionsSegue"]){
            QAViewController* aqVC = (QAViewController*)segue.destinationViewController;
            [aqVC setAdvert:_advert];

//    }else if ([segue.identifier isEqualToString:USER_DETAILS_SEGUE]){
//        UserDetailsViewController* udVC = (UserDetailsViewController*)segue.destinationViewController;
//        [udVC setUser:_advert.author];
    }
}

#pragma mark - Handle keyboard

- (void)keyboardWillHide:(NSNotification *)n
{
    _scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)keyboardWillShow:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    _scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
    
}

#pragma mark - Helpers
-(void)refreshAdData{
    _titleLabel.text = _advert.name;
    
    _priceTextContainerView.text = [NSString stringWithFormat:@"£%.02f", _advert.guidePrice];
    _minimumOrderTextContainerView.text = _advert.minOrderQuantity > 0 ? [NSString stringWithFormat:@"%i %@", _advert.minOrderQuantity, _advert.packaging ? _advert.packaging.title: @""]  : @"";
    _qtyAvailableTextContainerView.text =  [NSString stringWithFormat:@"%i %@", _advert.count, _advert.packaging ? _advert.packaging.title: @""];
    _locationTextContainerView.text = _advert.location;
    _shippingTextContainerView.text = _advert.shipping.title;
    _expiryTextContainerView.text = _advert.dateExpires ? [NSDate stringFromDate:_advert.dateExpires] : @"N/A";
    
    NSMutableString* certString = _advert.certification != nil ? [[NSMutableString alloc] initWithString:_advert.certification.title] : [[NSMutableString alloc] init];
    if (_advert.certificationOther.length > 0){
        [certString appendFormat:@"%@%@", certString.length > 0 ? @", " : @"", _advert.certificationOther];
    }
    
    _certeficationTextContainerView.text = certString;
    _conditionTextContainerView.text = _advert.condition.title;
        _descriptionTextView.text = _advert.adDescription;
    
    if (_advert.author.photo)
        [_userPicture loadImage:_advert.author.photo];
    else
        [_userPicture setImage:[UIImage imageNamed:@"user_placeholder"]];
    
    _userName.text = _advert.author.userName;
    [_ratingView setRate:_advert.author.rating];
    
    _awardImageView.hidden = _advert.author.isVerified;
    
    _offerViewHeight.constant = 43;
    
    if (_advert.ident <= 0){
        [_makeButton setTitle:@"CREATE ADVERT" forState:UIControlStateNormal];
    }else if (_advert.author.ident == [[UserServiceManager sharedManager] getMe].ident){
        _offerViewHeight.constant = 0;
    }
    
    [self.view setNeedsUpdateConstraints];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

-(void)createOrder{
//    if (_createOrderAction){
//        Offer* offer = [_advert isForStore] ? [Offer storedEntity] : [Offer tempEntity];
//        offer.advert = _advert;
//        User* user = [User getMe];
//        if (user.managedObjectContext != offer.managedObjectContext){
//            user = [offer.managedObjectContext objectWithID:[user objectID]];
//        }
//        offer.user = user;
//        offer.price = [_offerPriceTextField.text floatValue];
//        offer.quantity = [_offerQuantityTextField.text floatValue];
//        offer.status = [OfferStatus getEntityWithId:stPending];
//        
//        [self showLoading];
//        [[ServerConnectionHelper sharedInstance] createOffer:offer compleate:^(NSError *error) {
//            [self hideLoading];
//            NSString* title = @"";
//            NSString* message = @"Offer created";
//            if (error){
//                [offer.managedObjectContext deleteObject:offer];
//                title = @"Error";
//                message = ERROR_MESSAGE(error);
//            }else{
//                [self closeOfferPanel:nil];
//                [_makeButton setBackgroundColor:[UIColor lightGrayColor]];
//                _makeButton.enabled = NO;
//            }
//            [self showOkAlert:title text:message];
//        }];
//        
//    }else{
//        _offerPriceLabel.text = [NSString stringWithFormat:@"£/%@", _advert.packaging.title];
//        _offerQuantityLabel.text = _advert.packaging.title;
//        _offerViewHeight.constant = 186;
//        [_scrollView setContentOffset:CGPointMake(0, _scrollView.contentOffset.y + 143) animated:NO];
//        [self.view setNeedsUpdateConstraints];
//        [self.view setNeedsLayout];
//        [self.view layoutIfNeeded];
//        _createOrderAction = YES;
//    }
}

-(void)createAdvert{
//    [self showLoading];
//    [[ServerConnectionHelper sharedInstance] createAdvert:_advert compleate:^(NSError *error) {
//        [self hideLoading];
//        NSString* title = @"";
//        NSString* message = @"Advert created";
//        if (error){
//            title = @"Error";
//            message = ERROR_MESSAGE(error);
//        }else{
//            [_makeButton setBackgroundColor:[UIColor lightGrayColor]];
//            _makeButton.enabled = NO;
//            _popToRootViewController = YES;
//        }
//        [self showOkAlert:title text:message];
//    }];
    
}

#pragma mark - Outlets
- (IBAction)makeAction:(id)sender {
    if ([self checkUserLogin])
    {
        if (_advert.ident > 0)
            [self createOrder];
        else
            [self createAdvert];
    }
}

- (IBAction)closeOfferPanel:(id)sender {
    _offerViewHeight.constant = 43;
    [_scrollView setContentOffset:CGPointMake(0, _scrollView.contentOffset.y - 143)];
    [self.view setNeedsUpdateConstraints];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    _createOrderAction = NO;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _advert.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCollectionViewCell* cell = (ImageCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageViewCell" forIndexPath:indexPath];
    [(BackgroundImageView*)cell.imageView loadImage:[_advert.photos objectAtIndex:indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width - 40, collectionView.frame.size.height - 40);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:ADVERT_IMAGES_SEGUE sender:indexPath];
}


@end
