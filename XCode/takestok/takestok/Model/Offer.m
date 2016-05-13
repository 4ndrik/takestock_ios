//
//  Offer.m
//  takestok
//
//  Created by Artem on 5/13/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "Offer.h"
#import "Advert.h"
#import "User.h"
#import "NSDictionary+HandleNil.h"
#import "OfferStatus.h"

@implementation Offer

+ (NSString *)entityName {
    return @"Offer";
}

-(void)updateWithDic:(NSDictionary*)jsonDic{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = DEFAULT_DATE_FORMAT;
    
    self.ident = [[jsonDic objectForKeyNotNull:OFFER_ID_PARAM] intValue];
    self.user = [User getEntityWithId:[[jsonDic objectForKeyNotNull:OFFER_USER_PARAM] intValue]];
    self.advert = [Advert getEntityWithId:[[jsonDic objectForKey:OFFER_ADVERT_PARAM] intValue]];
    self.price = [[jsonDic objectForKey:OFFER_PRICE_PARAM] doubleValue];
    self.quantity = [[jsonDic objectForKey:OFFER_QUANTITY_PARAM] intValue];
    self.status = [OfferStatus getEntityWithId:[[jsonDic objectForKey:OFFER_STATUS_PARAM]intValue]];
    self.comment = [jsonDic objectForKey:OFFER_COMMENT_PARAM];
    self.created = [[dateFormatter dateFromString:[jsonDic objectForKeyNotNull:OFFER_CREATE_PARAM]] timeIntervalSinceReferenceDate];
    self.updated = [[dateFormatter dateFromString:[jsonDic objectForKeyNotNull:OFFER_UPDATE_PARAM]] timeIntervalSinceReferenceDate];
}

@end
