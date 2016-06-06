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
    self.ident = [[jsonDic objectForKeyNotNull:USER_ID_PARAM] intValue];
    NSTimeZone* timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    self.lastLogin = [[NSDate dateFromString:[jsonDic objectForKeyNotNull:USER_LAST_LOGIN_PARAM] format:DEFAULT_DATE_FORMAT timeZone:timeZone] timeIntervalSinceReferenceDate];
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

-(NSDictionary*)getDictionary{
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    if (self.ident > 0){
        [result setValue:[NSNumber numberWithInt:self.ident] forKey:ADVERT_ID_PARAM];
    }
    NSTimeZone* timeZone = [NSTimeZone systemTimeZone];
    if (self.lastLogin > 0){
        
        [result setValue:[NSDate stringFromTimeInterval:self.lastLogin format:DEFAULT_DATE_FORMAT timeZone:timeZone] forKey:USER_LAST_LOGIN_PARAM];
    }
    
    [result setValue:self.userName forKey:USER_USER_NAME_PARAM];
    [result setValue:self.firstName forKey:USER_FIRST_NAME_PARAM];
    [result setValue:self.lastName forKey:USER_LAST_NAME_PARAM];
    [result setValue:self.email forKey:USER_EMAIL_PARAM];
    [result setValue:[NSNumber numberWithBool:self.isVerified] forKey:USER_VERIFIED_PARAM];
    [result setValue:[NSNumber numberWithBool:self.isSubscribed] forKey:USER_SUBSCRIBED_PARAMS];
    [result setValue:[NSNumber numberWithFloat:self.rating] forKey:USER_AVG_RATING_PARAM];
    
//    if (self.image){
//        photo
//        NSFileManager* fileManager = [NSFileManager defaultManager];
//        
//        NSMutableArray* photos = [NSMutableArray arrayWithCapacity:self.images.count];
//        for (int i = 0; i < self.images.count; i++ ){
//            Image* image = [self.images objectAtIndex:i];
//            NSString* filePath = [ImageCacheUrlResolver getPathForImage:image];
//            
//            if ([fileManager fileExistsAtPath:filePath] && [[[fileManager attributesOfItemAtPath:filePath error:nil] objectForKey:@"NSFileSize"]intValue] > 0)
//            {
//                NSData *imageData = [NSData dataWithContentsOfFile:filePath];
//                NSString* imageString = [imageData base64Encoding];
//                [photos addObject:[NSString stringWithFormat:@"data:image/png;base64,%@",imageString]];
//            }
//        }
//        [result setValue:photos forKey:@"photos_list"];
//    }
    return result;
}


+(User*)getMe{
    static User* _me;
    if (!_me && [AppSettings getUserId] > 0){
        _me = [User getEntityWithId:[AppSettings getUserId]];
    }
    return _me;
}

@end
