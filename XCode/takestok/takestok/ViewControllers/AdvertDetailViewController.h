//
//  ProductDetailViewController.h
//  takestok
//
//  Created by Artem on 4/13/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BaseViewController.h"
@class TitleTextContainerView;
@class TSAdvert;
@class TopBottomStripesLabel;
@class RatingView;
@class BackgroundImageView;
@class PaddingTextField;
@class Offer;

@interface AdvertDetailViewController : BaseViewController<UICollectionViewDelegate, UICollectionViewDataSource>{
    TSAdvert* _advert;
    
    BOOL _popToRootViewController;
    
    BOOL _createOrderAction;
    
    __weak IBOutlet UIScrollView *_scrollView;
    
    __weak IBOutlet TopBottomStripesLabel *_titleLabel;
    __weak IBOutlet TitleTextContainerView *_priceTextContainerView;
    __weak IBOutlet TitleTextContainerView *_minimumOrderTextContainerView;
    __weak IBOutlet TitleTextContainerView *_qtyAvailableTextContainerView;
    __weak IBOutlet UILabel *_descriptionTextView;
    __weak IBOutlet TitleTextContainerView *_locationTextContainerView;
    __weak IBOutlet TitleTextContainerView *_shippingTextContainerView;
    __weak IBOutlet TitleTextContainerView *_expiryTextContainerView;
    __weak IBOutlet TitleTextContainerView *_certeficationTextContainerView;
    __weak IBOutlet TitleTextContainerView *_conditionTextContainerView;
    
    __weak IBOutlet NSLayoutConstraint *_offerViewHeight;
    __weak IBOutlet PaddingTextField *_offerQuantityTextField;
    __weak IBOutlet UILabel *_offerQuantityLabel;
    __weak IBOutlet PaddingTextField *_offerPriceTextField;
    __weak IBOutlet UILabel *_offerPriceLabel;
    
    __weak IBOutlet NSLayoutConstraint *_createAdvertViewHeight;
    
    __weak IBOutlet UIButton *_questionButton;
    
    __weak IBOutlet BackgroundImageView *_userPicture;
    __weak IBOutlet UILabel *_userName;
    __weak IBOutlet RatingView *_ratingView;
    
    __weak IBOutlet UIImageView *_awardImageView;
}

- (void)setAdvert:(TSAdvert*)advert;
- (IBAction)createOrderAction:(id)sender;
- (IBAction)closeOfferPanel:(id)sender;
- (IBAction)advertPutOnHold:(id)sender;
- (IBAction)advertCreate:(id)sender;

@end
