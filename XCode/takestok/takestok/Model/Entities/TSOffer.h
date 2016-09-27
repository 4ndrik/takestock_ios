//
//  TSOffer.h
//  takestok
//
//  Created by Artem on 9/21/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSBaseEntity.h"

@class TSUserEntity;
@class TSOfferStatus;

@interface TSOffer : TSBaseEntity{
    NSNumber* _advertId;
    float _price;
    int _quantity;
    TSUserEntity* _user;
    TSOfferStatus* _status;
    NSString* _comment;
    NSDate* _dateCreated;
    NSDate* _dateUpdated;
    
    NSNumber* _parentOfferId;
    NSArray* _childOffers;
}

@property (readonly, nonatomic, retain) NSNumber *advertId;
@property (readonly, nonatomic, assign) float price;
@property (readonly, nonatomic, assign) int quantity;
@property (readonly, nonatomic, retain) TSUserEntity* user;
@property (readonly, nonatomic, retain) TSOfferStatus* status;
@property (readonly, nonatomic, retain) NSString *comment;
@property (readonly, nonatomic, retain) NSDate* dateCreated;
@property (readonly, nonatomic, retain) NSDate* dateUpdated;

@property (readonly, nonatomic, retain) NSNumber *parentOfferId;
@property (readonly, nonatomic, retain) NSArray *childOffers;

@end
