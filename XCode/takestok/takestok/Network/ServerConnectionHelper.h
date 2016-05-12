//
//  ServerConnectionHalper.h
//  takestok
//
//  Created by Artem on 4/19/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Reachability;
@class Advert;
@class User;
@class SortData;

@interface ServerConnectionHelper : NSObject{
    Reachability* _reachability;
    NSURLSession *_session;
    
    NSURLSessionDataTask* _loadAdvertCancelTask;
}

+(ServerConnectionHelper*)sharedInstance;
-(BOOL)isInternetConnection;
-(void)loadAdvertWithSortData:(SortData*)sortData page:(int)page compleate:(void(^)(NSArray* adverbs, NSDictionary* additionalData, NSError* error))compleate;
-(void)createAdvert:(Advert*)advert compleate:(void(^)(NSError* error))compleate;
-(void)loadRequiredData;
-(void)loadUser:(int)ident compleate:(void(^)(User* user, NSError* error))compleate;
-(void)signIn:(NSString*)username password:(NSString*)password compleate:(void(^)(NSError* error))compleate;

@end
