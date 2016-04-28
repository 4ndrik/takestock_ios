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

typedef enum
{
    HTTP_METHOD_GET,
    HTTP_METHOD_POST,
    HTTP_METHOD_PUT,
    HTTP_METHOD_DELETE
} HTTP_METHOD;

#define TAKESTOK_URL                @"http://takestock.shalakh.in/api/v1/"

#define JSON_CONTENT_TYPE           @"application/json"
#define ADVERTS_URL_PATH            @"adverts"

#define CONDITIONS_URL_PATH         @"conditions"
#define SHIPPING_URL_PATH           @"shipping"
#define CATEGORIES_URL_PATH         @"category"
#define CERTIFICATIONS_URL_PATH      @"certifications"
#define SIZE_TYPES_URL_PATH         @"size_types"


#define SIGNATURE @"JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6IlVzZXJBcnRlbSIsImV4cCI6MTQ2MzgyMTU4NSwiZW1haWwiOiJzZXJiaW5hcnRlbUBnbWFpbC5jb20iLCJ1c2VyX2lkIjoxMH0.4gTS9TYXasqhuAqzQ-Omg03finB10ehFtDrrJ1zT_Ew"

@implementation ServerConnectionHelper

-(id)init
{
    self = [super init];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    NSString *remoteHostName = @"www.apple.com";
    _reachability = [Reachability reachabilityWithHostName:remoteHostName];
    [_reachability startNotifier];
    
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfig setHTTPAdditionalHeaders:[NSDictionary dictionaryWithObjectsAndKeys:SIGNATURE, @"Authorization", nil]];
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

-(void)loadDictionaries{
    
    NSURLSessionDataTask* loadConditionsTask = [_session dataTaskWithRequest:[self request:CONDITIONS_URL_PATH query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:data error:&error]){
            NSArray* conditions = [[self jsonFromData:data error:&error] objectForKeyNotNull:@"conditions"];
            if (conditions)
                [Condition syncWithJsonArray:conditions];
        }
    }];
    
    NSURLSessionDataTask* loadShippingTask = [_session dataTaskWithRequest:[self request:SHIPPING_URL_PATH query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:data error:&error]){
            NSArray* shippings = [[self jsonFromData:data error:&error] objectForKeyNotNull:@"shipping"];
                if (shippings)
                    [Shipping syncWithJsonArray:shippings];
        }
    }];
    
    NSURLSessionDataTask* loadSizeTask = [_session dataTaskWithRequest:[self request:SIZE_TYPES_URL_PATH query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:data error:&error]){
            NSArray* sizeTypes = [[self jsonFromData:data error:&error]  objectForKeyNotNull:@"types"];
            if (sizeTypes)
                [SizeType syncWithJsonArray:sizeTypes];
        }
    }];
    
    NSURLSessionDataTask* loadCertificationTask = [_session dataTaskWithRequest:[self request:CERTIFICATIONS_URL_PATH query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:data error:&error]){
                NSArray* certifications = [self jsonFromData:data error:&error];
                if (certifications)
                    [Certification syncWithJsonArray:certifications];
            }
    }];
    
    NSURLSessionDataTask* loadCategoryTask = [_session dataTaskWithRequest:[self request:CATEGORIES_URL_PATH query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:data error:&error]){
            NSArray* categories = [self jsonFromData:data error:&error];
            if (categories)
                [Category syncWithJsonArray:categories];
        }
    }];
    
    [loadConditionsTask resume];
    [loadShippingTask resume];
    [loadCertificationTask resume];
    [loadSizeTask resume];
    [loadCategoryTask resume];
}

#pragma mark - Adverb
-(void)loadAdverb:(void(^)(NSArray* adverbs, NSError* error))compleate{
    [_loadAdvertCancelTask cancel];
    _loadAdvertCancelTask = [_session dataTaskWithRequest:[self request:ADVERTS_URL_PATH query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        _loadAdvertCancelTask = nil;
        if (error)
        {
            //Ignore cancelled
            if (![[error localizedDescription] isEqualToString:@"cancelled"])
                compleate(nil, error);
        }
        else if ([self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:data error:&error])
        {
            compleate(nil, error);
        }
        else
        {
            NSArray* array = [self jsonFromData:data error:&error];
            NSMutableArray* adverts = [NSMutableArray arrayWithCapacity:array.count];
            if (!error){
                
                for (NSDictionary* advertDic in array) {
                    Advert* advert = [Advert tempEntity];
                    [advert updateWithJSon:advertDic];
                    [adverts addObject:advert];
                }
            }
            compleate(adverts, error);
        }
    }];
    [_loadAdvertCancelTask resume];
}

#pragma mark - Helpers

-(NSURLRequest*)request:(NSString*)method query:(NSString * _Nullable)query methodType:(HTTP_METHOD)methodType contentType:(NSString* _Nullable)contentType{
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
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
    
    if (contentType.length > 0){
        [request setValue:contentType forHTTPHeaderField:@"content-type"];
    }
    
    request.URL = [NSURL URLWithString:urlString];
    request.timeoutInterval = 30;
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
        *error = [NSError errorWithDomain:@"1" code:response.statusCode userInfo:[NSDictionary dictionaryWithObjectsAndKeys:errorDescription, NSLocalizedDescriptionKey, nil]];
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

@end
