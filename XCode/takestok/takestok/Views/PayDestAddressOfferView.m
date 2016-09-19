//
//  SetCardInfoView.m
//  takestok
//
//  Created by Artem on 7/4/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "PayDestAddressOfferView.h"

@implementation PayDestAddressOfferView

-(void)awakeFromNib{
    [super awakeFromNib];
    _cardControl.cornerRadius = 3.;
    _cardControl.borderColor = [UIColor colorWithRed:235./255. green:235./255. blue:235./255. alpha:1.];
    _cardControl.font = HelveticaLight18;
}

@end
