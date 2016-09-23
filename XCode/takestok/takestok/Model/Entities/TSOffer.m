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
#define OFFER_COMMENT_PARAM             @"comment"

@implementation TSOffer

@synthesize advertId = _advertId;
@synthesize price = _price;
@synthesize quantity = _quantity;
@synthesize user = _user;
@synthesize parentOfferId = _parentOfferId;
@synthesize childOffers = _childOffers;
@synthesize status = _status;
@synthesize comment = _comment;

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
    
    if ([dict objectForKeyNotNull:OFFER_COMMENT_PARAM])
        _comment = [dict objectForKeyNotNull:OFFER_COMMENT_PARAM];
    //OFFER
    //CHILD
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
