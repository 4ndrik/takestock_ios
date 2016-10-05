//
//  TSShippingInfo.h
//  takestok
//
//  Created by Artem on 10/4/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSBaseEntity.h"

@interface TSShippingInfo : TSBaseEntity{
    NSNumber *_offerId;
    NSString *_house;
    NSString *_city;
    NSString *_street;
    NSString *_postcode;
    NSString *_phone;
    
    NSDate *_arrivalDate;
    NSString *_courierName;
    NSDate *_pickUpDate;
    BOOL _isInTransit;
    NSString *_trackingNumber;
}

@property (readonly, nonatomic, retain) NSNumber *offerId;
@property (readonly, nonatomic, retain) NSString *house;
@property (readonly, nonatomic, retain) NSString *city;
@property (readonly, nonatomic, retain) NSString *street;
@property (readonly, nonatomic, retain) NSString *postcode;
@property (readonly, nonatomic, retain) NSString *phone;

@property (readonly, nonatomic, retain) NSDate *arrivalDate;
@property (readonly, nonatomic, retain) NSString *courierName;
@property (readonly, nonatomic, retain) NSDate *pickUpDate;
@property (readonly, nonatomic, assign) BOOL isInTransit;
@property (readonly, nonatomic, retain) NSString *trackingNumber;

-(NSDictionary*)dictionaryForShipping;
-(NSDictionary*)dictionaryForDispatch;

@end
