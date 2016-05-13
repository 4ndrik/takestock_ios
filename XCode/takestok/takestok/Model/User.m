//
//  User.m
//  takestok
//
//  Created by Artem on 5/4/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "User.h"
#import "Advert.h"
#import "Image.h"
#import "NSDictionary+HandleNil.h"
#import "AppSettings.h"

@implementation User

+ (NSString *)entityName {
    return @"User";
}

-(void)updateWithDic:(NSDictionary*)jsonDic{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = DEFAULT_DATE_FORMAT;
    
    self.ident = [[jsonDic objectForKeyNotNull:USER_ID_PARAM] intValue];
    self.lastLogin = [[dateFormatter dateFromString:[jsonDic objectForKeyNotNull:USER_LAST_LOGIN_PARAM]] timeIntervalSinceReferenceDate];
    self.userName = [jsonDic objectForKeyNotNull:USER_USER_NAME_PARAM];
    self.firstName = [jsonDic objectForKeyNotNull:USER_FIRST_NAME_PARAM];
    self.lastName = [jsonDic objectForKeyNotNull:USER_LAST_NAME_PARAM];
    self.email = [jsonDic objectForKeyNotNull:USER_EMAIL_PARAM];
    self.isVerified = [[jsonDic objectForKeyNotNull:USER_VERIFIED_PARAM] boolValue];
    self.isSubscribed = [[jsonDic objectForKeyNotNull:USER_SUBSCRIBED_PARAMS] boolValue];
    self.rating = [[jsonDic objectForKeyNotNull:USER_AVG_RATING_PARAM] floatValue];
    
    /*
    "is_staff": true,
    "is_active": true,
    "date_joined": "2016-03-16T17:52:43Z",
     */
    
}

+(User*)getMe{
    static User* _me;
    if (!_me && [AppSettings getUserId] > 0){
        _me = [User getEntityWithId:[AppSettings getUserId]];
    }
    return _me;
}

@end
