//
//  OfferTableViewCell.m
//  takestok
//
//  Created by Artem on 4/25/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "OfferTableViewCell.h"

@implementation OfferTableViewCell

- (IBAction)acceptAction:(id)sender {
    [self.delegate acceptOffer:self];
}

- (IBAction)rejectAction:(id)sender {
    [self.delegate rejectOffer:self];
}

- (IBAction)counterAction:(id)sender {
    [self.delegate counterOffer:self];
}

@end
