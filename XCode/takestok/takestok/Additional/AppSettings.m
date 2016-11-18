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
#define STRIPE_FEE                  @"StripeFeeKey"

@implementation AppSettings

+(NSString*)getStorageFolder{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+(NSNumber*)getUserId{
    return [[NSUserDefaults standardUserDefaults] valueForKey:USER_ID];
}

+(void)setUserId:(NSNumber*)ident{
    [[NSUserDefaults standardUserDefaults] setValue:ident forKey:USER_ID];
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

+(int)getStripeFee{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:STRIPE_FEE] intValue];
}

+(void)setStripeFee:(int)ident{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:ident] forKey:STRIPE_FEE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
