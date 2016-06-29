//
//  BuyingTableViewCell.h
//  takestok
//
//  Created by Artem on 4/20/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfferActionDelegate.h"

@class BackgroundImageView;

@interface BuyingTableViewCell : UITableViewCell{
    
    __weak IBOutlet UIView *_selectedView;
}

@property (weak)id<OfferActionDelegate>delegate;

@property (weak, nonatomic) IBOutlet BackgroundImageView *adImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdLabel;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *offerPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *counterTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *counterCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *counterPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *offerTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *acceptHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *additionalActionHeight;

- (IBAction)acceptAction:(id)sender;
- (IBAction)rejectAction:(id)sender;
- (IBAction)mainAction:(id)sender;

@end
