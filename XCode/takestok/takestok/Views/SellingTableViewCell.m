//
//  SellingTableViewCell.m
//  takestok
//
//  Created by Artem on 4/20/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "SellingTableViewCell.h"
#import "RKNotificationHub.h"

@implementation SellingTableViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
    _offersBadge = [[RKNotificationHub alloc]initWithView:_offersLabel];
    _messageBadge = [[RKNotificationHub alloc]initWithView:_questionsLabel];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [_offersBadge setView:_offersLabel andCount:_offersBadge.count];
    [_offersBadge scaleCircleSizeBy:0.6];
    [_messageBadge setView:_questionsLabel andCount:_messageBadge.count];
    [_messageBadge scaleCircleSizeBy:0.6];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _selectedView.backgroundColor = selected ? [UIColor colorWithRed:237./255. green:236./255. blue:236./255. alpha:1.] : [UIColor whiteColor];
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    _selectedView.backgroundColor = highlighted ? [UIColor colorWithRed:237./255. green:236./255. blue:236./255. alpha:1.] : [UIColor whiteColor];
}

-(void)setCountNewOffers:(int)offerCount andNotCount:(int)notificationCount{
    [_offersBadge setCount:offerCount];
    [_messageBadge setCount:notificationCount];
}

@end
