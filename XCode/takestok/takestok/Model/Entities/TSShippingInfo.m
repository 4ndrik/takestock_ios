//
//  TSShippingInfo.m
//  takestok
//
//  Created by Artem on 10/4/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSShippingInfo.h"

#define SHIPPING_ID_PARAM                   @"id"
#define SHIPPING_OFFER_ID_PARAM             @"offer"
#define SHIPPING_ARRIVAL_DATE_PARAM         @"arrival_date"

#define SHIPPING_HOUSE_PARAM                @"house"
#define SHIPPING_STREET_PARAM               @"street"
#define SHIPPING_CITY_PARAM                 @"city"
#define SHIPPING_POST_CODE_PARAM            @"postcode"
#define SHIPPING_PHONE_PARAM                @"phone"
#define SHIPPING_COURIER_NAME_PARAM         @"courier_name"

#define SHIPPING_TRACKING_PARAM             @"tracking"
#define SHIPPING_STOCK_IN_TRANSIT_PARAM     @"stock_in_transit"
#define SHIPPING_PICK_UP_DATE_PARAM         @"pick_up_date"

@implementation TSShippingInfo

@synthesize offerId = _offerId;
@synthesize house = _house;
@synthesize city = _city;
@synthesize street = _street;
@synthesize postcode = _postcode;
@synthesize phone = _phone;
@synthesize arrivalDate = _arrivalDate;
@synthesize courierName = _courierName;
@synthesize pickUpDate = _pickUpDate;
@synthesize isInTransit = _isInTransit;
@synthesize trackingNumber = _trackingNumber;

-(void)updateWithDic:(NSDictionary*)dict{
    NSTimeZone* timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    _ident = [TSShippingInfo identFromDic:dict];
    _offerId = [dict objectForKeyNotNull:SHIPPING_OFFER_ID_PARAM];
    
    _arrivalDate = [NSDate dateFromString:[dict objectForKeyNotNull:SHIPPING_ARRIVAL_DATE_PARAM] format:DEFAULT_DATE_FORMAT timeZone:timeZone];
    _house = [dict objectForKeyNotNull:SHIPPING_HOUSE_PARAM];
    _street = [dict objectForKeyNotNull:SHIPPING_STREET_PARAM];
    _city = [dict objectForKeyNotNull:SHIPPING_CITY_PARAM];
    _postcode = [dict objectForKeyNotNull:SHIPPING_POST_CODE_PARAM];
    _phone = [dict objectForKeyNotNull:SHIPPING_PHONE_PARAM];
    _courierName = [dict objectForKeyNotNull:SHIPPING_COURIER_NAME_PARAM];
    _trackingNumber = [dict objectForKeyNotNull:SHIPPING_TRACKING_PARAM];
    _isInTransit = [[dict objectForKeyNotNull:SHIPPING_STOCK_IN_TRANSIT_PARAM] boolValue];
    _pickUpDate = [NSDate dateFromString:[dict objectForKeyNotNull:SHIPPING_PICK_UP_DATE_PARAM] format:DEFAULT_DATE_FORMAT timeZone:timeZone];
}

+(NSNumber*)identFromDic:(NSDictionary*)dict{
    return [dict objectForKeyNotNull:SHIPPING_ID_PARAM];
}

-(NSDictionary*)dictionaryForShipping{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setValue:_offerId forKey:SHIPPING_OFFER_ID_PARAM];
    [dic setValue:_street forKey:SHIPPING_STREET_PARAM];
    [dic setValue:_house forKey:SHIPPING_HOUSE_PARAM];
    [dic setValue:_city forKey:SHIPPING_CITY_PARAM];
    [dic setValue:_postcode forKey:SHIPPING_POST_CODE_PARAM];
    [dic setValue:_phone forKey:SHIPPING_PHONE_PARAM];
    return dic;
}

-(NSDictionary*)dictionaryForDispatch{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    NSString* arrivalDate = [NSDate stringFromDate:_arrivalDate format:DEFAULT_DATE_FORMAT timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSString* pickUpDate = [NSDate stringFromDate:_arrivalDate format:DEFAULT_DATE_FORMAT timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    [dic setValue:[NSNumber numberWithBool:_isInTransit] forKey:SHIPPING_STOCK_IN_TRANSIT_PARAM];
    [dic setValue:_offerId forKey:SHIPPING_OFFER_ID_PARAM];
    [dic setValue:arrivalDate forKey:SHIPPING_ARRIVAL_DATE_PARAM];
    [dic setValue:pickUpDate forKey:SHIPPING_PICK_UP_DATE_PARAM];
    [dic setValue:_trackingNumber forKey:SHIPPING_TRACKING_PARAM];
    [dic setValue:_courierName forKey:SHIPPING_COURIER_NAME_PARAM];
    
    return dic;
}

@end
