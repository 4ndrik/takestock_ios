//
//  ServerConnectionHalper.h
//  takestok
//
//  Created by Artem on 4/19/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFURLSessionManager;
@class Advert;
@class User;
@class SortData;
@class MainThreadRecursiveLock;
@class Offer;

@interface ServerConnectionHelper : NSObject{
    AFURLSessionManager *_session;
    NSURLSessionDataTask* _loadAdvertCancelTask;
    MainThreadRecursiveLock* _dictionaryLock;
    MainThreadRecursiveLock* _advertLock;
}

+(ServerConnectionHelper*)sharedInstance;
-(BOOL)isInternetConnection;
-(void)loadAdvertWithSortData:(SortData*)sortData page:(int)page compleate:(void(^)(NSArray* adverbs, NSDictionary* additionalData, NSError* error))compleate;
-(void)createAdvert:(Advert*)advert compleate:(void(^)(NSError* error))compleate;
-(void)createOffer:(Offer*)offer compleate:(void(^)(NSError* error))compleate;
-(void)loadRequiredData;
-(void)loadUsers:(NSArray*)idents compleate:(void(^)(NSArray* users, NSError* error))compleate;
-(void)signIn:(NSString*)username password:(NSString*)password compleate:(void(^)(NSError* error))compleate;

@end
