//
//  OfferServiceManager.h
//  takestok
//
//  Created by Artem on 9/21/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TSAdvert;
@class TSOfferStatus;
@class TSOffer;
@class STPToken;

@interface OfferServiceManager : NSObject{
    NSMutableDictionary* _offerStatuses;
}

-(TSOfferStatus*)getOfferStatus:(NSNumber*)ident;

+(instancetype)sharedManager;
-(void)fetchRequiredData;
-(void)loadOffersForAdvert:(TSAdvert*)advert page:(int)page compleate:(resultBlock)compleate;
-(void)loadMyOffersWithPage:(int)page compleate:(void (^)(NSArray* result, NSDictionary* adverts, NSDictionary* additionalData, NSError* error))compleate;
-(void)createOffer:(TSOffer*)offer compleate:(errorBlock)compleate;
-(void)acceptOffer:(TSOffer*)offer compleate:(errorBlock)compleate;
-(void)rejectOffer:(TSOffer*)offer withComment:(NSString*)comment compleate:(errorBlock)compleate;
-(void)makePayment:(TSOffer*)offer token:(STPToken*)token compleate:(errorBlock)compleate;

@end
