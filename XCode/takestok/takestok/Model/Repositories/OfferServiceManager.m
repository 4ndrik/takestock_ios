//
//  OfferServiceManager.m
//  takestok
//
//  Created by Artem on 9/21/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "OfferServiceManager.h"
#import "ServerConnectionHelper.h"
#import "TSAdvert.h"
#import "TSOffer.h"
#import "AppSettings.h"
#import "TSOfferStatus.h"

@implementation OfferServiceManager

#define offerStatusesStorgeFile [[AppSettings getStorageFolder] stringByAppendingPathComponent:@"offerStatuses.data"]

static OfferServiceManager *_manager = nil;

+(instancetype)sharedManager
{
    @synchronized([OfferServiceManager class])
    {
        return _manager?_manager:[[self alloc] init];
    }
    return nil;
}

+(id)alloc {
    @synchronized([OfferServiceManager class])
    {
        NSAssert(_manager == nil, @"Attempted to allocate a second instance of a singleton.");
        _manager = [super alloc];
        return _manager;
    }
    return nil;
}

-(id)init{
    self = [super init];
    _offerStatuses = [NSKeyedUnarchiver unarchiveObjectWithFile:offerStatusesStorgeFile];
    if (!_offerStatuses){
        _offerStatuses = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(TSOfferStatus*)getOfferStatus:(NSNumber*)ident{
    return [_offerStatuses objectForKeyNotNull:ident];
}

-(void)fetchRequiredData{
    [self fetchOfferStatuses];
}

-(void)fetchOfferStatuses{
    if ([[ServerConnectionHelper sharedInstance] isInternetConnection]){
        [[ServerConnectionHelper sharedInstance] loadOfferStatuses:^(id result, NSError *error) {
            if (!error){
                for (NSDictionary* jsOS in result) {
                    NSNumber* ident = [TSOfferStatus identFromDic:jsOS];
                    TSOfferStatus* oStatus = [_offerStatuses objectForKey:ident];
                    if (!oStatus){
                        oStatus = [[TSOfferStatus alloc] init];
                        @synchronized (_offerStatuses) {
                            [_offerStatuses setObject:oStatus forKey:ident];
                        }
                    }
                    [oStatus updateWithDic:jsOS];
                }
                [NSKeyedArchiver archiveRootObject:_offerStatuses toFile:offerStatusesStorgeFile];
            }
        }];
    }
}

-(void)loadOffersForAdvert:(TSAdvert*)advert page:(int)page compleate:(resultBlock)compleate{
    [[ServerConnectionHelper sharedInstance] loadOffersWithAdvert:advert.ident page:page compleate:^(id result, NSError *error) {
        NSMutableArray* offers;
        NSMutableDictionary* additionalDic;
        if (!error){
            additionalDic = [NSMutableDictionary dictionaryWithDictionary:result];
            [additionalDic removeObjectForKey:@"results"];
            NSArray* offersResult = [result objectForKeyNotNull:@"results"];
            offers = [NSMutableArray arrayWithCapacity:offersResult.count];
            
            for (NSDictionary* offerDic in offersResult) {
                TSOffer* offer = [TSOffer objectWithDictionary:offerDic];
                if (offer){
                    [offers addObject:offer];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            compleate(offers, additionalDic, error);
        });
    }];
}

-(void)createOffer:(TSOffer*)offer compleate:(errorBlock)compleate{
    [[ServerConnectionHelper sharedInstance] createOffer:[offer dictionaryRepresentation] compleate:^(id result, NSError *error) {
        if (!error)
            [offer updateWithDic:result];
        dispatch_async(dispatch_get_main_queue(), ^{
            compleate(error);
        });
    }];
}

-(void)acceptOffer:(TSOffer*)offer compleate:(errorBlock)compleate{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setValue:offer.ident forKey:@"offer"];
    [dic setValue:[NSNumber numberWithInteger:tsAccept] forKey:@"status"];
    [[ServerConnectionHelper sharedInstance] updateOffer:dic compleate:^(id result, NSError *error) {
        if (!error)
            [offer updateWithDic:result];
        dispatch_async(dispatch_get_main_queue(), ^{
            compleate(error);
        });
    }];
}

-(void)rejectOffer:(TSOffer*)offer withComment:(NSString*)comment compleate:(errorBlock)compleate{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setValue:offer.ident forKey:@"offer"];
    [dic setValue:[NSNumber numberWithInteger:tsDecline] forKey:@"status"];
    [dic setValue:comment forKey:@"comment"];
    
    [[ServerConnectionHelper sharedInstance] updateOffer:dic compleate:^(id result, NSError *error) {
        if (!error)
            [offer updateWithDic:result];
        dispatch_async(dispatch_get_main_queue(), ^{
            compleate(error);
        });
    }];
}
@end
