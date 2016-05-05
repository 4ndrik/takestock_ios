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

@implementation User

+ (NSString *)entityName {
    return @"User";
}

-(void)updateWithJSon:(NSDictionary*)jsonDic{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = (@"yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'");
    
    self.ident = [[jsonDic objectForKeyNotNull:@"id"] intValue];
    self.lastLogin = [[dateFormatter dateFromString:[jsonDic objectForKeyNotNull:@"last_login"]] timeIntervalSinceReferenceDate];
    self.userName = [jsonDic objectForKeyNotNull:@"username"];
    self.firstName = [jsonDic objectForKeyNotNull:@"first_name"];
    self.lastName = [jsonDic objectForKeyNotNull:@"last_name"];
    self.email = [jsonDic objectForKeyNotNull:@"email"];
    self.isVerified = [[jsonDic objectForKeyNotNull:@"is_verified"] boolValue];
    self.isSubscribed = [[jsonDic objectForKeyNotNull:@"is_subscribed"] boolValue];
    self.rating = [[jsonDic objectForKeyNotNull:@"is_subscribed"] floatValue];
    
    /*
    "is_staff": true,
    "is_active": true,
    "date_joined": "2016-03-16T17:52:43Z",
     */
    
}

@end
