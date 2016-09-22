//
//  TSOffer.m
//  takestok
//
//  Created by Artem on 9/21/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSOffer.h"
#import "UserServiceManager.h"

#define OFFER_ID_PARAM                  @"id"
#define OFFER_ADVERT_PARAM              @"advert"

#define OFFER_PARENT_OFFER_PARAM        @"offer"
#define OFFER_CHILD_OFFERS_PARAM        @"child_offers"

#define OFFER_PRICE_PARAM               @"price"
#define OFFER_QUANTITY_PARAM            @"quantity"
#define OFFER_USER_PARAM                @"user_detailed"

@implementation TSOffer

@synthesize advertId = _advertId;
@synthesize price = _price;
@synthesize quantity = _quantity;
@synthesize user = _user;
@synthesize parentOfferId = _parentOfferId;
@synthesize childOffers = _childOffers;

-(void)updateWithDic:(NSDictionary*)dict{
    _ident = [TSOffer identFromDic:dict];
    _advertId = [dict objectForKeyNotNull:OFFER_ADVERT_PARAM];
    _price = [[dict objectForKeyNotNull:OFFER_PRICE_PARAM] floatValue];
    _quantity = [[dict objectForKeyNotNull:OFFER_QUANTITY_PARAM] intValue];
    
    NSDictionary* authorDic = [dict objectForKeyNotNull:OFFER_USER_PARAM];
    _user = [[UserServiceManager sharedManager] getOrCreateAuthor:authorDic];
    
    //OFFER
    //CHILD
    
}

+(NSNumber*)identFromDic:(NSDictionary*)dict{
    return [dict objectForKeyNotNull:OFFER_ID_PARAM];
}

@end
