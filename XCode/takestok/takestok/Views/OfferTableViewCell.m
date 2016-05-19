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
    [self.delegate acceptOfferAction:self];
}

- (IBAction)rejectAction:(id)sender {
    [self.delegate rejectOfferAction:self];
}

- (IBAction)counterAction:(id)sender {
    [self.delegate counterOfferAction:self];
}

@end
