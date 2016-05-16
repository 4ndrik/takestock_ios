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
    self.advert = [Advert getEntityWithId:[[jsonDic objectForKeyNotNull:OFFER_ADVERT_PARAM] intValue]];
    if (self.ident == 0 || !self.user || !self.advert){
        [self.managedObjectContext deleteObject:self];
        NSLog(@"Offer %i hasn't required data", self.ident);
        return;
    }
    self.price = [[jsonDic objectForKeyNotNull:OFFER_PRICE_PARAM] doubleValue];
    self.quantity = [[jsonDic objectForKeyNotNull:OFFER_QUANTITY_PARAM] intValue];
    self.status = [OfferStatus getEntityWithId:[[jsonDic objectForKeyNotNull:OFFER_STATUS_PARAM]intValue]];
    self.comment = [jsonDic objectForKeyNotNull:OFFER_COMMENT_PARAM];
    self.created = [[dateFormatter dateFromString:[jsonDic objectForKeyNotNull:OFFER_CREATE_PARAM]] timeIntervalSinceReferenceDate];
    self.updated = [[dateFormatter dateFromString:[jsonDic objectForKeyNotNull:OFFER_UPDATE_PARAM]] timeIntervalSinceReferenceDate];
}

-(NSDictionary*)getDictionary{
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    if (self.ident > 0){
        [result setValue:[NSNumber numberWithInt:self.ident] forKey:OFFER_ID_PARAM];
    }
    [result setValue:[NSNumber numberWithFloat:self.price] forKey:OFFER_PRICE_PARAM];
    [result setValue:[NSNumber numberWithFloat:self.quantity] forKey:OFFER_QUANTITY_PARAM];
    [result setValue:self.comment forKey:OFFER_COMMENT_PARAM];
    [result setValue:[NSNumber numberWithInt:self.user.ident] forKey:OFFER_USER_PARAM];
    [result setValue:[NSNumber numberWithInt:self.advert.ident] forKey:OFFER_ADVERT_PARAM];
    return result;
}


@end
