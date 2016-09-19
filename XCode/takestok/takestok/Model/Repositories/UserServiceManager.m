//
//  UserServiceManager.m
//  takestok
//
//  Created by Artem on 9/13/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "UserServiceManager.h"
#import "AppSettings.h"
#import "ServerConnectionHelper.h"
#import "TSUserBusinessType.h"
#import "TSUserEntity.h"

@implementation UserServiceManager

#define businessTypeStorgeFile [[AppSettings getStorageFolder] stringByAppendingPathComponent:@"businessType.data"]

static UserServiceManager *_manager = nil;

+(instancetype)sharedManager
{
    @synchronized([UserServiceManager class])
    {
        return _manager?_manager:[[self alloc] init];
    }
    return nil;
}

+(id)alloc {
    @synchronized([UserServiceManager class])
    {
        NSAssert(_manager == nil, @"Attempted to allocate a second instance of a singleton.");
        _manager = [super alloc];
        return _manager;
    }
    return nil;
}

-(id)init{
    self = [super init];
    _businessTypes = [NSKeyedUnarchiver unarchiveObjectWithFile:businessTypeStorgeFile];
    if (!_businessTypes){
        _businessTypes = [[NSMutableDictionary alloc] init];
    }
    _users = [[NSMutableDictionary alloc] init];
    
    return self;
}

-(NSArray*)getBusinessType{
    return [_businessTypes allValues];
}

-(TSUserBusinessType*)getBusinessTypeWithId:(NSNumber*)ident{
    return [_businessTypes objectForKey:ident];
}

-(TSUserEntity*)getMe{
    return nil;
}

-(TSUserEntity*)getOrCreateAuthor:(NSDictionary*)authodDic{
    NSNumber* ident = [TSUserEntity identFromDic:authodDic];
    TSUserEntity* user = [_users objectForKey:ident];
    if (!user){
        user = [[TSUserEntity alloc] init];
        [_users setObject:user forKey:ident];
    }
    [user updateWithDic:authodDic];
    return user;
}

#pragma mark - Fetch Dictionaries
-(void)fetchRequiredData{
    [self fetchBusinessTypes];
}

-(void)fetchBusinessTypes{
    if ([[ServerConnectionHelper sharedInstance] isInternetConnection]){
        [[ServerConnectionHelper sharedInstance] loadBusinessTypes:^(id result, NSError *error) {
            if (!error){
                for (NSDictionary* jsBTypes in result) {
                    NSNumber* ident = [TSUserBusinessType identFromDic:jsBTypes];
                    TSUserBusinessType* bType = [_businessTypes objectForKey:ident];
                    if (!bType){
                        bType = [[TSUserBusinessType alloc] init];
                        @synchronized (_businessTypes) {
                            [_businessTypes setObject:bType forKey:ident];
                        }
                    }
                    [bType updateWithDic:jsBTypes];
                }
                [NSKeyedArchiver archiveRootObject:_businessTypes toFile:businessTypeStorgeFile];
            }
        }];
    }
}

-(void)fetchUserData{
    
}

@end
