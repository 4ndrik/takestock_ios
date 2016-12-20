//
//  AdvertServiceManager.m
//  takestok
//
//  Created by Artem on 9/9/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "AdvertServiceManager.h"
#import "AppSettings.h"
#import "ServerConnectionHelper.h"
#import "TSAdvertCategory.h"
#import "TSAdvertCondition.h"
#import "TSAdvertState.h"
#import "TSAdvertSizeType.h"
#import "TSAdvertShipping.h"
#import "TSAdvertPackagingType.h"
#import "TSAdvertCertification.h"
#import "SortData.h"
#import "TSAdvertSubCategory.h"
#import "TSAdvert.h"
#import "UserServiceManager.h"
#import "TSAdvert+Mutable.h"

@implementation AdvertServiceManager

#define categoriesStorgeFile [[AppSettings getStorageFolder] stringByAppendingPathComponent:@"categories.data"]
#define conditionsStorgeFile [[AppSettings getStorageFolder] stringByAppendingPathComponent:@"conditions.data"]
#define certificationsStorgeFile [[AppSettings getStorageFolder] stringByAppendingPathComponent:@"certifications.data"]
#define stateStorgeFile [[AppSettings getStorageFolder] stringByAppendingPathComponent:@"state.data"]
#define sizeTypeStorgeFile [[AppSettings getStorageFolder] stringByAppendingPathComponent:@"size.data"]
#define shippingStorgeFile [[AppSettings getStorageFolder] stringByAppendingPathComponent:@"shipping.data"]
#define packageStorgeFile [[AppSettings getStorageFolder] stringByAppendingPathComponent:@"package.data"]

static AdvertServiceManager *_manager = nil;

+(instancetype)sharedManager
{
    @synchronized([AdvertServiceManager class])
    {
        return _manager?_manager:[[self alloc] init];
    }
    return nil;
}

+(id)alloc {
    @synchronized([AdvertServiceManager class])
    {
        NSAssert(_manager == nil, @"Attempted to allocate a second instance of a singleton.");
        _manager = [super alloc];
        return _manager;
    }
    return nil;
}

