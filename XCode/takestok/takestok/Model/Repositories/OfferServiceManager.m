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
#import "TSAdvert.h"
#import "TSShippingInfo.h"
#import <Stripe/Stripe.h>

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

-(void)loadMyOffersWithPage:(int)page compleate:(void (^)(NSArray* result, NSDictionary* adverts, NSDictionary* additionalData, NSError* error))compleate{
    [[ServerConnectionHelper sharedInstance] loadMyOffersWithPage:page compleate:^(id result, NSError *error) {
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
            
            NSMutableArray* advertIds = [NSMutableArray array];
            for (TSOffer* offer in offers){
                [advertIds addObject:offer.advertId];
            }
            
            [[ServerConnectionHelper sharedInstance] loadAdvertsWithIdents:advertIds compleate:^(NSArray* result, NSError *error) {
                NSMutableDictionary* adverts;
                if (!error){
                    adverts = [NSMutableDictionary dictionary];
                    for (NSDictionary* advertJs in result){
                        NSNumber* ident = [TSAdvert identFromDic:advertJs];
                        TSAdvert* advert = [TSAdvert objectWithDictionary:advertJs];
                        [adverts setObject:advert forKey:ident];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    compleate(offers, adverts, additionalDic, error);
                });
            }];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                compleate(nil, nil, nil, error);
            });
        }
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
        if (!error){
            [[ServerConnectionHelper sharedInstance] loadOffer:offer.ident compleate:^(id result, NSError *error) {
                if (!error){
                    [offer updateWithDic:result];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    compleate(error);
                });
            }];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                compleate(error);
            });
        }
    }];
}

-(void)rejectOffer:(TSOffer*)offer withComment:(NSString*)comment compleate:(errorBlock)compleate{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setValue:offer.ident forKey:@"offer"];
    [dic setValue:[NSNumber numberWithInteger:tsDecline] forKey:@"status"];
    [dic setValue:comment forKey:@"comment"];
    
    [[ServerConnectionHelper sharedInstance] updateOffer:dic compleate:^(id result, NSError *error) {
        if (!error){
            [[ServerConnectionHelper sharedInstance] loadOffer:offer.ident compleate:^(id result, NSError *error) {
                if (!error){
                    [offer updateWithDic:result];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    compleate(error);
                });
            }];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                compleate(error);
            });
        }
    }];
}

-(void)createCounterOffer:(TSOffer*)offer withCount:(int)count price:(float)price withComment:(NSString*)comment byByer:(BOOL)isBuyer compleate:(errorBlock)compleate{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setValue:offer.ident forKey:@"offer"];
    [dic setValue:[NSNumber numberWithInteger:isBuyer ? tsCounteredByByer : tsCountered] forKey:@"status"];
    [dic setValue:comment forKey:@"comment"];
    [dic setValue:[NSNumber numberWithFloat:price] forKey:@"price"];
    [dic setValue:[NSNumber numberWithInt:count] forKey:@"quantity"];
    
    [[ServerConnectionHelper sharedInstance] updateOffer:dic compleate:^(id result, NSError *error) {
        if (!error){
            [[ServerConnectionHelper sharedInstance] loadOffer:offer.ident compleate:^(id result, NSError *error) {
                if (!error){
                    [offer updateWithDic:result];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    compleate(error);
                });
            }];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                compleate(error);
            });
        }
    }];
}

-(void)makePayment:(TSOffer*)offer token:(STPToken*)token compleate:(errorBlock)compleate{
    [[ServerConnectionHelper sharedInstance] payOffer:offer.ident withToken:token.tokenId completion:^(id result, NSError *error) {
        if (!error){
            if ([[result objectForKeyNotNull:@"status"] isEqualToString:@"success"]){
                [[ServerConnectionHelper sharedInstance] loadOffer:offer.ident compleate:^(id result, NSError *error) {
                    if (!error){
                        [offer updateWithDic:result];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        compleate(error);
                    });
                }];
            }else if ([[result objectForKeyNotNull:@"status"] isEqualToString:@"error"]){
                if ([result objectForKeyNotNull:@"data"]){
                    error = [NSError errorWithDomain:@"2" code:2 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[result objectForKeyNotNull:@"data"], NSLocalizedFailureReasonErrorKey, nil]];
                }else{
                    error = [NSError errorWithDomain:@"2" code:2 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Something went wrong. Please try again.", NSLocalizedFailureReasonErrorKey, nil]];
                }
            }else{
                error = [NSError errorWithDomain:@"2" code:2 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Something went wrong. Please try again.", NSLocalizedFailureReasonErrorKey, nil]];
            }
        }
        if (error){
            dispatch_async(dispatch_get_main_queue(), ^{
                compleate(error);
            });
        }
    }];
}

