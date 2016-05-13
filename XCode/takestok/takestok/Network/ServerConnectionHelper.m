//
//  ServerConnectionHalper.m
//  takestok
//
//  Created by Artem on 4/19/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "ServerConnectionHelper.h"
#import "Reachability.h"
#import "Advert.h"
#import "Condition.h"
#import "Shipping.h"
#import "Certification.h"
#import "SizeType.h"
#import "Category.h"
#import "NSDictionary+HandleNil.h"
#import "Settings.h"
#import "SortData.h"
#import "Offer.h"
#import "OfferStatus.h"
#import "MainThreadRecursiveLock.h"

typedef enum
{
    HTTP_METHOD_GET,
    HTTP_METHOD_POST,
    HTTP_METHOD_PUT,
    HTTP_METHOD_DELETE
} HTTP_METHOD;

#define TAKESTOK_URL                @"http://takestock.shalakh.in/api/v1/"

#define JSON_CONTENT_TYPE           @"application/json"

#define USER_URL_PATH               @"users/"
#define ADVERTS_URL_PATH            @"adverts/"
#define CONDITIONS_URL_PATH         @"conditions/"
#define SHIPPING_URL_PATH           @"shipping/"
#define CATEGORIES_URL_PATH         @"category/"
#define CERTIFICATIONS_URL_PATH     @"certifications/"
#define PACKAGING_URL_PATH          @"packaging/"
#define SIZE_TYPES_URL_PATH         @"size_types/"
#define OFFER_STATUS_URL_PATH       @"offer_status/"
#define SIGN_IN_URL_PATH            @"token/auth/"
#define OFFERS_URL_PATH             @"offers/"


#define SERVER_RESPONCE_RESULT_PARAM                  @"results"

#define SIGNATURE @"JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6IlVzZXJBcnRlbSIsImVtYWlsIjoic2VyYmluYXJ0ZW1AZ21haWwuY29tIiwiZXhwIjoxNDY1NDk1MDcyLCJ1c2VyX2lkIjoxMH0.aShOZUtVmZB_iMol3H04MYp7SlFfSHWmO2sFyF0xb6Y"

@implementation ServerConnectionHelper

-(id)init
{
    self = [super init];
    
    _dictionaryLock = [[MainThreadRecursiveLock alloc] init];
    _advertLock = [[MainThreadRecursiveLock alloc] init];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    NSString *remoteHostName = @"www.apple.com";
    _reachability = [Reachability reachabilityWithHostName:remoteHostName];
    [_reachability startNotifier];
    
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
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

#pragma mark - Reachability

- (void) reachabilityChanged:(NSNotification *)note
{
    
}

-(BOOL)isInternetConnection
{
    return [_reachability currentReachabilityStatus] != NotReachable;
}

#pragma mark - Dictionaries

-(void)loadConditions{
    [_dictionaryLock lock];
    NSURLSessionDataTask* loadConditionsTask = [_session dataTaskWithRequest:[self request:CONDITIONS_URL_PATH query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:data error:&error]){
            NSArray* conditions = [[self jsonFromData:data error:&error] objectForKeyNotNull:@"conditions"];
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
    NSURLSessionDataTask* loadCertificationTask = [_session dataTaskWithRequest:[self request:CERTIFICATIONS_URL_PATH query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:data error:&error]){
            NSArray* certifications = [self jsonFromData:data error:&error];
            if (certifications){
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [Certification syncWithJsonArray:certifications];
                });
            }
        }
        [_dictionaryLock unlock];
    }];
    [loadCertificationTask resume];
}

-(void)loadShipping{
    [_dictionaryLock lock];
    NSURLSessionDataTask* loadShippingTask = [_session dataTaskWithRequest:[self request:SHIPPING_URL_PATH query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:data error:&error]){
            NSArray* shippings = [[self jsonFromData:data error:&error] objectForKeyNotNull:@"shipping"];
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
    NSURLSessionDataTask* loadSizeTask = [_session dataTaskWithRequest:[self request:SIZE_TYPES_URL_PATH query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:data error:&error]){
            NSArray* sizeTypes = [[self jsonFromData:data error:&error]  objectForKeyNotNull:@"types"];
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
    NSURLSessionDataTask* loadCategoryTask = [_session dataTaskWithRequest:[self request:CATEGORIES_URL_PATH query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:data error:&error]){
            NSArray* categories = [self jsonFromData:data error:&error];
            if (categories){
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [Category syncWithJsonArray:categories];
                });
            }
        }
        [_dictionaryLock unlock];
    }];
    [loadCategoryTask resume];
}

