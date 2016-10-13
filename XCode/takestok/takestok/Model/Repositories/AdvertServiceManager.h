//
//  AdvertServiceManager.h
//  takestok
//
//  Created by Artem on 9/9/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TSBaseDictionaryEntity;
@class TSAdvertState;
@class TSAdvertSizeType;
@class TSAdvertCertification;
@class TSAdvertCategory;
@class TSAdvertShipping;
@class TSAdvertCondition;
@class TSAdvertPackagingType;
@class TSAdvert;
@class SortData;

typedef void (^advertResultBlock)(NSDictionary* advertDic, NSError* error);

@interface AdvertServiceManager : NSObject{
    NSMutableDictionary* _states;
    NSMutableDictionary* _sizeTypes;
    NSMutableDictionary* _certifications;
    NSMutableDictionary* _shipping;
    NSMutableDictionary* _conditions;
    NSMutableDictionary* _categories;
    NSMutableDictionary* _packageTypes;
}

+(instancetype)sharedManager;
-(void)fetchRequiredData;

-(NSArray*)getStates;
-(TSAdvertState*)getStateWithId:(NSNumber*)ident;
-(NSArray*)getSizeType;
-(TSAdvertSizeType*)getSizeTypeWithId:(NSNumber*)ident;
-(NSArray*)getCertifications;
-(TSAdvertCertification*)getCertificationWithId:(NSNumber*)ident;
-(NSArray*)getShippings;
-(TSAdvertShipping*)getShippingWithId:(NSNumber*)ident;
-(NSArray*)getConditions;
-(TSAdvertCondition*)getConditionWithId:(NSNumber*)ident;
-(NSArray*)getCategories;
-(TSAdvertCategory*)getCategoyWithId:(NSNumber*)ident;
-(NSArray*)getPackageTypes;
-(TSAdvertPackagingType*)getPackageTypeWithId:(NSNumber*)ident;

-(void)loadAdverts:(SortData*)sortData search:(NSString*)search category:(TSBaseDictionaryEntity*)category page:(int)page compleate:(resultBlock)compleate;
-(void)loadWatchListWithPage:(int)page compleate:(resultBlock)compleate;
-(void)loadDraftsWithPage:(int)page compleate:(resultBlock)compleate;
-(void)loadExpiredWithPage:(int)page compleate:(resultBlock)compleate;
-(void)loadHoldOndWithPage:(int)page compleate:(resultBlock)compleate;
-(void)createAdvert:(TSAdvert*)advert compleate:(errorBlock)compleate;
-(void)loadMyAdvertsWithPage:(int)page compleate:(resultBlock)compleate;
-(void)addToWatchList:(TSAdvert*)advert compleate:(errorBlock)compleate;
-(void)sendViwAdvert:(TSAdvert*)advert;
-(void)sendReadNotificationsWithAdvert:(TSAdvert*)advert;
-(void)loadSimilarAdverts:(TSAdvert*)advert withPage:(int)page compleate:(resultBlock)compleate;
-(void)loadUserAdverts:(TSAdvert*)advert withPage:(int)page compleate:(resultBlock)compleate;

@end
