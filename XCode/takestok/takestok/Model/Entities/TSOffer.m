//
//  TSOffer.m
//  takestok
//
//  Created by Artem on 9/21/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSOffer.h"
#import "UserServiceManager.h"
#import "OfferServiceManager.h"
#import "TSUserEntity.h"

#define OFFER_ID_PARAM                  @"id"
#define OFFER_ADVERT_PARAM              @"advert"

#define OFFER_PARENT_OFFER_PARAM        @"offer"
#define OFFER_CHILD_OFFERS_PARAM        @"child_offers"

#define OFFER_PRICE_PARAM               @"price"
#define OFFER_QUANTITY_PARAM            @"quantity"
#define OFFER_USER_DETAILED_PARAM       @"user_detailed"
#define OFFER_USER_PARAM                @"user"
#define OFFER_STATUS_PARAM              @"status"
#define OFFER_BUYER_STATUS_PARAM        @"status_for_buyer"
#define OFFER_COMMENT_PARAM             @"comment"

#define OFFER_DATE_CREATED_PARAM        @"created_at"
#define OFFER_DATE_UPDATED_PARAM        @"updated_at"

#define OFFER_FROM_SELLER_PARAM         @"from_seller"

@implementation TSOffer

@synthesize advertId = _advertId;
@synthesize price = _price;
@synthesize quantity = _quantity;
@synthesize user = _user;
@synthesize parentOfferId = _parentOfferId;
@synthesize childOffers = _childOffers;
@synthesize dateCreated = _dateCreated;
@synthesize dateUpdated = _dateUpdated;
@synthesize status = _status;
@synthesize comment = _comment;
@synthesize statusForBuyer = _statusForBuyer;
@synthesize isFromSeller = _isFromSeller;

-(void)updateWithDic:(NSDictionary*)dict{
    _ident = [TSOffer identFromDic:dict];
    if ([dict objectForKeyNotNull:OFFER_ADVERT_PARAM])
        _advertId = [dict objectForKeyNotNull:OFFER_ADVERT_PARAM];
    if ([dict objectForKeyNotNull:OFFER_PRICE_PARAM])
        _price = [[dict objectForKeyNotNull:OFFER_PRICE_PARAM] floatValue];
    if ([dict objectForKeyNotNull:OFFER_QUANTITY_PARAM])
        _quantity = [[dict objectForKeyNotNull:OFFER_QUANTITY_PARAM] intValue];
    
    NSDictionary* authorDic = [dict objectForKeyNotNull:OFFER_USER_DETAILED_PARAM];
    if (authorDic)
        _user = [[UserServiceManager sharedManager] getOrCreateAuthor:authorDic];
    else if ([dict objectForKeyNotNull:OFFER_USER_PARAM]){
        _user = [[UserServiceManager sharedManager] getAuthorWithId:[dict objectForKeyNotNull:OFFER_USER_PARAM]];
    }
    
    NSNumber* offerStatusId = [dict objectForKeyNotNull:OFFER_STATUS_PARAM];
    if (offerStatusId)
        _status = [[OfferServiceManager sharedManager] getOfferStatus:offerStatusId];
    
    NSNumber* buyerStatusId = [dict objectForKeyNotNull:OFFER_BUYER_STATUS_PARAM];
    if (buyerStatusId)
        _statusForBuyer = [[OfferServiceManager sharedManager] getOfferStatus:buyerStatusId];
    
    
    if ([dict objectForKeyNotNull:OFFER_COMMENT_PARAM])
        _comment = [dict objectForKeyNotNull:OFFER_COMMENT_PARAM];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    _dateCreated = [NSDate dateFromString:[dict objectForKeyNotNull:OFFER_DATE_CREATED_PARAM] format:DEFAULT_DATE_FORMAT timeZone:timeZone];
    _dateUpdated = [NSDate dateFromString:[dict objectForKeyNotNull:OFFER_DATE_UPDATED_PARAM] format:DEFAULT_DATE_FORMAT timeZone:timeZone];
    //OFFER
    //CHILD
    
    NSMutableArray* childOffers = [NSMutableArray array];
    for (id chdic in [dict objectForKeyNotNull:OFFER_CHILD_OFFERS_PARAM]){
        if ([chdic isKindOfClass:[NSDictionary class]]){
            TSOffer* offer = [TSOffer objectWithDictionary:chdic];
            [childOffers addObject:offer];
        }
    }
    _childOffers = childOffers;
    
    _isFromSeller = [[dict objectForKeyNotNull:OFFER_FROM_SELLER_PARAM] boolValue];
}

+(NSNumber*)identFromDic:(NSDictionary*)dict{
    return [dict objectForKeyNotNull:OFFER_ID_PARAM];
}

-(NSDictionary*)dictionaryRepresentation{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObjectNotNull:_ident forKey:OFFER_ID_PARAM];
    [dic setObjectNotNull:_advertId forKey:OFFER_ADVERT_PARAM];
    [dic setObjectNotNull:[NSNumber numberWithFloat:_price] forKey:OFFER_PRICE_PARAM];
    [dic setObjectNotNull:[NSNumber numberWithInteger:_quantity] forKey:OFFER_QUANTITY_PARAM];
    [dic setObjectNotNull:_user.ident forKey:@"user"];
    return dic;
}


@end
