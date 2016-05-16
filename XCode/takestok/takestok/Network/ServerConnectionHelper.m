//
//  ServerConnectionHalper.m
//  takestok
//
//  Created by Artem on 4/19/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "ServerConnectionHelper.h"
#import "Advert.h"
#import "Condition.h"
#import "Shipping.h"
#import "Certification.h"
#import "SizeType.h"
#import "Category.h"
#import "NSDictionary+HandleNil.h"
#import "AppSettings.h"
#import "SortData.h"
#import "Offer.h"
#import "OfferStatus.h"
#import "MainThreadRecursiveLock.h"
#import "Question.h"
#import "Answer.h"

#import <AFNetworking.h>

typedef enum
{
    HTTP_METHOD_GET,
    HTTP_METHOD_POST,
    HTTP_METHOD_PUT,
    HTTP_METHOD_DELETE
} HTTP_METHOD;

#define TAKESTOK_URL                @"http://takestock.shalakh.in/api/v1/"

#define JSON_CONTENT_TYPE           @"application/json"

#define USER_URL_PATH               @"users"
#define ADVERTS_URL_PATH            @"adverts"
#define CONDITIONS_URL_PATH         @"conditions"
#define SHIPPING_URL_PATH           @"shipping"
#define CATEGORIES_URL_PATH         @"category"
#define CERTIFICATIONS_URL_PATH     @"certifications"
#define PACKAGING_URL_PATH          @"packaging"
#define SIZE_TYPES_URL_PATH         @"size_types"
#define OFFER_STATUS_URL_PATH       @"offer_status"
#define SIGN_IN_URL_PATH            @"token/auth"
#define OFFERS_URL_PATH             @"offers"
#define QUESTIONS_URL_PATH          @"qa/questions"


#define SERVER_RESPONCE_RESULT_PARAM                  @"results"

#define SIGNATURE @"JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6IlVzZXJBcnRlbSIsImVtYWlsIjoic2VyYmluYXJ0ZW1AZ21haWwuY29tIiwiZXhwIjoxNDY1NDk1MDcyLCJ1c2VyX2lkIjoxMH0.aShOZUtVmZB_iMol3H04MYp7SlFfSHWmO2sFyF0xb6Y"

@implementation ServerConnectionHelper

-(id)init
{
    self = [super init];
    
    _dictionaryLock = [[MainThreadRecursiveLock alloc] init];
    _advertLock = [[MainThreadRecursiveLock alloc] init];
    _usersLock = [[MainThreadRecursiveLock alloc] init];
    
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

-(void)loadConditions{
    [_dictionaryLock lock];
    
    NSURLSessionDataTask* loadConditionsTask = [_session dataTaskWithRequest:[self request:CONDITIONS_URL_PATH query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error]){
            NSArray* conditions = [result objectForKeyNotNull:@"conditions"];
            if (conditions){
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [Condition syncWithJsonArray:conditions];
                });
            }
        }
        [_dictionaryLock unlock];
    }];
    [loadConditionsTask resume];
}

-(void)loadCertifications{
    [_dictionaryLock lock];
    NSURLSessionDataTask* loadCertificationTask = [_session dataTaskWithRequest:[self request:CERTIFICATIONS_URL_PATH query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error]){
            if (result){
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [Certification syncWithJsonArray:result];
                });
            }
        }
        [_dictionaryLock unlock];
    }];
    [loadCertificationTask resume];
}

-(void)loadShipping{
    [_dictionaryLock lock];
    NSURLSessionDataTask* loadShippingTask = [_session dataTaskWithRequest:[self request:SHIPPING_URL_PATH query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error]){
            NSArray* shippings = [result objectForKeyNotNull:@"shipping"];
            if (shippings){
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [Shipping syncWithJsonArray:shippings];
                });
            }
        }
        [_dictionaryLock unlock];
    }];
    [loadShippingTask resume];
}

-(void)loadSize{
    [_dictionaryLock lock];
    NSURLSessionDataTask* loadSizeTask = [_session dataTaskWithRequest:[self request:SIZE_TYPES_URL_PATH query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error]){
            NSArray* sizeTypes = [result  objectForKeyNotNull:@"types"];
            if (sizeTypes){
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [SizeType syncWithJsonArray:sizeTypes];
                });
            }
        }
        [_dictionaryLock unlock];
    }];
    [loadSizeTask resume];
}

-(void)loadCategory{
    [_dictionaryLock lock];
    NSURLSessionDataTask* loadCategoryTask = [_session dataTaskWithRequest:[self request:CATEGORIES_URL_PATH query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error]){
            if (result){
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [Category syncWithJsonArray:result];
                });
            }
        }
        [_dictionaryLock unlock];
    }];
    [loadCategoryTask resume];
}

