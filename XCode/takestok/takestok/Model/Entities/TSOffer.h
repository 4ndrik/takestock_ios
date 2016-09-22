//
//  TSOffer.h
//  takestok
//
//  Created by Artem on 9/21/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSBaseEntity.h"

@class TSUserEntity;

@interface TSOffer : TSBaseEntity{
    NSNumber* _advertId;
    float _price;
    int _quantity;
    TSUserEntity* _user;
    
    NSNumber* _parentOfferId;
    NSArray* _childOffers;
}

@property (readonly, nonatomic, retain) NSNumber *advertId;
@property (readonly, nonatomic, assign) float price;
@property (readonly, nonatomic, assign) int quantity;
@property (readonly, nonatomic, retain) TSUserEntity* user;

@property (readonly, nonatomic, retain) NSNumber *parentOfferId;
@property (readonly, nonatomic, retain) NSArray *childOffers;


@end
