//
//  ServerConnectionHalper.m
//  takestok
//
//  Created by Artem on 4/19/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "ServerConnectionHelper.h"
#import "NSDictionary+HandleNil.h"
#import "AppSettings.h"
#import "MainThreadRecursiveLock.h"

#import <AFNetworking.h>
#import "NSData+base64.h"

typedef enum
{
    HTTP_METHOD_GET,
    HTTP_METHOD_POST,
    HTTP_METHOD_PUT,
    HTTP_METHOD_PATCH,
    HTTP_METHOD_DELETE
} HTTP_METHOD;

#define JSON_CONTENT_TYPE           @"application/json"

#define USER_URL_PATH               @"users"
#define ME_URL_PATH                 @"me"
#define BUSINESSTYPES_URL_PATH      @"a/businesstype"
#define ADVERTS_URL_PATH            @"adverts"
#define ADD_TO_WATCH_LIST_URL_PATH  @"to_watchlist"
#define ADD_PAYMENT_URL             @"pay"
#define CONDITIONS_URL_PATH         @"conditions"
#define SHIPPING_URL_PATH           @"shipping"
#define CATEGORIES_URL_PATH         @"category"
#define STATES_URL_PATH             @"state"
#define CERTIFICATIONS_URL_PATH     @"certifications"
#define PACKAGING_URL_PATH          @"packaging"
#define SIZE_TYPES_URL_PATH         @"size_types"
#define OFFER_STATUS_URL_PATH       @"offer_status"
#define SIGN_IN_URL_PATH            @"token/auth"
#define SIGN_UP_URL_PATH            @"token/register"
#define OFFERS_URL_PATH             @"offers"
#define OFFERS_UPDATE_URL_PATH      @"accept_offer"
#define QUESTIONS_URL_PATH          @"qa/questions"
#define ANSWERS_URL_PATH            @"qa/answers"


#define SERVER_RESPONSE_RESULT_PARAM                  @"results"

@implementation ServerConnectionHelper

-(id)init
{
    self = [super init];
    
    _dictionaryLock = [[MainThreadRecursiveLock alloc] init];
    _advertLock = [[MainThreadRecursiveLock alloc] init];
    _usersLock = [[MainThreadRecursiveLock alloc] init];
    _offersLock = [[MainThreadRecursiveLock alloc] init];
    _qaLock = [[MainThreadRecursiveLock alloc] init];
    _updateUsersLock = [[MainThreadRecursiveLock alloc] init];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    _session.completionQueue =  dispatch_queue_create("com.takestok.queu", DISPATCH_QUEUE_CONCURRENT);
    return self;
}

+(ServerConnectionHelper*)sharedInstance
{
    static ServerConnectionHelper* singleton = nil;
    static dispatch_once_t predicate;
    dispatch_once( &predicate, ^{
        singleton = [[ self alloc ] init];
    } );
    return singleton;
}

