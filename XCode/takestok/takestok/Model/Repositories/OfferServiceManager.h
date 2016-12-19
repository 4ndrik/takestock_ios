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
@class TSShippingInfo;

@interface OfferServiceManager : NSObject{
    NSMutableDictionary* _offerStatuses;
}

-(TSOfferStatus*)getOfferStatus:(NSNumber*)ident;

+(instancetype)sharedManager;
-(void)fetchRequiredData;
-(void)loadOffersForAdvertId:(NSNumber*)advertId page:(int)page compleate:(resultBlock)compleate;
-(void)loadMyOffersWithPage:(int)page compleate:(void (^)(NSArray* result, NSDictionary* adverts, NSDictionary* additionalData, NSError* error))compleate;
-(void)loadOffer:(NSNumber*)offerId compleate:(void (^)(TSOffer* offer, NSError* error))compleate;
-(void)createOffer:(TSOffer*)offer compleate:(errorBlock)compleate;
-(void)acceptOffer:(TSOffer*)offer compleate:(errorBlock)compleate;
-(void)payByBacsOffer:(TSOffer*)offer compleate:(errorBlock)compleate;
-(void)rejectOffer:(TSOffer*)offer withComment:(NSString*)comment compleate:(errorBlock)compleate;
-(void)createCounterOffer:(TSOffer*)offer withCount:(int)count price:(float)price withComment:(NSString*)comment byByer:(BOOL)isBuyer compleate:(errorBlock)compleate;
-(void)makePayment:(TSOffer*)offer token:(STPToken*)token compleate:(errorBlock)compleate;
-(void)setShippingInfo:(TSShippingInfo*)shipping withOffer:(TSOffer*)offer compleate:(errorBlock)compleate;
-(void)setTransportInfo:(BOOL)meArrangedTransport withOffer:(TSOffer*)offer compleate:(errorBlock)compleate;
-(void)setDeliveryInfo:(TSShippingInfo*)shipping withOffer:(TSOffer*)offer compleate:(errorBlock)compleate;
-(void)confirmOffer:(TSOffer*)offer compleate:(errorBlock)compleate;
-(void)diputeOffer:(TSOffer*)offer compleate:(errorBlock)compleate;

@end
