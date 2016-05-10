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

#define USER_URL_PATH               @"users/%i"
#define ADVERTS_URL_PATH            @"adverts"
#define CONDITIONS_URL_PATH         @"conditions"
#define SHIPPING_URL_PATH           @"shipping"
#define CATEGORIES_URL_PATH         @"category"
#define CERTIFICATIONS_URL_PATH     @"certifications"
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

#pragma mark - Advert
-(void)loadAdvert:(void(^)(NSArray* adverbs, NSError* error))compleate{
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
            NSArray* array = [[self jsonFromData:data error:&error] objectForKeyNotNull:@"results"];
            NSMutableArray* adverts = [NSMutableArray arrayWithCapacity:array.count];
            if (!error){
                
                for (NSDictionary* advertDic in array) {
                    Advert* advert = [Advert tempEntity];
                    [advert updateWithDic:advertDic];
                    [adverts addObject:advert];
                }
            }
            compleate(adverts, error);
        }
    }];
    [_loadAdvertCancelTask resume];
}

-(void)createAdvert:(Advert*)advert{
    
//    NSURL * url = [NSURL URLWithString:@"http://hayageek.com/examples/jquery/ajax-post/ajax-post.php"];
//    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
//    NSString * params =@"name=Ravi&loc=India&age=31&submit=true";
//    [urlRequest setHTTPMethod:@"POST"];
//    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSDictionary* advertData = [advert getDictionary];
    NSError* error;
    NSString* params = [self jsonStringFromDicOrArray:advertData error:&error];
    
    NSURLRequest* request = [self request:ADVERTS_URL_PATH query:params methodType:HTTP_METHOD_POST contentType:JSON_CONTENT_TYPE];
    
    NSURLSessionDataTask * dataTask = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error)
        {
            NSLog(@"dasdsa");
        }
        else if ([self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:data error:&error])
        {
            NSLog(@"dadas");
        }
        else
        {
            NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"dadas");
        }

    }];
    [dataTask resume];
    
}

-(void)loadUser:(int)ident compleate:(void(^)(User* user, NSError* error))compleate{
    NSURLSessionDataTask* loadUserTask = [_session dataTaskWithRequest:[self request:[NSString stringWithFormat:USER_URL_PATH, ident] query:nil methodType:HTTP_METHOD_GET contentType:nil] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        User* user;
        if (!error && ![self isErrorInCodeResponse:(NSHTTPURLResponse*)response withData:data error:&error]){
            NSDictionary* userDic = [self jsonFromData:data error:&error];
            if (userDic){
                user = [User tempEntity];
                [user updateWithDic:userDic];
            }
        }
        compleate(user, error);
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

-(nullable NSString*)jsonStringFromDicOrArray:(id)dictionaryOrArrayToOutput error:(NSError**)error{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryOrArrayToOutput
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:error];
    
    if (! jsonData) {
        return nil;
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end