-(void)loadPackaging{
    [_dictionaryLock lock];
    NSURLSessionDataTask* loadPackagingTask = [_session dataTaskWithRequest:[self request:PACKAGING_URL_PATH query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:data error:&error]){
            NSArray* packagings = [self jsonFromData:data error:&error];
            if (packagings){
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [Packaging syncWithJsonArray:packagings];
                });
            }
        }
        [_dictionaryLock unlock];
    }];
    [loadPackagingTask resume];
}

-(void)loadOfferStatus{
    [_dictionaryLock lock];
    NSURLSessionDataTask* loadOfferStatusTask = [_session dataTaskWithRequest:[self request:OFFER_STATUS_URL_PATH query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:data error:&error]){
            NSArray* offerStatusArray = [[self jsonFromData:data error:&error] objectForKeyNotNull:@"status"];
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
    
    if ([Settings getUserId] > 0){
        [self loadUsers:[NSArray arrayWithObjects:[NSNumber numberWithInt:[Settings getUserId]], nil] compleate:nil];
        [self loadUserAdvert];
        [self loadUserOffers];
    }
}

#pragma mark - Advert

-(void)loadUserAdvert{
    [_advertLock lock];
    NSURLSessionDataTask *loadUserAdvertTask = [_session dataTaskWithRequest:[self request:ADVERTS_URL_PATH query:[NSString stringWithFormat:@"author_id=%i", [Settings getUserId]] methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [_dictionaryLock waitUntilDone];
        NSMutableArray* adverts;
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:data error:&error])
        {
            NSDictionary* result = [self jsonFromData:data error:&error];
            NSArray* array = [result objectForKeyNotNull:SERVER_RESPONCE_RESULT_PARAM];
            adverts = [NSMutableArray arrayWithCapacity:array.count];
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (!error){
                    for (NSDictionary* advertDic in array) {
                        int advertId = [[advertDic objectForKeyNotNull:ADVERT_ID_PARAM] intValue];
                        Advert* advert = [Advert getEntityWithId:advertId];
                        if (!advert){
                            advert = [Advert storedEntity];
                        }
                        [advert updateWithDic:advertDic];
                        [adverts addObject:advert];
                    }
                }
            });
        }
        [_advertLock unlock];
    }];
    [loadUserAdvertTask resume];
}

