//
//  UserServiceManager.h
//  takestok
//
//  Created by Artem on 9/13/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TSUserBusinessType;
@class TSUserEntity;

@interface UserServiceManager : NSObject{
    NSMutableDictionary* _users;
    NSMutableDictionary* _businessTypes;
}

+(instancetype)sharedManager;
-(void)fetchRequiredData;

-(NSArray*)getBusinessTypes;
-(TSUserBusinessType*)getBusinessTypeWithId:(NSNumber*)ident;

-(TSUserEntity*)getMe;
-(TSUserEntity*)getOrCreateAuthor:(NSDictionary*)authodDic;

-(void)signInWithUserName:(NSString*)username password:(NSString*)password compleate:(errorBlock)compleate;
-(void)signUpWithUserName:(NSString*)username email:(NSString*)email password:(NSString*)password compleate:(errorBlock)compleate;

-(void)updateUser:(TSUserEntity*)user withImage:(UIImage*)image compleate:(errorBlock)compleate;

@end