-(BOOL)isInternetConnection
{
    return [_session.reachabilityManager networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable;
}

#pragma mark - Dictionaries

-(void)loadStates:(tsResultBlock)resultBlock{
    [_dictionaryLock lock];
    NSURLSessionDataTask* loadCategoryTask = [_session dataTaskWithRequest:[self request:STATES_URL_PATH query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        resultBlock(result, error);
        [_dictionaryLock unlock];
    }];
    [loadCategoryTask resume];
}

-(void)loadSizeTypes:(tsResultBlock)resultBlock{
    [_dictionaryLock lock];
    NSURLSessionDataTask* loadSizeTask = [_session dataTaskWithRequest:[self request:SIZE_TYPES_URL_PATH query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        resultBlock([result objectForKeyNotNull:@"types"], error);
        [_dictionaryLock unlock];
    }];
    [loadSizeTask resume];
}

-(void)loadCertifications:(tsResultBlock)resultBlock{
    [_dictionaryLock lock];
    NSURLSessionDataTask* loadCertificationTask = [_session dataTaskWithRequest:[self request:CERTIFICATIONS_URL_PATH query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        resultBlock(result, error);
        [_dictionaryLock unlock];
    }];
    [loadCertificationTask resume];
}

-(void)loadShipping:(tsResultBlock)resultBlock{
    [_dictionaryLock lock];
    NSURLSessionDataTask* loadShippingTask = [_session dataTaskWithRequest:[self request:SHIPPING_URL_PATH query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        resultBlock([result objectForKeyNotNull:@"shipping"], error);
        [_dictionaryLock unlock];
    }];
    [loadShippingTask resume];
}

-(void)loadConditions:(tsResultBlock)resultBlock{
    [_dictionaryLock lock];
    NSURLSessionDataTask* loadConditionsTask = [_session dataTaskWithRequest:[self request:CONDITIONS_URL_PATH query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        resultBlock([result objectForKeyNotNull:@"conditions"], error);
        [_dictionaryLock unlock];
    }];
    [loadConditionsTask resume];
}

-(void)loadCategories:(tsResultBlock)resultBlock{
    [_dictionaryLock lock];
    NSURLSessionDataTask* loadCategoryTask = [_session dataTaskWithRequest:[self request:CATEGORIES_URL_PATH query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        resultBlock(result, error);
        [_dictionaryLock unlock];
    }];
    [loadCategoryTask resume];
}

-(void)loadPackagingTypes:(tsResultBlock)resultBlock{
    [_dictionaryLock lock];
    NSURLSessionDataTask* loadPackagingTask = [_session dataTaskWithRequest:[self request:PACKAGING_URL_PATH query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        resultBlock(result, error);
        [_dictionaryLock unlock];
    }];
    [loadPackagingTask resume];
}

-(void)loadBusinessTypes:(tsResultBlock)resultBlock{
    [_dictionaryLock lock];
    NSURLSessionDataTask* loadOfferStatusTask = [_session dataTaskWithRequest:[self request:BUSINESSTYPES_URL_PATH query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        resultBlock(result, error);
        [_dictionaryLock unlock];
    }];
    [loadOfferStatusTask resume];
}

-(void)loadOfferStatuses:(tsResultBlock)resultBlock{
    [_dictionaryLock lock];
    NSURLSessionDataTask* loadOfferStatusTask = [_session dataTaskWithRequest:[self request:OFFER_STATUS_URL_PATH query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        resultBlock([result objectForKeyNotNull:@"status"], error);
        [_dictionaryLock unlock];
    }];
    [loadOfferStatusTask resume];
}

#pragma mark - Adverts

-(void)loadAdvertsWithUser:(NSNumber*)userId page:(int)page compleate:(tsResultBlock)compleate{
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:page], @"page", @"-updated_at", @"o", @"hold_on",@"in", userId,@"author_id",nil];
    
    NSString* query = [self makeParamtersString:params withEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask* loadAdvertCancelTask = [_session dataTaskWithRequest:[self request:ADVERTS_URL_PATH query:query methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [_dictionaryLock waitUntilDone];
        [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        compleate(result, error);
    }];
    [loadAdvertCancelTask resume];
}

-(void)loadAdvertsWithIdents:(NSArray*)idents compleate:(tsResultBlock)compleate{
    NSString* query = [NSString stringWithFormat:@"ids=%@", [idents componentsJoinedByString:@","]];
    NSURLSessionDataTask *loadAdvertTask = [_session dataTaskWithRequest:[self request:ADVERTS_URL_PATH query:query methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        compleate([result objectForKeyNotNull:@"results"], error);

    }];
    [loadAdvertTask resume];
}

-(void)loadAdvertsWithSort:(NSString*)sort search:(NSString*)search category:(NSNumber*)category subCategory:(NSNumber*)subCategory page:(int)page compleate:(tsResultBlock)compleate{
    //Cancel prev request
    [_loadAdvertCancelTask cancel];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:page], @"page", sort, @"o", @"active,hold_on",@"in",nil];
    
    if (search.length > 0){
        [params setValue:search forKey:@"q"];
    }
    
    if (category){
        [params setValue:category forKey:@"category"];
    }
    
    if (subCategory){
        [params setValue:subCategory forKey:@"subcategory"];
    }
    
    NSString* query = [self makeParamtersString:params withEncoding:NSUTF8StringEncoding];
    
    _loadAdvertCancelTask = [_session dataTaskWithRequest:[self request:ADVERTS_URL_PATH query:query methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [_dictionaryLock waitUntilDone];
        _loadAdvertCancelTask = nil;
        if (!error){
            [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        }
        compleate(result, error);
    }];
    [_loadAdvertCancelTask resume];
}

