//
//  SellingTableViewCell.h
//  takestok
//
//  Created by Artem on 4/20/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BackgroundImageView;
@class PaddingLabel;
@class RKNotificationHub;

@interface SellingTableViewCell : UITableViewCell{
    __weak IBOutlet UIView *_selectedView;
    RKNotificationHub* _offersBadge;
    RKNotificationHub* _messageBadge;
    __weak IBOutlet UILabel *_offersLabel;
    __weak IBOutlet UILabel *_questionsLabel;
}

@property (weak, nonatomic) IBOutlet BackgroundImageView *adImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdLabel;
@property (weak, nonatomic) IBOutlet UILabel *offersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *expiresDayCountLabel;
@property (weak, nonatomic) IBOutlet PaddingLabel *priceLabel;
@property (weak, nonatomic) IBOutlet PaddingLabel *countLabel;

-(void)setCountNewOffers:(int)offerCount andNotCount:(int)notificationCount;

@end