-(id)init{
    self = [super init];
    _states = [NSKeyedUnarchiver unarchiveObjectWithFile:stateStorgeFile];
    if (!_states){
        _states = [[NSMutableDictionary alloc] init];
    }
    _sizeTypes = [NSKeyedUnarchiver unarchiveObjectWithFile:sizeTypeStorgeFile];
    if (!_sizeTypes){
        _sizeTypes = [[NSMutableDictionary alloc] init];
    }
    _certifications = [NSKeyedUnarchiver unarchiveObjectWithFile:certificationsStorgeFile];
    if (!_certifications){
        _certifications = [[NSMutableDictionary alloc] init];
    }
    _shipping = [NSKeyedUnarchiver unarchiveObjectWithFile:shippingStorgeFile];
    if (!_shipping){
        _shipping = [[NSMutableDictionary alloc] init];
    }
    _conditions = [NSKeyedUnarchiver unarchiveObjectWithFile:conditionsStorgeFile];
    if (!_conditions){
        _conditions = [[NSMutableDictionary alloc] init];
    }
    _categories = [NSKeyedUnarchiver unarchiveObjectWithFile:categoriesStorgeFile];
    if (!_categories){
        _categories = [[NSMutableDictionary alloc] init];
    }
    _packageTypes = [NSKeyedUnarchiver unarchiveObjectWithFile:packageStorgeFile];
    if (!_packageTypes){
        _packageTypes = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}


#pragma mark - Fetch Dictionaries
-(void)fetchRequiredData{
    [self fetchStripeData];
    [self fetchState];
    [self fetchSizeTypes];
    [self fetchCertification];
    [self fetchShipping];
    [self fetchConditions];
    [self fetchCategories];
    [self fetchPackageTypes];
}

-(void)fetchStripeData{
    if ([[ServerConnectionHelper sharedInstance] isInternetConnection]){
        [[ServerConnectionHelper sharedInstance] loadStripe:^(NSDictionary* result, NSError *error) {
            NSNumber* stripeRate = [result objectForKeyNotNull:@"stripe_rate"];
            if (stripeRate){
                [AppSettings setStripeFee:[stripeRate intValue]];
            }
        }];
    }
}

-(void)fetchState{
    if ([[ServerConnectionHelper sharedInstance] isInternetConnection]){
        [[ServerConnectionHelper sharedInstance] loadStates:^(id result, NSError *error) {
            if (!error){
                for (NSDictionary* jsStates in result) {
                    NSNumber* ident = [TSAdvertState identFromDic:jsStates];
                    TSAdvertState* state = [_states objectForKey:ident];
                    if (!state){
                        state = [[TSAdvertState alloc] init];
                        @synchronized (_states) {
                            [_states setObject:state forKey:ident];
                        }
                    }
                    [state updateWithDic:jsStates];
                }
                [NSKeyedArchiver archiveRootObject:_states toFile:stateStorgeFile];
            }
        }];
    }
}

-(void)fetchSizeTypes{
    if ([[ServerConnectionHelper sharedInstance] isInternetConnection]){
        [[ServerConnectionHelper sharedInstance] loadSizeTypes:^(id result, NSError *error) {
            if (!error){
                for (NSDictionary* jsSizes in result) {
                    NSNumber* ident = [TSAdvertSizeType identFromDic:jsSizes];
                    TSAdvertSizeType* sizeType = [_sizeTypes objectForKey:ident];
                    if (!sizeType){
                        sizeType = [[TSAdvertSizeType alloc] init];
                        @synchronized (_sizeTypes) {
                            [_sizeTypes setObject:sizeType forKey:ident];
                        }
                    }
                    [sizeType updateWithDic:jsSizes];
                }
                [NSKeyedArchiver archiveRootObject:_sizeTypes toFile:sizeTypeStorgeFile];
            }
        }];
    }
}

-(void)fetchCertification{
    if ([[ServerConnectionHelper sharedInstance] isInternetConnection]){
        [[ServerConnectionHelper sharedInstance] loadCertifications:^(id result, NSError *error) {
            if (!error){
                for (NSDictionary* jsCerts in result) {
                    NSNumber* ident = [TSAdvertCertification identFromDic:jsCerts];
                    TSAdvertCertification* certificate = [_certifications objectForKey:ident];
                    if (!certificate){
                        certificate = [[TSAdvertCertification alloc] init];
                        @synchronized (_certifications) {
                            [_certifications setObject:certificate forKey:ident];
                        }
                    }
                    [certificate updateWithDic:jsCerts];
                }
                [NSKeyedArchiver archiveRootObject:_certifications toFile:certificationsStorgeFile];
            }
        }];
    }
}

-(void)fetchShipping{
    if ([[ServerConnectionHelper sharedInstance] isInternetConnection]){
        [[ServerConnectionHelper sharedInstance] loadShipping:^(id result, NSError *error) {
            if (!error){
                for (NSDictionary* jsShipping in result) {
                    NSNumber* ident = [TSAdvertShipping identFromDic:jsShipping];
                    TSAdvertShipping* shipping = [_shipping objectForKey:ident];
                    if (!shipping){
                        shipping = [[TSAdvertShipping alloc] init];
                        @synchronized (_shipping) {
                            [_shipping setObject:shipping forKey:ident];
                        }
                    }
                    [shipping updateWithDic:jsShipping];
                }
                [NSKeyedArchiver archiveRootObject:_shipping toFile:shippingStorgeFile];
            }
        }];
    }
}

-(void)fetchConditions{
    if ([[ServerConnectionHelper sharedInstance] isInternetConnection]){
        [[ServerConnectionHelper sharedInstance] loadConditions:^(id result, NSError *error) {
            if (!error){
                for (NSDictionary* jsConditions in result) {
                    NSNumber* ident = [TSAdvertCondition identFromDic:jsConditions];
                    TSAdvertCondition* condition = [_conditions objectForKey:ident];
                    if (!condition){
                        condition = [[TSAdvertCondition alloc] init];
                        @synchronized (_conditions) {
                            [_conditions setObject:condition forKey:ident];
                        }
                    }
                    [condition updateWithDic:jsConditions];
                }
                [NSKeyedArchiver archiveRootObject:_conditions toFile:conditionsStorgeFile];
            }
        }];
    }
}

-(void)fetchCategories{
    if ([[ServerConnectionHelper sharedInstance] isInternetConnection]){
        [[ServerConnectionHelper sharedInstance] loadCategories:^(id result, NSError *error) {
            if (!error){
                for (NSDictionary* jsCategory in result) {
                    NSNumber* ident = [TSAdvertCategory identFromDic:jsCategory];
                    TSAdvertCategory* category = [_categories objectForKey:ident];
                    if (!category){
                        category = [[TSAdvertCategory alloc] init];
                        @synchronized (_categories) {
                            [_categories setObject:category forKey:ident];
                        }
                    }
                    [category updateWithDic:jsCategory];
                }
                [NSKeyedArchiver archiveRootObject:_categories toFile:categoriesStorgeFile];
            }
        }];
    }
}

-(void)fetchPackageTypes{
    if ([[ServerConnectionHelper sharedInstance] isInternetConnection]){
        [[ServerConnectionHelper sharedInstance] loadPackagingTypes:^(id result, NSError *error) {
            if (!error){
                for (NSDictionary* jsPackage in result) {
                    NSNumber* ident = [TSAdvertPackagingType identFromDic:jsPackage];
                    TSAdvertPackagingType* package = [_packageTypes objectForKey:ident];
                    if (!package){
                        package = [[TSAdvertPackagingType alloc] init];
                        @synchronized (_packageTypes) {
                            [_packageTypes setObject:package forKey:ident];
                        }
                    }
                    [package updateWithDic:jsPackage];
                }
                [NSKeyedArchiver archiveRootObject:_packageTypes toFile:packageStorgeFile];
            }
        }];
    }
}


#pragma mark Dictionaries getters
-(NSArray*)getStates{
    return [[_states allValues] sortedArrayUsingComparator:^NSComparisonResult(TSBaseEntity*  _Nonnull obj1, TSBaseEntity*  _Nonnull obj2) {
        return [obj1.ident compare:obj2.ident];
    }];
}
-(TSAdvertState*)getStateWithId:(NSNumber*)ident{
    return [_states objectForKey:ident];
}

-(NSArray*)getSizeType{
    return [[_sizeTypes allValues] sortedArrayUsingComparator:^NSComparisonResult(TSBaseEntity*  _Nonnull obj1, TSBaseEntity*  _Nonnull obj2) {
        return [obj1.ident compare:obj2.ident];
    }];
}
-(TSAdvertSizeType*)getSizeTypeWithId:(NSNumber*)ident{
    return [_sizeTypes objectForKey:ident];
}

-(NSArray*)getCertifications{
    return [[_certifications allValues] sortedArrayUsingComparator:^NSComparisonResult(TSBaseEntity*  _Nonnull obj1, TSBaseEntity*  _Nonnull obj2) {
        return [obj1.ident compare:obj2.ident];
    }];
}
-(TSAdvertCertification*)getCertificationWithId:(NSNumber*)ident{
    return [_certifications objectForKey:ident];
}

-(NSArray*)getShippings{
    return [[_shipping allValues] sortedArrayUsingComparator:^NSComparisonResult(TSBaseEntity*  _Nonnull obj1, TSBaseEntity*  _Nonnull obj2) {
        return [obj1.ident compare:obj2.ident];
    }];
}
-(TSAdvertShipping*)getShippingWithId:(NSNumber*)ident{
    return [_shipping objectForKey:ident];
}

-(NSArray*)getConditions{
    return [[_conditions allValues] sortedArrayUsingComparator:^NSComparisonResult(TSBaseEntity*  _Nonnull obj1, TSBaseEntity*  _Nonnull obj2) {
        return [obj1.ident compare:obj2.ident];
    }];
}
-(TSAdvertCondition*)getConditionWithId:(NSNumber*)ident{
    return [_conditions objectForKey:ident];
}


-(NSArray*)getCategories{
    return [[_categories allValues] sortedArrayUsingComparator:^NSComparisonResult(TSBaseEntity*  _Nonnull obj1, TSBaseEntity*  _Nonnull obj2) {
        return [obj1.ident compare:obj2.ident];
    }];
}

-(TSAdvertCategory*)getCategoyWithId:(NSNumber*)ident{
    return [_categories objectForKey:ident];
}

-(NSArray*)getPackageTypes{
    return[ [_packageTypes allValues] sortedArrayUsingComparator:^NSComparisonResult(TSBaseEntity*  _Nonnull obj1, TSBaseEntity*  _Nonnull obj2) {
        return [obj1.ident compare:obj2.ident];
    }];
}
-(TSAdvertPackagingType*)getPackageTypeWithId:(NSNumber*)ident{
    return [_packageTypes objectForKey:ident];
}

#pragma mark - Adverts

-(void)loadAdvertWithId:(NSNumber*)advertId compleate:(advertResultBlock)compleate{
    [[ServerConnectionHelper sharedInstance] loadAdvertsWithIdents:[NSArray arrayWithObjects:advertId, nil] compleate:^(NSArray* result, NSError *error) {
        TSAdvert* advert;
        if (!error){
            for (NSDictionary* advertJs in result){
                advert = [TSAdvert objectWithDictionary:advertJs];
                break;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            compleate(advert, error);
        });
    }];
}

-(void)loadMyAdvertsWithPage:(int)page compleate:(resultBlock)compleate{
    [[ServerConnectionHelper sharedInstance] loadAdvertsWithUser:[[UserServiceManager sharedManager] getMe].ident page:page compleate:^(id result, NSError *error) {
        NSMutableDictionary* additionalDic;
        NSMutableArray* adverts;
        if (!error)
        {
            additionalDic = [NSMutableDictionary dictionaryWithDictionary:result];
            [additionalDic removeObjectForKey:@"results"];
            NSArray* array = [result objectForKeyNotNull:@"results"];
            adverts = [NSMutableArray arrayWithCapacity:array.count];
            
            for (NSDictionary* advertDic in array) {
                TSAdvert* advert = [TSAdvert objectWithDictionary:advertDic];
                if (advert)
                    [adverts addObject:advert];
            }
            
        }else if ([[error localizedDescription] isEqualToString:@"cancelled"]){
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            compleate(adverts, additionalDic, error);
        });

    }];
}