-(void)loadWatchListWithPage:(int)page compleate:(tsResultBlock)compleate{
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:page], @"page", @"-created_at", @"o", @"watchlist",@"filter", nil];
    
    NSString* query = [self makeParamtersString:params withEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask* loadAdvertCancelTask = [_session dataTaskWithRequest:[self request:ADVERTS_URL_PATH query:query methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [_dictionaryLock waitUntilDone];
        [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        compleate(result, error);
    }];
    [loadAdvertCancelTask resume];
}

-(void)loadDraftsWithPage:(int)page userId:(NSNumber*)userId compleate:(tsResultBlock)compleate{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:page], @"page", @"-created_at", @"o", @"drafts",@"in", userId, @"author_id", nil];
    
    NSString* query = [self makeParamtersString:params withEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask* loadAdvertCancelTask = [_session dataTaskWithRequest:[self request:ADVERTS_URL_PATH query:query methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [_dictionaryLock waitUntilDone];
        [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        compleate(result, error);
    }];
    [loadAdvertCancelTask resume];
}

-(void)loadExpiredWithPage:(int)page userId:(NSNumber*)userId compleate:(tsResultBlock)compleate{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:page], @"page", @"-created_at", @"o", @"expired",@"filter", userId,@"author_id", nil];
    
    NSString* query = [self makeParamtersString:params withEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask* loadAdvertCancelTask = [_session dataTaskWithRequest:[self request:ADVERTS_URL_PATH query:query methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [_dictionaryLock waitUntilDone];
        [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        compleate(result, error);
    }];
    [loadAdvertCancelTask resume];
}

-(void)createAdvert:(NSDictionary*)advertDic compleate:(tsResultBlock)compleate{
    NSError* error;
    NSString* params = [self jsonStringFromDicOrArray:advertDic error:&error];
    NSURLSessionDataTask * dataTask = [_session dataTaskWithRequest:[self request:ADVERTS_URL_PATH query:params methodType:HTTP_METHOD_POST contentType:JSON_CONTENT_TYPE] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        compleate(result, error);
    }];
    [dataTask resume];
}

-(void)editAdvertWithId:(NSNumber*)advertId withDic:(NSDictionary*)advertDic compleate:(tsResultBlock)compleate{
    NSError* error;
    NSString* params = [self jsonStringFromDicOrArray:advertDic error:&error];
    NSURLSessionDataTask * dataTask = [_session dataTaskWithRequest:[self request:[NSString stringWithFormat:@"%@/%@", ADVERTS_URL_PATH, advertId] query:params methodType:HTTP_METHOD_PATCH contentType:JSON_CONTENT_TYPE] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        compleate(result, error);
    }];
    [dataTask resume];
}

-(void)addToWatchList:(NSNumber*)advertId compleate:(tsResultBlock)compleate{
    NSMutableDictionary* paramsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:advertId, @"item_id", nil];
    NSError* error;
    NSString* params = [self jsonStringFromDicOrArray:paramsDic error:&error];
    NSURLSessionDataTask * dataTask = [_session dataTaskWithRequest:[self request:ADD_TO_WATCH_LIST_URL_PATH query:params methodType:HTTP_METHOD_POST contentType:JSON_CONTENT_TYPE] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        compleate(result, error);
    }];
    [dataTask resume];
}

#pragma mark - QA

