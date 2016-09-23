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

@interface OfferServiceManager : NSObject{
    NSMutableDictionary* _offerStatuses;
}

-(TSOfferStatus*)getOfferStatus:(NSNumber*)ident;

+(instancetype)sharedManager;
-(void)fetchRequiredData;
-(void)loadOffersForAdvert:(TSAdvert*)advert page:(int)page compleate:(resultBlock)compleate;
-(void)createOffer:(TSOffer*)offer compleate:(errorBlock)compleate;
-(void)acceptOffer:(TSOffer*)offer compleate:(errorBlock)compleate;
-(void)rejectOffer:(TSOffer*)offer withComment:(NSString*)comment compleate:(errorBlock)compleate;

@end