-(void)loadAdverts:(SortData*)sortData search:(NSString*)search category:(TSBaseDictionaryEntity*)category page:(int)page compleate:(resultBlock)compleate{
    NSNumber* categoryId;
    NSNumber* subCategoryId;
    if (category){
        if ([category isKindOfClass:[TSAdvertSubCategory class]]){
            subCategoryId = ((TSAdvertSubCategory*)category).ident;
            categoryId = ((TSAdvertSubCategory*)category).parentIdent;
        }else{
            categoryId = category.ident;
        }
    }
    [[ServerConnectionHelper sharedInstance] loadAdvertsWithSort:sortData.value search:search category:categoryId subCategory:subCategoryId page:page compleate:^(id result, NSError *error) {
        NSMutableDictionary* additionalDic;
        NSMutableArray* adverts;
        if (!error)
        {
            additionalDic = [NSMutableDictionary dictionaryWithDictionary:result];
            [additionalDic removeObjectForKey:@"results"];
            NSArray* array = [result objectForKeyNotNull:@"results"];
            adverts = [NSMutableArray arrayWithCapacity:array.count];
                
            for (NSDictionary* advertDic in array) {
                TSAdvert* advert = [TSAdvert objectWithDictionary:advertDic];
                if (advert)
                    [adverts addObject:advert];
            }

        }else if ([[error localizedDescription] isEqualToString:@"cancelled"]){
            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            compleate(adverts, additionalDic, error);
        });
    }];
}

