//
//  Settings.m
//  takestok
//
//  Created by Artem on 5/4/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "Settings.h"

#define USER_ID @"UserIdKey"

@implementation Settings

+(int)getUserId{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:USER_ID] intValue];
}

+(void)setUserId:(int)ident{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:ident] forKey:USER_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
