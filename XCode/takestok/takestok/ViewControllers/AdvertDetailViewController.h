//
//  ProductDetailViewController.h
//  takestok
//
//  Created by Artem on 4/13/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BaseViewController.h"
@class TitleTextContainerView;
@class Advert;
@class TopBottomStripesLabel;
@class RatingView;
@class BackgroundImageView;
@class PaddingTextField;
@class Offer;

@interface AdvertDetailViewController : BaseViewController<UICollectionViewDelegate, UICollectionViewDataSource>{
    Advert* _advert;
    Offer* _offer;
    
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
    
    __weak IBOutlet NSLayoutConstraint *_minimumOrderHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *_qtyAvailableHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *_locationHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *_shippingHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *_expiryHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *_certificationHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *_conditionHeightConstraint;
    
    __weak IBOutlet NSLayoutConstraint *_offerViewHeight;
    __weak IBOutlet PaddingTextField *_offerQuantityTextField;
    __weak IBOutlet UILabel *_offerQuantityLabel;
    __weak IBOutlet PaddingTextField *_offerPriceTextField;
    __weak IBOutlet UILabel *_offerPriceLabel;
    __weak IBOutlet UIButton *_makeButton;
    
    
    __weak IBOutlet UIButton *_questionButton;
    
    __weak IBOutlet BackgroundImageView *_userPicture;
    __weak IBOutlet UILabel *_userName;
    __weak IBOutlet RatingView *_ratingView;
    
    __weak IBOutlet UIImageView *_awardImageView;
}

-(void)setAdvert:(Advert*)advert;
- (IBAction)makeAction:(id)sender;
- (IBAction)closeOfferPanel:(id)sender;

@end