-(void)loadWatchListWithPage:(int)page compleate:(resultBlock)compleate{
    [[ServerConnectionHelper sharedInstance] loadWatchListWithPage:page compleate:^(id result, NSError *error) {
        NSMutableDictionary* additionalDic;
        NSMutableArray* adverts;
        if (!error)
        {
            additionalDic = [NSMutableDictionary dictionaryWithDictionary:result];
            [additionalDic removeObjectForKey:@"results"];
            NSArray* array = [result objectForKeyNotNull:@"results"];
            adverts = [NSMutableArray arrayWithCapacity:array.count];
            
            for (NSDictionary* advertDic in array) {
                TSAdvert* advert = [TSAdvert objectWithDictionary:advertDic];
                if (advert)
                    [adverts addObject:advert];
            }
            
        }else if ([[error localizedDescription] isEqualToString:@"cancelled"]){
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            compleate(adverts, additionalDic, error);
        });
    }];
}

-(void)loadDraftsWithPage:(int)page compleate:(resultBlock)compleate{
    [[ServerConnectionHelper sharedInstance] loadDraftsWithPage:page userId:([[UserServiceManager sharedManager] getMe].ident) compleate:^(id result, NSError *error) {
        NSMutableDictionary* additionalDic;
        NSMutableArray* adverts;
        if (!error)
        {
            additionalDic = [NSMutableDictionary dictionaryWithDictionary:result];
            [additionalDic removeObjectForKey:@"results"];
            NSArray* array = [result objectForKeyNotNull:@"results"];
            adverts = [NSMutableArray arrayWithCapacity:array.count];
            
            for (NSDictionary* advertDic in array) {
                TSAdvert* advert = [TSAdvert objectWithDictionary:advertDic];
                if (advert)
                    [adverts addObject:advert];
            }
            
        }else if ([[error localizedDescription] isEqualToString:@"cancelled"]){
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            compleate(adverts, additionalDic, error);
        });
    }];
}

