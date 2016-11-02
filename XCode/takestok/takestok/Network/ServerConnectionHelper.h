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
-(void)loadOfferStatuses:(tsResultBlock)resultBlock;

//Adevrts
-(void)loadAdvertsWithIdents:(NSArray*)idents compleate:(tsResultBlock)compleate;
-(void)loadAdvertsWithUser:(NSNumber*)userId page:(int)page compleate:(tsResultBlock)compleate;
-(void)loadAdvertsWithSort:(NSString*)sort search:(NSString*)search category:(NSNumber*)category subCategory:(NSNumber*)subCategory page:(int)page compleate:(tsResultBlock)compleate;
-(void)loadWatchListWithPage:(int)page compleate:(tsResultBlock)compleate;
-(void)createAdvert:(NSDictionary*)advertDic compleate:(tsResultBlock)compleate;
-(void)editAdvertWithId:(NSNumber*)advertId withDic:(NSDictionary*)advertDic compleate:(tsResultBlock)compleate;
-(void)addToWatchList:(NSNumber*)advertId compleate:(tsResultBlock)compleate;
-(void)loadDraftsWithPage:(int)page userId:(NSNumber*)userId compleate:(tsResultBlock)compleate;
-(void)loadExpiredWithPage:(int)page userId:(NSNumber*)userId compleate:(tsResultBlock)compleate;
-(void)loadHoldOndWithPage:(int)page userId:(NSNumber*)userId compleate:(tsResultBlock)compleate;
-(void)sendViwAdvert:(NSNumber*)advertId;
-(void)sendReadNotificationsWithAdvert:(NSNumber*)advertId compleate:(tsResultBlock)compleate;
-(void)loadAdvertsWithPage:(int)page similar:(NSNumber*)advertId compleate:(tsResultBlock)compleate;
-(void)loadUserAdvertsWithPage:(int)page similar:(NSNumber*)advertId compleate:(tsResultBlock)compleate;

//QA
-(void)loadQuestionAnswersWith:(NSNumber*)advertId page:(int)page compleate:(tsResultBlock)compleate;
-(void)askQuestion:(NSDictionary*)question compleate:(tsResultBlock)compleate;
-(void)sendAnswer:(NSDictionary*)answer compleate:(tsResultBlock)compleate;

//User
-(void)signInWithUserName:(NSString*)username password:(NSString*)password compleate:(tsResultBlock)compleate;
-(void)signUpWithUserName:(NSString*)username email:(NSString*)email password:(NSString*)password compleate:(tsResultBlock)compleate;
-(void)loadUsersWithIds:(NSArray*)userIds compleate:(tsResultBlock)compleate;
-(void)updateUser:(NSDictionary*)userData compleate:(tsResultBlock)compleate;
-(void)sendAPNSToken:(NSDictionary*)data compleate:(tsResultBlock)compleate;
-(void)removeAPNSToken:(NSString*)token;

//Offers
-(void)loadOffer:(NSNumber*)offerId compleate:(tsResultBlock)compleate;
-(void)loadOffersWithAdvert:(NSNumber*)advertId page:(int)page compleate:(tsResultBlock)compleate;
-(void)loadMyOffersWithPage:(int)page compleate:(tsResultBlock)compleate;
-(void)createOffer:(NSDictionary*)offer compleate:(tsResultBlock)compleate;
-(void)updateOffer:(NSDictionary*)offer compleate:(tsResultBlock)compleate;
-(void)payOffer:(NSNumber*)offerId withToken:(NSString *)token completion:(tsResultBlock)compleate;

@end