-(void)loadQuestionAnswersWith:(NSNumber*)advertId page:(int)page compleate:(tsResultBlock)compleate{
    [_qaLock lock];
    NSString* query = [NSString stringWithFormat:@"adverts=%@&page=%i&o=-created_at", advertId, page];
    NSURLSessionDataTask* loadQATask = [_session dataTaskWithRequest:[self request:QUESTIONS_URL_PATH query:query methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        compleate(result, error);
    }];
    
    [loadQATask resume];
}

-(void)askQuestion:(NSDictionary*)question compleate:(tsResultBlock)compleate{
    NSString* params = [self jsonStringFromDicOrArray:question error:nil];
    
    NSURLSessionDataTask * dataTask = [_session dataTaskWithRequest:[self request:QUESTIONS_URL_PATH query:params methodType:HTTP_METHOD_POST contentType:JSON_CONTENT_TYPE] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        compleate(result, error);
    }];
    
    [dataTask resume];
}

-(void)sendAnswer:(NSDictionary*)answer compleate:(tsResultBlock)compleate{
    NSString* params = [self jsonStringFromDicOrArray:answer error:nil];
    
    NSURLSessionDataTask * dataTask = [_session dataTaskWithRequest:[self request:ANSWERS_URL_PATH query:params methodType:HTTP_METHOD_POST contentType:JSON_CONTENT_TYPE] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        compleate(result, error);
    }];
    
    [dataTask resume];
}

#pragma mark - User

-(void)signInWithUserName:(NSString*)username password:(NSString*)password compleate:(tsResultBlock)compleate{
    NSMutableDictionary* paramsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:username, @"username", password, @"password",nil];
    NSError* error;
    NSString* params = [self jsonStringFromDicOrArray:paramsDic error:&error];
    
    NSURLSessionDataTask * dataTask = [_session dataTaskWithRequest:[self request:SIGN_IN_URL_PATH query:params methodType:HTTP_METHOD_POST contentType:JSON_CONTENT_TYPE] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [_dictionaryLock waitUntilDone];
        [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        compleate(result, error);
    }];
    [dataTask resume];
}

-(void)signUpWithUserName:(NSString*)username email:(NSString*)email password:(NSString*)password compleate:(tsResultBlock)compleate{

    NSMutableDictionary* paramsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:email, @"email", username, @"username", password, @"password",nil];
    NSError* error;
    NSString* params = [self jsonStringFromDicOrArray:paramsDic error:&error];

    NSURLSessionDataTask * dataTask = [_session dataTaskWithRequest:[self request:SIGN_UP_URL_PATH query:params methodType:HTTP_METHOD_POST contentType:JSON_CONTENT_TYPE] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [_dictionaryLock waitUntilDone];
        [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        compleate(result, error);
    }];
    [dataTask resume];
}

