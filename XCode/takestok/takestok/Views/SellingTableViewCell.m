//
//  SellingTableViewCell.m
//  takestok
//
//  Created by Artem on 4/20/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "SellingTableViewCell.h"

@implementation SellingTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    UIColor *topColor = self.stripeTopView.backgroundColor;
    UIColor *bottomColor = self.stripeBottomView.backgroundColor;
    [super setSelected:selected animated:animated];
    
    if (selected){
        self.stripeTopView.backgroundColor = topColor;
        self.stripeBottomView.backgroundColor = bottomColor;
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    UIColor *topColor = self.stripeTopView.backgroundColor;
    UIColor *bottomColor = self.stripeBottomView.backgroundColor;
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted){
        self.stripeTopView.backgroundColor = topColor;
        self.stripeBottomView.backgroundColor = bottomColor;
    }
}

@end