-(void)loadAdvertWithSortData:(SortData*)sortData page:(int)page compleate:(void(^)(NSArray* adverbs, NSDictionary* additionalData, NSError* error))compleate{
    [_loadAdvertCancelTask cancel];
    _loadAdvertCancelTask = [_session dataTaskWithRequest:[self request:ADVERTS_URL_PATH query:[NSString stringWithFormat:@"o=%@&page=%i", sortData.value, page] methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
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
        else if (![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:data error:&error])
        {
            NSDictionary* result = [self jsonFromData:data error:&error];
            additionalDic = [NSMutableDictionary dictionaryWithDictionary:result];
            [additionalDic removeObjectForKey:SERVER_RESPONCE_RESULT_PARAM];
            NSArray* array = [result objectForKeyNotNull:SERVER_RESPONCE_RESULT_PARAM];
            adverts = [NSMutableArray arrayWithCapacity:array.count];
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (!error){
                    for (NSDictionary* advertDic in array) {
                        int advertId = [[advertDic objectForKeyNotNull:ADVERT_ID_PARAM] intValue];
                        Advert* advert = [Advert getEntityWithId:advertId];
                        if (!advert){
                            advert = [Advert tempEntity];
                        }
                        [advert updateWithDic:advertDic];
                        [adverts addObject:advert];
                    }
                }
            });
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
    
    NSURLSessionDataTask * dataTask = [_session dataTaskWithRequest:[self request:ADVERTS_URL_PATH query:params methodType:HTTP_METHOD_POST contentType:JSON_CONTENT_TYPE] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:data error:&error])
        {
            NSDictionary* advertDic = [self jsonFromData:data error:&error];
            if (!error){
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [advert updateWithDic:advertDic];
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
    NSURLSessionDataTask* loadOffersTask = [_session dataTaskWithRequest:[self request:OFFERS_URL_PATH query:[NSString stringWithFormat:@"user=%i", [Settings getUserId]] methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [_advertLock waitUntilDone];
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:data error:&error]){
            
            NSDictionary* result = [self jsonFromData:data error:&error];
            NSMutableArray* offers = [result objectForKeyNotNull:SERVER_RESPONCE_RESULT_PARAM];
            if (offers){
            
            NSMutableArray* unknownUserIds = [NSMutableArray array];
            
            NSArray* usersArray = [User getAll];
            for (NSDictionary* offer in offers) {
                int userId = [[offer objectForKey:OFFER_USER_PARAM] intValue];
                if ([usersArray indexOfObjectPassingTest:^BOOL(User*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    return obj.ident == userId;
                }] == NSNotFound){
                    [unknownUserIds addObject:[NSNumber numberWithInteger:userId]];
                }
            }
//TODO: load unknown users
//            if (unknownUserIds.count > 0){
//                
//            }
            
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

#pragma mark - User
-(void)signIn:(NSString*)username password:(NSString*)password compleate:(void(^)(NSError* error))compleate{
    NSString *params = [NSString stringWithFormat:
                        @"{"
                        @"\"username\""           @":\"%@\","
                        @"\"password\""           @":\"%@\"}",
                        username,
                        password
                        ];

    NSURLSessionDataTask * dataTask = [_session dataTaskWithRequest:[self request:SIGN_IN_URL_PATH query:params methodType:HTTP_METHOD_POST contentType:JSON_CONTENT_TYPE] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:data error:&error])
        {
            NSDictionary* responceDic = [self jsonFromData:data error:&error];
            if (!error){
                NSDictionary* userDic = [responceDic objectForKeyNotNull:@"user"];
                int userId = [[userDic objectForKeyNotNull:USER_ID_PARAM] intValue];
                NSString* token = [responceDic objectForKey:USER_TOKEN_PARAM];
                if (userId >= 0 && token.length > 0){
                    [Settings setToken:token];
                    [Settings setUserId:userId];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        User* user = [User getEntityWithId:userId];
                        if (!user){
                            user = [User storedEntity];
                        }
                        [user updateWithDic:userDic];
                        [self loadUserAdvert];
                        [self loadUserOffers];
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
    
    NSString* method = USER_URL_PATH;
    if (idents.count == 1){
        method = [NSString stringWithFormat:@"%@%@/",USER_URL_PATH, idents.firstObject];
    }
    
    NSURLSessionDataTask* loadUserTask = [_session dataTaskWithRequest:[self request:method query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSMutableArray* users = [NSMutableArray array];
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:data error:&error]){
            NSDictionary* result = [self jsonFromData:data error:&error];
            if (!error){
                NSMutableArray* usersArray = [result objectForKey:SERVER_RESPONCE_RESULT_PARAM];
                if (usersArray){
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
    }];
    
    [loadUserTask resume];
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
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", TAKESTOK_URL, method];
    
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
    if ([Settings getToken].length > 0){
        token = [NSString stringWithFormat:@"JWT %@",[Settings getToken]];
    }
    [request setValue:token forHTTPHeaderField:@"Authorization"];
    
    if (contentType.length > 0){
        [request setValue:contentType forHTTPHeaderField:@"content-type"];
    }
    
    request.URL = [NSURL URLWithString:urlString];
    request.timeoutInterval = 180;
    return request;
}

-(BOOL)isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:(NSData*)data error:(NSError**)error{
    if (!response || ([response statusCode] < 200 || [response statusCode] >= 300))
    {
        id errorDescriptionJson = [self jsonFromData:data error:nil];
        NSString* errorDescription = [errorDescriptionJson description];
        NSLog(@"url - %@ error - %li data - %@", response.URL, (long)response.statusCode, errorDescription);
        
        if ([errorDescriptionJson isKindOfClass:[NSDictionary class]] && [errorDescriptionJson objectForKeyNotNull:@"detail"]){
            errorDescription = [errorDescriptionJson objectForKeyNotNull:@"detail"];
        }
        *error = [NSError errorWithDomain:@"1" code:response.statusCode userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSHTTPURLResponse localizedStringForStatusCode:response.statusCode], NSLocalizedDescriptionKey, errorDescription, NSLocalizedFailureReasonErrorKey, nil]];
        return YES;
    }
    return NO;
}

-(nullable id)jsonFromData:(NSData*)data error:(NSError**)error{
    if (data.length > 0)
    {
        NSString* dataStr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()"]];
        return [NSJSONSerialization JSONObjectWithData:[dataStr dataUsingEncoding:NSUTF8StringEncoding] options:7 error:error];
    }
    return nil;
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