-(void)loadUsersWithIds:(NSArray*)userIds compleate:(tsResultBlock)compleate{
    NSString* query = [self makeParamtersString:[NSDictionary dictionaryWithObjectsAndKeys:userIds, @"ids", nil] withEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask* loadUserTask = [_session dataTaskWithRequest:[self request:USER_URL_PATH query:query methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [_dictionaryLock waitUntilDone];
        [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        compleate(result, error);
    }];
    
    [loadUserTask resume];
}

-(void)updateUser:(NSDictionary*)userData compleate:(tsResultBlock)compleate{
    NSError* error;
    NSString* params = [self jsonStringFromDicOrArray:userData error:&error];
    
    NSURLSessionDataTask* updateUserTask = [_session dataTaskWithRequest:[self request:ME_URL_PATH query:params methodType:HTTP_METHOD_PATCH contentType:JSON_CONTENT_TYPE] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        compleate(result, error);
    }];
    
    [updateUserTask resume];
}

#pragma mark - Offers

-(void)loadOffer:(NSNumber*)offerId compleate:(tsResultBlock)compleate{
    NSString* query = @"view=child_offers";
    NSURLSessionDataTask* loadOffersTask = [_session dataTaskWithRequest:[self request:[NSString stringWithFormat:@"%@/%@", OFFERS_URL_PATH, offerId] query:query methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        compleate(result, error);
    }];
    [loadOffersTask resume];
}

-(void)loadOffersWithAdvert:(NSNumber*)advertId page:(int)page compleate:(tsResultBlock)compleate{
    NSString* query = [NSString stringWithFormat:@"adverts=%@&page=%i&o=-updated_at", advertId, page];
    NSURLSessionDataTask* loadOffersTask = [_session dataTaskWithRequest:[self request:OFFERS_URL_PATH query:query methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        compleate(result, error);
    }];
    [loadOffersTask resume];
}

-(void)loadMyOffersWithPage:(int)page compleate:(tsResultBlock)compleate{
    NSString* query = [NSString stringWithFormat:@"for=self&view=child_offers&page=%i&o=-updated_at&in=from_buyer", page];
    NSURLSessionDataTask* loadOffersTask = [_session dataTaskWithRequest:[self request:OFFERS_URL_PATH query:query methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        compleate(result, error);
    }];
    [loadOffersTask resume];
}

-(void)createOffer:(NSDictionary*)offer compleate:(tsResultBlock)compleate{
    NSString* params = [self jsonStringFromDicOrArray:offer error:nil];
    NSURLSessionDataTask * dataTask = [_session dataTaskWithRequest:[self request:OFFERS_URL_PATH query:params methodType:HTTP_METHOD_POST contentType:JSON_CONTENT_TYPE] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        compleate(result, error);
    }];
    
    [dataTask resume];
}

-(void)updateOffer:(NSDictionary*)offer compleate:(tsResultBlock)compleate{
    
    NSString* params = [self jsonStringFromDicOrArray:offer error:nil];
    NSURLSessionDataTask * dataTask = [_session dataTaskWithRequest:[self request:OFFERS_UPDATE_URL_PATH query:params methodType:HTTP_METHOD_POST contentType:JSON_CONTENT_TYPE] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        compleate(result, error);
    }];
    
    [dataTask resume];
}


- (void)payOffer:(NSNumber*)offerId withToken:(NSString *)token completion:(tsResultBlock)compleate {
    
    NSMutableDictionary* paramsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:offerId, @"offer_id", token, @"token", nil];
    NSError* error;
    NSString* params = [self jsonStringFromDicOrArray:paramsDic error:&error];
    
    NSURLSessionDataTask * dataTask = [_session dataTaskWithRequest:[self request:ADD_PAYMENT_URL query:params methodType:HTTP_METHOD_POST contentType:JSON_CONTENT_TYPE] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error];
        compleate(result, error);
    }];
    
    [dataTask resume];
}

#pragma mark - Helpers

- (NSString*)makeParamtersString:(NSDictionary*)parameters withEncoding:(NSStringEncoding)encoding
{
    if (nil == parameters || [parameters count] == 0)
        return nil;
    
    NSMutableString* stringOfParamters = [[NSMutableString alloc] init];
    NSEnumerator *keyEnumerator = [parameters keyEnumerator];
    id key = nil;
    while ((key = [keyEnumerator nextObject]))
    {
        NSString *value;
        if ([[parameters valueForKey:key] isKindOfClass:[NSString class]]){
            value = [parameters valueForKey:key];
        }else if ([[parameters valueForKey:key] isKindOfClass:[NSArray class]]){
            NSArray* ar = (NSArray*)[parameters valueForKey:key];
            value = [ar componentsJoinedByString:@","];
        }else if ([[parameters valueForKey:key] isKindOfClass:[NSSet class]]){
            NSSet* set = (NSSet*)[parameters valueForKey:key];
            value = [[set allObjects] componentsJoinedByString:@","];
        }else{
            value = [[parameters valueForKey:key] stringValue];
        }
        
        [stringOfParamters appendFormat:@"%@=%@&",
         [self URLEscaped:key withEncoding:encoding],
         [self URLEscaped:value withEncoding:encoding]];
    }
    
    // Delete last character of '&'
    NSRange lastCharRange = {[stringOfParamters length] - 1, 1};
    [stringOfParamters deleteCharactersInRange:lastCharRange];
    return stringOfParamters;
}

