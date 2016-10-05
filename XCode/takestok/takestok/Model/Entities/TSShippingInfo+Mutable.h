//
//  TSShippingInfo+Mutable.h
//  takestok
//
//  Created by Artem on 10/5/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSShippingInfo.h"

@interface TSShippingInfo (Mutable)

@property (readwrite, nonatomic, retain) NSNumber *offerId;
@property (readwrite, nonatomic, retain) NSString *house;
@property (readwrite, nonatomic, retain) NSString *city;
@property (readwrite, nonatomic, retain) NSString *street;
@property (readwrite, nonatomic, retain) NSString *postcode;
@property (readwrite, nonatomic, retain) NSString *phone;

@property (readwrite, nonatomic, retain) NSDate *arrivalDate;
@property (readwrite, nonatomic, retain) NSString *courierName;
@property (readwrite, nonatomic, retain) NSDate *pickUpDate;
@property (readwrite, nonatomic, assign) BOOL isInTransit;
@property (readwrite, nonatomic, retain) NSString *trackingNumber;

@end
