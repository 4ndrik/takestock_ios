//
//  Offer.h
//  takestok
//
//  Created by Artem on 5/13/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEntity.h"

#define OFFER_ID_PARAM              @"id"
#define OFFER_USER_PARAM            @"user"
#define OFFER_ADVERT_PARAM          @"advert"
//#define OFFER_COUNTEROFFER_PARAM    @"offer"
#define OFFER_PRICE_PARAM           @"price"
#define OFFER_QUANTITY_PARAM        @"quantity"
#define OFFER_STATUS_PARAM          @"status"
#define OFFER_COMMENT_PARAM         @"comment"
#define OFFER_CREATE_PARAM          @"created_at"
#define OFFER_UPDATE_PARAM          @"updated_at"
//#define OFFER_ACCEPT_COMMENT_PARAM  @"accept_comment"

@class Advert, User, OfferStatus;

NS_ASSUME_NONNULL_BEGIN

@interface Offer : BaseEntity

+(NSArray*)getMyOffers;

@end

NS_ASSUME_NONNULL_END

#import "Offer+CoreDataProperties.h"