-(void)loadPackaging{
    [_dictionaryLock lock];
    NSURLSessionDataTask* loadPackagingTask = [_session dataTaskWithRequest:[self request:PACKAGING_URL_PATH query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error]){
            if (result){
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [Packaging syncWithJsonArray:result];
                });
            }
        }
        [_dictionaryLock unlock];
    }];
    [loadPackagingTask resume];
}

-(void)loadOfferStatus{
    [_dictionaryLock lock];
    NSURLSessionDataTask* loadOfferStatusTask = [_session dataTaskWithRequest:[self request:OFFER_STATUS_URL_PATH query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error]){
            NSArray* offerStatusArray = [result objectForKeyNotNull:@"status"];
            if (offerStatusArray){
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [OfferStatus syncWithJsonArray:offerStatusArray];
                });
            }
        }
        [_dictionaryLock unlock];
    }];
    [loadOfferStatusTask resume];
}

-(void)loadRequiredData{
    
    [self loadConditions];
    [self loadShipping];
    [self loadCertifications];
    [self loadSize];
    [self loadCategory];
    [self loadPackaging];
    [self loadOfferStatus];
    
    if ([AppSettings getUserId] > 0){
        [self loadUsers:[NSArray arrayWithObjects:[NSNumber numberWithInt:[AppSettings getUserId]], nil] compleate:nil];
        [self loadAdverts:0 userId:[AppSettings getUserId]];
        [self loadUserOffers];
    }
}

-(void)waitLock:(MainThreadRecursiveLock*)lock andPerform:(void (^)())compleate{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [lock waitUntilDone];
        compleate();
    });
}

#pragma mark - Advert

-(void)loadAdverts:(int)ident userId:(int)userId{
    [_advertLock lock];
    NSString* method = ADVERTS_URL_PATH;
    if (ident > 0){
        method = [NSString stringWithFormat:@"%@/%i", ADVERTS_URL_PATH, ident];
    }
    
    NSURLSessionDataTask *loadAdvertTask = [_session dataTaskWithRequest:[self request:method query:userId > 0 ? [NSString stringWithFormat:@"author_id=%i", userId] : nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable data, NSError * _Nullable error) {
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:data error:&error])
        {
            NSDictionary* result = data;
            if (!error){
                NSMutableArray* array = [result objectForKeyNotNull:SERVER_RESPONCE_RESULT_PARAM];
                if (!array){
                    array = [NSMutableArray array];
                    [array addObject:result];
                }
                [_dictionaryLock waitUntilDone];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        for (NSDictionary* advertDic in array) {
                            int advertId = [[advertDic objectForKeyNotNull:ADVERT_ID_PARAM] intValue];
                            Advert* advert = [Advert getEntityWithId:advertId];
                            if (!advert){
                                advert = [Advert storedEntity];
                            }
                            [advert updateWithDic:advertDic];
                        }
                    });
            }
        }
        [_advertLock unlock];
    }];
    [loadAdvertTask resume];
}

-(void)loadAdvertWithSortData:(SortData*)sortData page:(int)page compleate:(void(^)(NSArray* adverbs, NSDictionary* additionalData, NSError* error))compleate{
    [_loadAdvertCancelTask cancel];
    _loadAdvertCancelTask = [_session dataTaskWithRequest:[self request:ADVERTS_URL_PATH query:[NSString stringWithFormat:@"o=%@&page=%i", sortData.value, page] methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [_dictionaryLock waitUntilDone];
        _loadAdvertCancelTask = nil;
        NSMutableDictionary* additionalDic;
        NSMutableArray* adverts;
        if (error)
        {
            //Ignore cancelled
            if ([[error localizedDescription] isEqualToString:@"cancelled"]){
                return;
            }
        }
        else if (![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error])
        {
            if (!error){
                additionalDic = [NSMutableDictionary dictionaryWithDictionary:result];
                [additionalDic removeObjectForKey:SERVER_RESPONCE_RESULT_PARAM];
                NSArray* array = [result objectForKeyNotNull:SERVER_RESPONCE_RESULT_PARAM];
                adverts = [NSMutableArray arrayWithCapacity:array.count];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    for (NSDictionary* advertDic in array) {
                        int advertId = [[advertDic objectForKeyNotNull:ADVERT_ID_PARAM] intValue];
                        Advert* advert = [Advert getEntityWithId:advertId];
                        if (!advert){
                            advert = [Advert tempEntity];
                        }
                        [advert updateWithDic:advertDic];
                        [adverts addObject:advert];
                    }
                });
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            compleate(adverts, additionalDic, error);
        });
    }];
    [_loadAdvertCancelTask resume];
}

