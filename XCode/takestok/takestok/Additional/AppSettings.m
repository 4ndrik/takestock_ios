//
//  Settings.m
//  takestok
//
//  Created by Artem on 5/4/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "AppSettings.h"

#define USER_ID                     @"UserIdKey"
#define USER_TOKEN                  @"UserTokenKey"
#define SEARCH_SORT                 @"SearchSortKey"

#define ADVERT_REVISION             @"AdvertRevisionKey"
#define BUYER_OFFER_REVISION        @"BuyerOfferRevisiontKey"
#define SELLER_OFFER_REVISION       @"BuyerOfferRevisiontKey"

@implementation AppSettings

+(int)getUserId{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:USER_ID] intValue];
}

+(void)setUserId:(int)ident{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:ident] forKey:USER_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)getToken{
    return [[NSUserDefaults standardUserDefaults] valueForKey:USER_TOKEN];
}

+(void)setToken:(NSString*)token{
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:USER_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(int)getSearchSort{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:SEARCH_SORT] intValue];
}

+(void)setSearchSort:(int)ident{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:ident] forKey:SEARCH_SORT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)updateAdvertRevision{
    [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:ADVERT_REVISION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSDate*)getAdvertRevision{
    return [[NSUserDefaults standardUserDefaults] valueForKey:ADVERT_REVISION];
}

+(void)updateBuyerOfferRevision{
    [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:BUYER_OFFER_REVISION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSDate*)getBuyerOfferRevision{
    return [[NSUserDefaults standardUserDefaults] valueForKey:BUYER_OFFER_REVISION];
}

+(void)updateSellerOfferRevision{
    [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:SELLER_OFFER_REVISION];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

+(NSDate*)getSellerOfferRevision{
    return [[NSUserDefaults standardUserDefaults] valueForKey:SELLER_OFFER_REVISION];
}

@end
