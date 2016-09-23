//
//  TSOffer+Mutable.m
//  takestok
//
//  Created by Artem on 9/23/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSOffer+Mutable.h"

@implementation TSOffer (Mutable)

-(void)setAdvertId:(NSNumber *)advertId{
    _advertId = advertId;
}

-(void)setUser:(TSUserEntity *)user{
    _user = user;
}

-(void)setQuantity:(int)quantity{
    _quantity = quantity;
}

-(void)setPrice:(float)price{
    _price = price;
}

@end