-(void)payByBacsOffer:(TSOffer*)offer compleate:(errorBlock)compleate{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setValue:offer.ident forKey:@"offer"];
    [dic setValue:[NSNumber numberWithInteger:tsPayByBacs] forKey:@"status"];
    [[ServerConnectionHelper sharedInstance] updateOffer:dic compleate:^(id result, NSError *error) {
        if (!error){
            [[ServerConnectionHelper sharedInstance] loadOffer:offer.ident compleate:^(id result, NSError *error) {
                if (!error){
                    [offer updateWithDic:result];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    compleate(error);
                });
            }];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                compleate(error);
            });
        }
    }];

}

-(void)setShippingInfo:(TSOffer*)offer street:(NSString*)street house:(NSString*)house city:(NSString*)city postcode:(NSString*)postcode phone:(NSString*)phone compleate:(errorBlock)compleate{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[NSNumber numberWithInteger:tsAddressReceived] forKey:@"status"];
    [dic setValue:offer.ident forKey:@"offer"];
    [dic setValue:street forKey:@"street"];
    [dic setValue:house forKey:@"house"];
    [dic setValue:city forKey:@"city"];
    [dic setValue:postcode forKey:@"postcode"];
    [dic setValue:phone forKey:@"phone"];
    
    [[ServerConnectionHelper sharedInstance] updateOffer:dic compleate:^(id result, NSError *error) {
        if (!error){
            [[ServerConnectionHelper sharedInstance] loadOffer:offer.ident compleate:^(id result, NSError *error) {
                if (!error){
                    [offer updateWithDic:result];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    compleate(error);
                });
            }];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                compleate(error);
            });
        }
    }];
}

-(void)setShippingInfo:(TSShippingInfo*)shipping withOffer:(TSOffer*)offer compleate:(errorBlock)compleate{
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:[shipping dictionaryForShipping]];
    [dic setValue:offer.ident forKey:@"offer"];
    [dic setValue:[NSNumber numberWithInteger:tsAddressReceived] forKey:@"status"];
    [[ServerConnectionHelper sharedInstance] updateOffer:dic compleate:^(id result, NSError *error) {
        if (!error){
            [[ServerConnectionHelper sharedInstance] loadOffer:offer.ident compleate:^(id result, NSError *error) {
                if (!error){
                    [offer updateWithDic:result];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    compleate(error);
                });
            }];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                compleate(error);
            });
        }
    }];
}

-(void)setTransportInfo:(BOOL)meArrangedTransport withOffer:(TSOffer*)offer compleate:(errorBlock)compleate{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setValue:offer.ident forKey:@"offer"];
    [dic setValue:[NSNumber numberWithInteger:tsConfirmStock] forKey:@"status"];
    [[ServerConnectionHelper sharedInstance] updateOffer:dic compleate:^(id result, NSError *error) {
        if (!error){
            [[ServerConnectionHelper sharedInstance] loadOffer:offer.ident compleate:^(id result, NSError *error) {
                if (!error){
                    [offer updateWithDic:result];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    compleate(error);
                });
            }];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                compleate(error);
            });
        }
    }];
}

-(void)setDeliveryInfo:(TSShippingInfo*)shipping withOffer:(TSOffer*)offer compleate:(errorBlock)compleate{
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:[shipping dictionaryForDispatch]];
    [dic setValue:[NSNumber numberWithInteger:tsStockInTransit] forKey:@"status"];
    [[ServerConnectionHelper sharedInstance] updateOffer:dic compleate:^(id result, NSError *error) {
        if (!error){
            [[ServerConnectionHelper sharedInstance] loadOffer:offer.ident compleate:^(id result, NSError *error) {
                if (!error){
                    [offer updateWithDic:result];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    compleate(error);
                });
            }];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                compleate(error);
            });
        }
    }];
}

-(void)confirmOffer:(TSOffer*)offer compleate:(errorBlock)compleate{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setValue:offer.ident forKey:@"offer"];
    [dic setValue:[NSNumber numberWithInteger:tsGoodsReceived] forKey:@"status"];
    [[ServerConnectionHelper sharedInstance] updateOffer:dic compleate:^(id result, NSError *error) {
        if (!error){
            [[ServerConnectionHelper sharedInstance] loadOffer:offer.ident compleate:^(id result, NSError *error) {
                if (!error){
                    [offer updateWithDic:result];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    compleate(error);
                });
            }];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                compleate(error);
            });
        }
    }];
}

-(void)diputeOffer:(TSOffer*)offer compleate:(errorBlock)compleate{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setValue:offer.ident forKey:@"offer"];
    [dic setValue:[NSNumber numberWithInteger:tsInDispute] forKey:@"status"];
    [[ServerConnectionHelper sharedInstance] updateOffer:dic compleate:^(id result, NSError *error) {
        if (!error){
            [[ServerConnectionHelper sharedInstance] loadOffer:offer.ident compleate:^(id result, NSError *error) {
                if (!error){
                    [offer updateWithDic:result];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    compleate(error);
                });
            }];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                compleate(error);
            });
        }
    }];
}

@end