-(void)loadExpiredWithPage:(int)page  compleate:(resultBlock)compleate{
    [[ServerConnectionHelper sharedInstance] loadExpiredWithPage:page userId:([[UserServiceManager sharedManager] getMe].ident) compleate:^(id result, NSError *error) {
        NSMutableDictionary* additionalDic;
        NSMutableArray* adverts;
        if (!error)
        {
            additionalDic = [NSMutableDictionary dictionaryWithDictionary:result];
            [additionalDic removeObjectForKey:@"results"];
            NSArray* array = [result objectForKeyNotNull:@"results"];
            adverts = [NSMutableArray arrayWithCapacity:array.count];
            
            for (NSDictionary* advertDic in array) {
                TSAdvert* advert = [TSAdvert objectWithDictionary:advertDic];
                if (advert)
                    [adverts addObject:advert];
            }
            
        }else if ([[error localizedDescription] isEqualToString:@"cancelled"]){
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            compleate(adverts, additionalDic, error);
        });
    }];
}

-(void)loadHoldOndWithPage:(int)page compleate:(resultBlock)compleate{
    [[ServerConnectionHelper sharedInstance] loadHoldOndWithPage:page userId:([[UserServiceManager sharedManager] getMe].ident) compleate:^(id result, NSError *error) {
        NSMutableDictionary* additionalDic;
        NSMutableArray* adverts;
        if (!error)
        {
            additionalDic = [NSMutableDictionary dictionaryWithDictionary:result];
            [additionalDic removeObjectForKey:@"results"];
            NSArray* array = [result objectForKeyNotNull:@"results"];
            adverts = [NSMutableArray arrayWithCapacity:array.count];
            
            for (NSDictionary* advertDic in array) {
                TSAdvert* advert = [TSAdvert objectWithDictionary:advertDic];
                if (advert)
                    [adverts addObject:advert];
            }
            
        }else if ([[error localizedDescription] isEqualToString:@"cancelled"]){
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            compleate(adverts, additionalDic, error);
        });
    }];
}

