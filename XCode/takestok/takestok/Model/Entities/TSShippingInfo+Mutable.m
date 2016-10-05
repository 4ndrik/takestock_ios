//
//  TSShippingInfo+Mutable.m
//  takestok
//
//  Created by Artem on 10/5/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSShippingInfo+Mutable.h"

@implementation TSShippingInfo (Mutable)

-(void)setOfferId:(NSNumber *)offerId{
    _offerId = offerId;
}

-(void)setHouse:(NSString *)house{
    _house = house;
}

-(void)setCity:(NSString *)city{
    _city = city;
}

-(void)setStreet:(NSString *)street{
    _street = street;
}

-(void)setPostcode:(NSString *)postcode{
    _postcode = postcode;
}

-(void)setPhone:(NSString *)phone{
    _phone = phone;
}

-(void)setArrivalDate:(NSDate *)arrivalDate{
    _arrivalDate = arrivalDate;
}

-(void)setCourierName:(NSString *)courierName{
    _courierName = courierName;
}

-(void)setPickUpDate:(NSDate *)pickUpDate{
    _pickUpDate = pickUpDate;
}

-(void)setIsInTransit:(BOOL)isInTransit{
    _isInTransit = isInTransit;
}

-(void)setTrackingNumber:(NSString *)trackingNumber{
    _trackingNumber = trackingNumber;
}

@end
