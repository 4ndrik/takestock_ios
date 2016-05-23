//
//  BuyingTableViewCell.m
//  takestok
//
//  Created by Artem on 4/20/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BuyingTableViewCell.h"

@implementation BuyingTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _selectedView.backgroundColor = selected ? [UIColor colorWithRed:237./255. green:236./255. blue:236./255. alpha:1.] : [UIColor whiteColor];
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    _selectedView.backgroundColor = highlighted ? [UIColor colorWithRed:237./255. green:236./255. blue:236./255. alpha:1.] : [UIColor whiteColor];
}

- (IBAction)acceptAction:(id)sender{
    [self.delegate acceptOfferAction:self];
}

- (IBAction)rejectAction:(id)sender{
    [self.delegate rejectOfferAction:self];
}

- (IBAction)mainAction:(id)sender{
    [self.delegate mainAction:self];
}

@end
