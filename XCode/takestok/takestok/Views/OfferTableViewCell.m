//
//  BuyingOfferTableViewCell.m
//  takestok
//
//  Created by Artem on 9/27/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "OfferTableViewCell.h"

@implementation OfferTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)acceptAction:(id)sender {
    [self.delegate acceptOfferAction:self];
}

- (IBAction)counterAction:(id)sender {
    [self.delegate counterOfferAction:self];
}

- (IBAction)rejectAction:(id)sender {
    [self.delegate rejectOfferAction:self];
}

- (IBAction)mainAction:(id)sender {
    [self.delegate mainAction:self];
}

- (IBAction)contactUsAction:(id)sender {
    [self.delegate contactUsAction:self];
}

- (IBAction)contactUserAction:(id)sender {
    [self.delegate contactUserAction:self];
}

- (IBAction)iArrangeTrasportAction:(id)sender {
    [self.delegate sellerArrangedTransport:self];
}

- (IBAction)buyerArrangesTransportAction:(id)sender {
    [self.delegate buyerArrangedTransport:self];
}

- (IBAction)payByCardAction:(id)sender {
    [self.delegate payByCardAction:sender];
}

- (IBAction)payByBacsAction:(id)sender {
    [self.delegate payByBacsAction:sender];
}

@end
