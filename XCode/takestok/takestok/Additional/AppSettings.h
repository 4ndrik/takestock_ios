//
//  Settings.h
//  takestok
//
//  Created by Artem on 5/4/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSettings : NSObject

+(NSString*)getStorageFolder;

+(NSNumber*)getUserId;
+(void)setUserId:(NSNumber*)ident;

+(NSString*)getToken;
+(void)setToken:(NSString*)token;

+(int)getSearchSort;
+(void)setSearchSort:(int)ident;

+(int)getStripeFee;
+(void)setStripeFee:(int)ident;

@end
