//
//  ServerConnectionHalper.h
//  takestok
//
//  Created by Artem on 4/19/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Stripe/Stripe.h>

@class AFURLSessionManager;
@class Advert;
@class User;
@class SortData;
@class MainThreadRecursiveLock;
@class Offer;
@class Question;
@class Answer;
@class Category;

@class STPToken;

typedef void (^errorBlock)(NSError* error);
typedef void (^resultBlock)(NSArray* result, NSDictionary* additionalData, NSError* error);

typedef void (^tsResultBlock)(id result, NSError* error);

@interface ServerConnectionHelper : NSObject{
    AFURLSessionManager *_session;
    NSURLSessionDataTask* _loadAdvertCancelTask;
    MainThreadRecursiveLock* _dictionaryLock;
    MainThreadRecursiveLock* _advertLock;
    MainThreadRecursiveLock* _usersLock;
    MainThreadRecursiveLock* _updateUsersLock;
    MainThreadRecursiveLock* _offersLock;
    MainThreadRecursiveLock* _qaLock;
}

+(ServerConnectionHelper*)sharedInstance;
-(BOOL)isInternetConnection;

-(void)loadStates:(tsResultBlock)resultBlock;
-(void)loadSizeTypes:(tsResultBlock)resultBlock;
-(void)loadCertifications:(tsResultBlock)resultBlock;
-(void)loadShipping:(tsResultBlock)resultBlock;
-(void)loadCategories:(tsResultBlock)resultBlock;
-(void)loadConditions:(tsResultBlock)resultBlock;
-(void)loadPackagingTypes:(tsResultBlock)resultBlock;
-(void)loadBusinessTypes:(tsResultBlock)resultBlock;

//Adevrts
-(void)loadAdvertsWithSort:(NSString*)sort search:(NSString*)search category:(NSNumber*)category subCategory:(NSNumber*)subCategory page:(int)page compleate:(tsResultBlock)compleate;
-(void)createAdvert:(NSDictionary*)advertDic compleate:(tsResultBlock)compleate;
-(void)editAdvertWithId:(NSNumber*)advertId withDic:(NSDictionary*)advertDic compleate:(tsResultBlock)compleate;

//QA
-(void)loadQuestionAnswersWith:(NSNumber*)advertId page:(int)page compleate:(tsResultBlock)compleate;
-(void)askQuestion:(NSDictionary*)question compleate:(tsResultBlock)compleate;
-(void)sendAnswer:(NSDictionary*)answer compleate:(tsResultBlock)compleate;

//User
-(void)signInWithUserName:(NSString*)username password:(NSString*)password compleate:(tsResultBlock)compleate;
-(void)signUpWithUserName:(NSString*)username email:(NSString*)email password:(NSString*)password compleate:(tsResultBlock)compleate;
-(void)loadUsersWithIds:(NSArray*)userIds compleate:(tsResultBlock)compleate;
-(void)updateUser:(NSDictionary*)userData compleate:(tsResultBlock)compleate;

//=====================//

-(void)loadRequiredData;

-(void)loadAdvertsWithSortData:(SortData*)sortData searchString:(NSString*)searchString category:(Category*)category page:(int)page compleate:(resultBlock)compleate;
-(void)addToWatchList:(Advert*)advert compleate:(void(^)(NSError* error))compleate;

-(void)createOffer:(Offer*)offer compleate:(errorBlock)compleate;
-(void)updateOffer:(Offer*)offer compleate:(errorBlock)compleate;
-(void)payOffer:(Offer*)offer withToken:(STPToken *)token completion:(errorBlock)compleate;

//-(void)signInWithUserName:(NSString*)username password:(NSString*)password compleate:(errorBlock)compleate;
//-(void)signUpWithUserName:(NSString*)username email:(NSString*)email password:(NSString*)password compleate:(errorBlock)compleate;
//-(void)updateUser:(User*)user image:(UIImage*)image compleate:(errorBlock)compleate;

//-(void)loadQuestionAnswersWithAd:(Advert*)advert page:(int)page compleate:(resultBlock)compleate;
//-(void)askQuestion:(Question*)question compleate:(errorBlock)compleate;
//-(void)sendAnswer:(Answer*)answer compleate:(errorBlock)compleate;

@end
