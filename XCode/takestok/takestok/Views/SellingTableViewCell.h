//
//  SellingTableViewCell.h
//  takestok
//
//  Created by Artem on 4/20/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BackgroundImageView;

@interface SellingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet BackgroundImageView *adImageView;
@property (weak, nonatomic) IBOutlet UIView *stripeTopView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *stripeBottomView;
@property (weak, nonatomic) IBOutlet UILabel *createdLabel;
@property (weak, nonatomic) IBOutlet UILabel *offersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *expiresDayCountLabel;

@end
