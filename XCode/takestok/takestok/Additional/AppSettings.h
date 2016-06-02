//
//  Settings.h
//  takestok
//
//  Created by Artem on 5/4/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSettings : NSObject

+(int)getUserId;
+(void)setUserId:(int)ident;

+(NSString*)getToken;
+(void)setToken:(NSString*)token;

+(int)getSearchSort;
+(void)setSearchSort:(int)ident;

+(void)updateAdvertRevision;
+(NSDate*)getAdvertRevision;

+(void)updateBuyerOfferRevision;
+(NSDate*)getBuyerOfferRevision;

+(void)updateSellerOfferRevision;
+(NSDate*)getSellerOfferRevision;

@end
