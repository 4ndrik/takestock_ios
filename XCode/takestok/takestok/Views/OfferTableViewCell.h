//
//  BuyingOfferTableViewCell.h
//  takestok
//
//  Created by Artem on 9/27/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfferActionDelegate.h"

@class PaddingLabel;

@interface OfferTableViewCell : UITableViewCell

@property (weak)id<OfferActionDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *dateCreatedLabel;
@property (weak, nonatomic) IBOutlet PaddingLabel *offerTitleLabel;
@property (weak, nonatomic) IBOutlet PaddingLabel *offerCountLabel;
@property (weak, nonatomic) IBOutlet PaddingLabel *offerPriceLabel;
@property (weak, nonatomic) IBOutlet PaddingLabel *statusLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainActionHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *offerActionHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *transportActionHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contactUserActionHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contactUsActionHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payActionHeight;

@property (weak, nonatomic) IBOutlet UIButton *mainActionButton;
@property (weak, nonatomic) IBOutlet UIButton *contactUserButton;

- (IBAction)acceptAction:(id)sender;
- (IBAction)counterAction:(id)sender;
- (IBAction)rejectAction:(id)sender;
- (IBAction)mainAction:(id)sender;
- (IBAction)contactUsAction:(id)sender;
- (IBAction)contactUserAction:(id)sender;
- (IBAction)iArrangeTrasportAction:(id)sender;
- (IBAction)buyerArrangesTransportAction:(id)sender;
- (IBAction)payByCardAction:(id)sender;
- (IBAction)payByBacsAction:(id)sender;

@end