-(void)createAdvert:(TSAdvert*)advert compleate:(errorBlock)compleate{
    NSDictionary* advertDic = [advert dictionaryRepresentation];
    if (advert.ident){
        [[ServerConnectionHelper sharedInstance] editAdvertWithId:advert.ident withDic:advertDic compleate:^(id result, NSError *error) {
            if (!error)
                [advert updateWithDic:result];
            dispatch_async(dispatch_get_main_queue(), ^{
                compleate(error);
            });
        }];
    }else{
        [[ServerConnectionHelper sharedInstance] createAdvert:advertDic compleate:^(id result, NSError *error) {
            if (!error)
                [advert updateWithDic:result];
            dispatch_async(dispatch_get_main_queue(), ^{
                compleate(error);
            });
        }];
    }
}

-(void)addToWatchList:(TSAdvert*)advert compleate:(errorBlock)compleate{
    [[ServerConnectionHelper sharedInstance] addToWatchList:advert.ident compleate:^(id result, NSError *error) {
        if(!error){
            BOOL isWatchList = [[result objectForKeyNotNull:@"status"] isEqualToString:@"subscribed"];
            advert.isInWatchList = isWatchList;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            compleate(error);
        });
    }];
}

-(void)sendViwAdvert:(TSAdvert*)advert{
    [[ServerConnectionHelper sharedInstance] sendViwAdvert:advert.ident];
}

-(void)sendReadNotificationsWithAdvert:(TSAdvert*)advert{
    [[ServerConnectionHelper sharedInstance] sendReadNotificationsWithAdvert:advert.ident compleate:^(id result, NSError *error) {
        if (!error)
            [advert updateWithDic:result];
    }];
}

-(void)loadSimilarAdverts:(TSAdvert*)advert withPage:(int)page compleate:(resultBlock)compleate{
    [[ServerConnectionHelper sharedInstance] loadAdvertsWithPage:page similar:advert.ident compleate:^(id result, NSError *error) {
        NSMutableDictionary* additionalDic;
        NSMutableArray* adverts;
        if (!error)
        {
            additionalDic = [NSMutableDictionary dictionaryWithDictionary:result];
            [additionalDic removeObjectForKey:@"results"];
            NSArray* array = [result objectForKeyNotNull:@"results"];
            adverts = [NSMutableArray arrayWithCapacity:array.count];
            
            for (NSDictionary* advertDic in array) {
                TSAdvert* advert = [TSAdvert objectWithDictionary:advertDic];
                if (advert)
                    [adverts addObject:advert];
            }
            
        }else if ([[error localizedDescription] isEqualToString:@"cancelled"]){
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            compleate(adverts, additionalDic, error);
        });
    }];
}

-(void)loadUserAdverts:(TSAdvert*)advert withPage:(int)page compleate:(resultBlock)compleate{
    [[ServerConnectionHelper sharedInstance] loadUserAdvertsWithPage:page similar:advert.ident compleate:^(id result, NSError *error) {
        NSMutableDictionary* additionalDic;
        NSMutableArray* adverts;
        if (!error)
        {
            additionalDic = [NSMutableDictionary dictionaryWithDictionary:result];
            [additionalDic removeObjectForKey:@"results"];
            NSArray* array = [result objectForKeyNotNull:@"results"];
            adverts = [NSMutableArray arrayWithCapacity:array.count];
            
            for (NSDictionary* advertDic in array) {
                TSAdvert* advert = [TSAdvert objectWithDictionary:advertDic];
                if (advert)
                    [adverts addObject:advert];
            }
            
        }else if ([[error localizedDescription] isEqualToString:@"cancelled"]){
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            compleate(adverts, additionalDic, error);
        });
    }];
}

@end