-(void)createAdvert:(Advert*)advert compleate:(void(^)(NSError* error))compleate{
    NSDictionary* advertData = [advert getDictionary];
    NSError* error;
    NSString* params = [self jsonStringFromDicOrArray:advertData error:&error];
    
    NSURLSessionDataTask * dataTask = [_session dataTaskWithRequest:[self request:ADVERTS_URL_PATH query:params methodType:HTTP_METHOD_POST contentType:JSON_CONTENT_TYPE] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error])
        {
            if (!error){
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [advert updateWithDic:result];
                });
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            compleate(error);
        });
    }];
    
    [dataTask resume];
}

#pragma mark - Offers
-(void)loadUserOffers{
    NSURLSessionDataTask* loadOffersTask = [_session dataTaskWithRequest:[self request:OFFERS_URL_PATH query:[NSString stringWithFormat:@"user=%i", [AppSettings getUserId]] methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        [_advertLock waitUntilDone];
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error]){
            NSMutableArray* offers = [result objectForKeyNotNull:SERVER_RESPONCE_RESULT_PARAM];
            if (offers){
                //TODO: Update date
                NSMutableSet* advertIdSet = [NSMutableSet set];
                for (NSDictionary* offer in offers) {
                    int advertId = [[offer objectForKeyNotNull:OFFER_ADVERT_PARAM] intValue];
                    if (advertId > 0)
                        [advertIdSet addObject:[NSNumber numberWithInt:advertId]];
                }
                for (NSNumber* number in advertIdSet) {
                    [self loadAdverts:[number intValue] userId:0];
                }
                [_advertLock waitUntilDone];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    for (NSDictionary* offerDic in offers) {
                        Offer* offer = [Offer getEntityWithId:[[offerDic objectForKeyNotNull:OFFER_ID_PARAM] intValue]];
                        if (!offer){
                            offer = [Offer storedEntity];
                        }
                        [offer updateWithDic:offerDic];
                    }
                });
            }
        }
    }];
    
    [loadOffersTask resume];
}

-(void)createOffer:(Offer*)offer compleate:(void(^)(NSError* error))compleate{
    NSDictionary* offerData = [offer getDictionary];
    NSError* error;
    NSString* params = [self jsonStringFromDicOrArray:offerData error:&error];
    
    NSURLSessionDataTask * dataTask = [_session dataTaskWithRequest:[self request:OFFERS_URL_PATH query:params methodType:HTTP_METHOD_POST contentType:JSON_CONTENT_TYPE] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error])
        {
            [self loadUserOffers];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            compleate(error);
        });
    }];
    
    [dataTask resume];
}

#pragma mark - User
-(void)signIn:(NSString*)username password:(NSString*)password compleate:(void(^)(NSError* error))compleate{
    NSString *params = [NSString stringWithFormat:
                        @"{"
                        @"\"username\""           @":\"%@\","
                        @"\"password\""           @":\"%@\"}",
                        username,
                        password
                        ];
    
    NSURLSessionDataTask * dataTask = [_session dataTaskWithRequest:[self request:SIGN_IN_URL_PATH query:params methodType:HTTP_METHOD_POST contentType:JSON_CONTENT_TYPE] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error])
        {
            if (!error){
                NSDictionary* userDic = [result objectForKeyNotNull:@"user"];
                int userId = [[userDic objectForKeyNotNull:USER_ID_PARAM] intValue];
                NSString* token = [result objectForKey:USER_TOKEN_PARAM];
                if (userId >= 0 && token.length > 0){
                    [AppSettings setToken:token];
                    [AppSettings setUserId:userId];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        User* user = [User getEntityWithId:userId];
                        if (!user){
                            user = [User storedEntity];
                        }
                        [user updateWithDic:userDic];
                        [self loadAdverts:0 userId:userId];
                        [self loadUserOffers];
                        [[DB sharedInstance].storedManagedObjectContext save:nil];
                    });
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            compleate(error);
        });
    }];
    
    [dataTask resume];
}

-(void)loadUsers:(NSArray*)idents compleate:(void(^)(NSArray* users, NSError* error))compleate{
    
    [_usersLock lock];
    NSString* method = USER_URL_PATH;
    if (idents.count == 1){
        method = [NSString stringWithFormat:@"%@/%@",USER_URL_PATH, idents.firstObject];
    }
    
    NSURLSessionDataTask* loadUserTask = [_session dataTaskWithRequest:[self request:method query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        NSMutableArray* users = [NSMutableArray array];
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error]){
            if (!error){
                NSMutableArray* usersArray = [result objectForKey:SERVER_RESPONCE_RESULT_PARAM];
                if (!usersArray){
                    usersArray = [NSMutableArray array];
                    [usersArray addObject:result];
                }
                dispatch_sync(dispatch_get_main_queue(), ^{
                    for (NSDictionary* userDic in usersArray) {
                        User* user = [User getEntityWithId:[[userDic objectForKeyNotNull:USER_ID_PARAM] intValue]];
                        if (!user){
                            user = [User storedEntity];
                        }
                        [user updateWithDic:userDic];
                        [users addObject:user];
                    }
                });
                
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (compleate)
                compleate(users, error);
        });
        [_usersLock unlock];
    }];
    
    [loadUserTask resume];
}

