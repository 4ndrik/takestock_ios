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
@class TSShippingInfo;

@interface TSOffer : TSBaseEntity

@property (readonly, nonatomic, retain) NSNumber *advertId;
@property (readonly, nonatomic, assign) float price;
@property (readonly, nonatomic, assign) int quantity;
@property (readonly, nonatomic, retain) TSUserEntity* user;
@property (readonly, nonatomic, retain) TSOfferStatus* status;
@property (readonly, nonatomic, retain) TSOfferStatus* statusForBuyer;
@property (readonly, nonatomic, retain) NSString *comment;
@property (readonly, nonatomic, retain) NSDate* dateCreated;
@property (readonly, nonatomic, retain) NSDate* dateUpdated;

@property (readonly, nonatomic, retain) NSNumber *parentOfferId;
@property (readonly, nonatomic, retain) NSArray *childOffers;

@property (readonly, nonatomic, assign) BOOL isFromSeller;

@property (readonly, nonatomic, retain) NSString* street;
@property (readonly, nonatomic, retain) NSString* house;
@property (readonly, nonatomic, retain) NSString* city;
@property (readonly, nonatomic, retain) NSString* postcode;
@property (readonly, nonatomic, retain) NSString* phone;

@property (readonly, nonatomic, retain)TSShippingInfo* shippingInfo;

-(id)initWithPrice:(float)price quantity:(int)quantity user:(TSUserEntity*)user advertId:(NSNumber*)advertId;

@end