- (NSString *)URLEscaped:(NSString *)strIn withEncoding:(NSStringEncoding)encoding
{
    CFStringRef escaped = CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)strIn, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", CFStringConvertNSStringEncodingToEncoding(encoding));
    NSString *strOut = [NSString stringWithString:(__bridge NSString *)escaped];
    CFRelease(escaped);
    return strOut;
}

-(NSURLRequest*)request:(NSString*)method query:(NSString * _Nullable)query methodType:(HTTP_METHOD)methodType contentType:(NSString* _Nullable)contentType{
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
    request.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/", TAKESTOK_API_URL, method];
    
    switch (methodType) {
        case HTTP_METHOD_GET:
        case HTTP_METHOD_DELETE:
        {
            [request setHTTPMethod:methodType == HTTP_METHOD_GET ? @"GET" : @"DELETE"];
            if (query.length > 0)
            {
                NSURL* parsedURL = [NSURL URLWithString:urlString];
                NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
                urlString = [NSString stringWithFormat:@"%@%@%@", urlString, queryPrefix, query];
            }
            break;
        }
        case HTTP_METHOD_POST:
        case HTTP_METHOD_PUT:
        case HTTP_METHOD_PATCH:
        {
            if (methodType == HTTP_METHOD_POST)
                [request setHTTPMethod:@"POST"];
            else if (methodType == HTTP_METHOD_PUT)
                [request setHTTPMethod:@"PUT"];
            else
                [request setHTTPMethod:@"PATCH"];
            
            if (query.length > 0)
            {
                NSData *requestData = [NSData dataWithBytes:[query UTF8String] length: [query length]];
                [request setHTTPBody: requestData ];
            }
            break;
        }
        default:
            break;
    }
    
    if ([AppSettings getToken].length > 0){
        [request setValue:[NSString stringWithFormat:@"JWT %@",[AppSettings getToken]] forHTTPHeaderField:@"Authorization"];
    }
    
    if (contentType.length > 0){
        [request setValue:contentType forHTTPHeaderField:@"content-type"];
    }
    
    request.URL = [NSURL URLWithString:urlString];
    request.timeoutInterval = 180;
    
    return request;
}

-(BOOL)isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:(id)json error:(NSError**)error{
    if (!response){
        if (![self isInternetConnection]){
            *error = [NSError errorWithDomain:@"0" code:0 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"No internet connection", nil]];
        }
        return YES;
    }else if ([response statusCode] < 200 || [response statusCode] >= 300)
    {
        NSString* errorDescription = [json description];
        NSLog(@"url - %@ error - %li data - %@", response.URL, (long)response.statusCode, errorDescription);
        
        if ([json isKindOfClass:[NSDictionary class]]){
            
            if ([json objectForKeyNotNull:@"detail"])
                errorDescription = [json objectForKeyNotNull:@"detail"];
            else
            {
                NSMutableString* errorString = [[NSMutableString alloc] init];
                for (NSString* key in [json allKeys]) {
                    [errorString appendFormat:@"%@: %@\n", key, json[key]];
                }
                [errorString deleteCharactersInRange:NSMakeRange(errorString.length - 2, 1)];
                errorDescription = errorString;
            }
        }
        *error = [NSError errorWithDomain:@"1" code:response.statusCode userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSHTTPURLResponse localizedStringForStatusCode:response.statusCode], NSLocalizedDescriptionKey, errorDescription, NSLocalizedFailureReasonErrorKey, nil]];
        return YES;
    }
    return NO;
}

-(nullable NSString*)jsonStringFromDicOrArray:(id)dictionaryOrArrayToOutput error:(NSError**)error{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryOrArrayToOutput
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:error];
    
    
    if (! jsonData) {
        return nil;
    } else {
        NSString* result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        result = [result stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
        return result;
    }
}


@end
