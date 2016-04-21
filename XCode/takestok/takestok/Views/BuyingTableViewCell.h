//
//  BuyingTableViewCell.h
//  takestok
//
//  Created by Artem on 4/20/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BackgroundImageView;

@interface BuyingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet BackgroundImageView *adImageView;
@property (weak, nonatomic) IBOutlet UIView *stripeTopView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *stripeBottomView;
@property (weak, nonatomic) IBOutlet UILabel *createdLabel;

@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
