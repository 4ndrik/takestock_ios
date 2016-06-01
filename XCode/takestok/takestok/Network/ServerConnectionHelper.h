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
@class Question;
@class Answer;
@class Category;

typedef void (^errorBlock)(NSError* error);
typedef void (^resultBlock)(NSArray* result, NSDictionary* additionalData, NSError* error);

@interface ServerConnectionHelper : NSObject{
    AFURLSessionManager *_session;
    NSURLSessionDataTask* _loadAdvertCancelTask;
    MainThreadRecursiveLock* _dictionaryLock;
    MainThreadRecursiveLock* _advertLock;
    MainThreadRecursiveLock* _usersLock;
    MainThreadRecursiveLock* _offersLock;
    MainThreadRecursiveLock* _qaLock;
}

+(ServerConnectionHelper*)sharedInstance;
-(BOOL)isInternetConnection;

-(void)loadRequiredData;

-(void)loadAdvertWithSortData:(SortData*)sortData searchString:(NSString*)searchString category:(Category*)category page:(int)page compleate:(resultBlock)compleate;
-(void)createAdvert:(Advert*)advert compleate:(void(^)(NSError* error))compleate;

-(void)createOffer:(Offer*)offer compleate:(errorBlock)compleate;
-(void)updateOffer:(Offer*)offer compleate:(errorBlock)compleate;

-(void)loadUsers:(NSArray*)idents compleate:(void(^)(NSArray* users, NSError* error))compleate;
-(void)signInWithUserName:(NSString*)username password:(NSString*)password compleate:(errorBlock)compleate;
-(void)signUpWithUserName:(NSString*)username email:(NSString*)email password:(NSString*)password compleate:(errorBlock)compleate;

-(void)loadQuestionAnswersWithAd:(Advert*)advert page:(int)page compleate:(resultBlock)compleate;
-(void)askQuestion:(Question*)question compleate:(errorBlock)compleate;
-(void)sendAnswer:(Answer*)answer compleate:(errorBlock)compleate;

@end