#pragma mark - QA

-(void)loadQuestionAnswersWithAdvId:(int)advertId page:(int)page compleate:(void(^)(NSArray* adverbs, NSDictionary* additionalData, NSError* error))compleate{
    NSURLSessionDataTask* loadUserTask = [_session dataTaskWithRequest:[self request:QUESTIONS_URL_PATH query:[NSString stringWithFormat:@"advert_id=%i", advertId] methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        NSMutableArray* questions;
        NSMutableDictionary* additionalDic;
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error]){
            if (!error){
                additionalDic = [NSMutableDictionary dictionaryWithDictionary:result];
                [additionalDic removeObjectForKey:SERVER_RESPONCE_RESULT_PARAM];
                NSArray* array = [result objectForKeyNotNull:SERVER_RESPONCE_RESULT_PARAM];
                questions = [NSMutableArray arrayWithCapacity:array.count];
                
                NSMutableSet* usersIdSet = [NSMutableSet set];
                for (NSDictionary* questionDic in array) {
                    int userId = [[questionDic objectForKeyNotNull:QUESTION_USER_PARAM] intValue];
                    if (userId > 0 && ![User getEntityWithId:userId])
                        [usersIdSet addObject:[NSNumber numberWithInt:userId]];
                    
                    NSDictionary* answer = [questionDic objectForKeyNotNull:QUESTION_ANSWER_PARAM];
                    userId = [[answer objectForKeyNotNull:ANSWER_USER_PARAM] intValue];
                    if (userId > 0 && ![User getEntityWithId:userId])
                        [usersIdSet addObject:[NSNumber numberWithInt:userId]];
                }
                
                for (NSNumber* number in usersIdSet) {
                    [self loadUsers:[NSArray arrayWithObjects:number, nil] compleate:nil];
                }
                [_usersLock waitUntilDone];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    for (NSDictionary* questionDic in array) {
                        int qId = [[questionDic objectForKeyNotNull:QUESTION_ID_PARAM] intValue];
                        Question* question = [Question getEntityWithId:qId];
                        if (!question){
                            question = [Question tempEntity];
                        }
                        [question updateWithDic:questionDic];
                        [questions addObject:question];
                    }
                });
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (compleate)
                 compleate(questions, additionalDic, error);
        });
    }];
    
    [loadUserTask resume];
}

-(void)askQuestion:(Question*)question compleate:(void(^)(NSError* error))compleate{
    NSDictionary* questionData = [question getDictionary];
    NSError* error;
    NSString* params = [self jsonStringFromDicOrArray:questionData error:&error];
    
    NSURLSessionDataTask * dataTask = [_session dataTaskWithRequest:[self request:QUESTIONS_URL_PATH query:params methodType:HTTP_METHOD_POST contentType:JSON_CONTENT_TYPE] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable result, NSError * _Nullable error) {
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:result error:&error])
        {
            NSLog(@"q asked");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            compleate(error);
        });
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
        NSString *value = [[parameters valueForKey:key] isKindOfClass:[NSString class]] ?
        [parameters valueForKey:key] : [[parameters valueForKey:key] stringValue];
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
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/", TAKESTOK_URL, method];
    
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
        {
            [request setHTTPMethod:methodType == HTTP_METHOD_POST ? @"POST" : @"PUT"];
            
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
    
    NSString* token = SIGNATURE;
    if ([AppSettings getToken].length > 0){
        token = [NSString stringWithFormat:@"JWT %@",[AppSettings getToken]];
    }
    [request setValue:token forHTTPHeaderField:@"Authorization"];
    
    if (contentType.length > 0){
        [request setValue:contentType forHTTPHeaderField:@"content-type"];
    }
    
    request.URL = [NSURL URLWithString:urlString];
    request.timeoutInterval = 180;
    
    return request;
}

-(BOOL)isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:(id)json error:(NSError**)error{
    if (!response || ([response statusCode] < 200 || [response statusCode] >= 300))
    {
        NSString* errorDescription = [json description];
        NSLog(@"url - %@ error - %li data - %@", response.URL, (long)response.statusCode, errorDescription);
        
        if ([json isKindOfClass:[NSDictionary class]] && [json objectForKeyNotNull:@"detail"]){
            errorDescription = [json objectForKeyNotNull:@"detail"];
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
