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
#import "NotificationServiceManager.h"

@import Firebase;

@implementation UserServiceManager

#define businessTypeStorgeFile [[AppSettings getStorageFolder] stringByAppendingPathComponent:@"businessType.data"]
#define userStorgeFile(userId) [[AppSettings getStorageFolder] stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.data", userId]]

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
    NSNumber* userIdent = [AppSettings getUserId];
    if (userIdent){
        TSUserEntity* user = [NSKeyedUnarchiver unarchiveObjectWithFile:userStorgeFile(userIdent)];
        if (user)
            [_users setObject:user forKey:userIdent];
    }
    
    return self;
}

-(NSArray*)getBusinessTypes{
    return [_businessTypes allValues];
}

-(TSUserBusinessType*)getBusinessTypeWithId:(NSNumber*)ident{
    return [_businessTypes objectForKey:ident];
}

-(TSUserEntity*)getMe{
    TSUserEntity* user = nil;
    if ([AppSettings getUserId]){
        user = [_users objectForKey:[AppSettings getUserId]];
    }
    return user;
}

-(TSUserEntity*)getAuthorWithId:(NSNumber*)authorId{
    return [_users objectForKey:authorId];
}

-(TSUserEntity*)getOrCreateAuthor:(NSDictionary*)authodDic{
    NSNumber* ident = [TSUserEntity identFromDic:authodDic];
    TSUserEntity* user = [_users objectForKey:ident];
    if (!user){
        user = [[TSUserEntity alloc] init];
        @synchronized (_users) {
            [_users setObject:user forKey:ident];
        }
    }
    [user updateWithDic:authodDic];
    return user;
}

-(void)fetchRequiredData{
    [self fetchBusinessTypes];
    [self fetchUserData];
}

-(void)signInWithUserName:(NSString*)username password:(NSString*)password compleate:(errorBlock)compleate{
    [[ServerConnectionHelper sharedInstance] signInWithUserName:username password:password compleate:^(id result, NSError *error) {
        if (!error){
            NSString* token = [result objectForKey:@"token"];
            if (token.length > 0){
                [AppSettings setToken:token];
            }
            NSDictionary* userDic = [result objectForKeyNotNull:@"user"];
            NSNumber* userId = [TSUserEntity identFromDic:userDic];
            TSUserEntity* me = [_users objectForKey:userId];
            if (!me){
                me = [TSUserEntity objectWithDictionary:userDic];
                @synchronized (_users) {
                    [_users setObject:me forKey:userId];
                }
            }else{
                [me updateWithDic:userDic];
            }
            [AppSettings setUserId:userId];
            [NSKeyedArchiver archiveRootObject:me toFile:userStorgeFile(userId)];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self sendAPNSToken];
            compleate(error);
        });
    }];
}

-(void)signUpWithUserName:(NSString*)username email:(NSString*)email password:(NSString*)password compleate:(errorBlock)compleate{
    [[ServerConnectionHelper sharedInstance] signUpWithUserName:username email:email password:password compleate:^(id result, NSError *error) {
        if (!error){
            [self signInWithUserName:username password:password compleate:compleate];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                compleate(error);
            });
        }
    }];
}

-(void)updateUser:(TSUserEntity*)user withImage:(UIImage*)image compleate:(errorBlock)compleate{
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithDictionary:[user dictionaryRepresentation]];
    [dic removeObjectForKey:@"photo"];
    
    NSData* imageData = UIImagePNGRepresentation(image);
    if (imageData.length > 0){
        [dic setValue:[NSString stringWithFormat:@"data:image/png;base64,%@",[imageData base64EncodedDataWithOptions:0]] forKey:@"photo_b64"];
    }
    
    [[ServerConnectionHelper sharedInstance] updateUser:dic compleate:^(id result, NSError *error) {
        if (!error){
            NSDictionary* userDic = result;
            NSNumber* userId = [TSUserEntity identFromDic:userDic];
            TSUserEntity* me = [_users objectForKey:userId];
            if (!me){
                me = [TSUserEntity objectWithDictionary:userDic];
                @synchronized (_users) {
                    [_users setObject:me forKey:userId];
                }
            }else{
                [me updateWithDic:userDic];
            }
            [AppSettings setUserId:userId];
            [[NotificationServiceManager sharedManager] reloadNotifications];
            [NSKeyedArchiver archiveRootObject:me toFile:userStorgeFile(userId)];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            compleate(error);
        });
    }];
}

-(void)sendAPNSToken{
    NSString* token = [[FIRInstanceID instanceID] token];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"active", @"ios", @"type", [[UIDevice currentDevice].identifierForVendor UUIDString], @"device_id", [UIDevice currentDevice].model, @"name", token, @"registration_id", nil];
    
    if (token.length > 0 && [UserServiceManager sharedManager].getMe){
        [dic setValue:token forKey:@"registration_id"];
        
        [[ServerConnectionHelper sharedInstance] sendAPNSToken:dic compleate:^(id result, NSError *error) {
            NSLog(@"dasd");
        }];
        
    }
}

-(void)removeAPNSToken{
    NSString* token = [[FIRInstanceID instanceID] token];
    if (token.length > 0){
        [[ServerConnectionHelper sharedInstance] removeAPNSToken:token];
    }
}

#pragma mark - Fetch BusinessTypes

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

#pragma mark - UserData

-(void)fetchUserData{
    if ([AppSettings getUserId]){
        if ([[ServerConnectionHelper sharedInstance] isInternetConnection]){
            [[ServerConnectionHelper sharedInstance] loadUsersWithIds:[NSArray arrayWithObjects:[AppSettings getUserId], nil] compleate:^(id result, NSError *error) {
                if (!error){
                    NSMutableArray* usersArray = [result objectForKey:@"results"];
                    for (NSDictionary* userDic in usersArray) {
                        NSNumber* userId = [TSUserEntity identFromDic:userDic];
                        TSUserEntity* user = [_users objectForKey:userId];
                        if (!user){
                            user = [TSUserEntity objectWithDictionary:userDic];
                            @synchronized (_users) {
                                [_users setObject:user forKey:userId];
                            }
                        }else{
                            [user updateWithDic:userDic];
                        }
                        
                        if ([user.ident isEqual:[AppSettings getUserId]]){
                            [NSKeyedArchiver archiveRootObject:user toFile:userStorgeFile(userId)];
                        }
                    }
                }
            }];
        }
    }
}

@end
