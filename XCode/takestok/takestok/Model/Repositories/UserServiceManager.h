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

-(NSArray*)getBusinessType;
-(TSUserBusinessType*)getBusinessTypeWithId:(NSNumber*)ident;

-(TSUserEntity*)getMe;
-(TSUserEntity*)getOrCreateAuthor:(NSDictionary*)authodDic;

@end
