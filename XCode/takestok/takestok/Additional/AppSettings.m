//
//  Settings.m
//  takestok
//
//  Created by Artem on 5/4/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "AppSettings.h"

#define USER_ID         @"UserIdKey"
#define USER_TOKEN      @"UserTokenKey"
#define SEARCH_SORT     @"SearchSortKey"

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

@end
