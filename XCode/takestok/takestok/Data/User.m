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
#import "BusinessType.h"
#import "SubBusinessType.h"

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
    self.isVatRegistered = [[jsonDic objectForKeyNotNull:USER_VAT_REGISTERED_PARAM] boolValue];
    self.businessName = [jsonDic objectForKeyNotNull:USER_BUSINESS_NAME_PARAM];
    self.postCode = [[jsonDic objectForKeyNotNull:USER_POST_CODE_PARAM] stringValue];
    self.vatNumber = [[jsonDic objectForKeyNotNull:USER_VAT_NUMBER_PARAM] stringValue];
    
    BusinessType* bt = [BusinessType getEntityWithId:[[jsonDic objectForKeyNotNull:USER_BUSINESS_TYPE_PARAM] intValue]];
    if (bt && bt.managedObjectContext != self.managedObjectContext){
        bt = [self.managedObjectContext objectWithID:[bt objectID]];
    }
    self.businessType = bt;
    
    SubBusinessType* sbt = [SubBusinessType getEntityWithId:[[jsonDic objectForKeyNotNull:USER_BUSINESS_SYBTYPE_PARAM] intValue]];
    if (sbt && sbt.managedObjectContext != self.managedObjectContext){
        sbt = [self.managedObjectContext objectWithID:[sbt objectID]];
    }
    self.subBusinessType = sbt;
    
    NSString* url = [jsonDic objectForKeyNotNull:USER_PHOTO_PARAM];
    if (url){
        NSString* imIdent = [url lastPathComponent];
        Image* userImage = [Image getImageWithResId:imIdent];
        if (!userImage){
            userImage = self.isForStore ? [Image storedEntity] :[Image tempEntity];
        }else if (userImage.managedObjectContext != self.managedObjectContext){
            userImage = [self.managedObjectContext objectWithID:[userImage objectID]];
        }
        userImage.resId = imIdent;
        userImage.url = url;
        self.image = userImage;
    }
}

-(NSDictionary*)getDictionary{
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    if (self.ident > 0){
        [result setValue:[NSNumber numberWithInt:self.ident] forKey:USER_ID_PARAM];
    }
    
    [result setValue:self.userName forKey:USER_USER_NAME_PARAM];
    [result setValue:self.firstName forKey:USER_FIRST_NAME_PARAM];
    [result setValue:self.lastName forKey:USER_LAST_NAME_PARAM];
    [result setValue:[NSNumber numberWithBool:self.isSubscribed]  forKey:USER_SUBSCRIBED_PARAMS];
    
    [result setValue:[NSNumber numberWithBool:self.isVatRegistered]  forKey:USER_VAT_REGISTERED_PARAM];
    [result setValue:self.businessName forKey:USER_BUSINESS_NAME_PARAM];
    [result setValue:self.postCode forKey:USER_POST_CODE_PARAM];
    [result setValue:self.vatNumber forKey:USER_VAT_NUMBER_PARAM];
    
    [result setValue:[NSNumber numberWithInt:self.businessType.ident] forKey:USER_BUSINESS_TYPE_PARAM];
    [result setValue:[NSNumber numberWithInt:self.subBusinessType.ident] forKey:USER_BUSINESS_SYBTYPE_PARAM];
    
    return result;
}

static User* _me;
+(User*)getMe{
   
    if (_me && [AppSettings getUserId] <= 0){
        _me = nil;
    } else if (!_me && [AppSettings getUserId] > 0){
        _me = [User getEntityWithId:[AppSettings getUserId]];
    }
    return _me;
}

+(void)refreshUser{
    _me = nil;
}

@end
