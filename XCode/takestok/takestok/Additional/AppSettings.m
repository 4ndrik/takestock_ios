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

#define MY_ADVERT_REVISION          @"MyAdvertRevisionKey"
#define WATCH_LIST_REVISION         @"WatchListRevisionKey"
#define USERS_REVISION              @"UsersRevision"
#define BUYER_OFFER_REVISION        @"BuyerOfferRevisiontKey"
#define SELLER_OFFER_REVISION       @"BuyerOfferRevisiontKey"

@implementation AppSettings

+(NSString*)getStorageFolder{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

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

+(void)resetMyAdvertRevision{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MY_ADVERT_REVISION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)updateMyAdvertRevision{
    [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:MY_ADVERT_REVISION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSDate*)getMyAdvertRevision{
    return [[NSUserDefaults standardUserDefaults] valueForKey:MY_ADVERT_REVISION];
}

+(void)resetWatchListRevision{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:WATCH_LIST_REVISION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)updateWatchListRevision{
    [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:WATCH_LIST_REVISION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSDate*)getWatchListRevision{
    return [[NSUserDefaults standardUserDefaults] valueForKey:WATCH_LIST_REVISION];
}

//+(void)resetMyAdvertRevision{
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MY_ADVERT_REVISION];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+(void)updateMyAdvertRevision{
//    [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:MY_ADVERT_REVISION];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+(NSDate*)getMyAdvertRevision{
//    return [[NSUserDefaults standardUserDefaults] valueForKey:MY_ADVERT_REVISION];
//}


+(void)resetBuyerRevision{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:BUYER_OFFER_REVISION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)updateBuyerOfferRevision{
    [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:BUYER_OFFER_REVISION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSDate*)getBuyerOfferRevision{
    return [[NSUserDefaults standardUserDefaults] valueForKey:BUYER_OFFER_REVISION];
}

+(void)resetSellerRevision{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SELLER_OFFER_REVISION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)updateSellerOfferRevision{
    [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:SELLER_OFFER_REVISION];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

+(NSDate*)getSellerOfferRevision{
    return [[NSUserDefaults standardUserDefaults] valueForKey:SELLER_OFFER_REVISION];
}

@end
