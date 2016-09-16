//
//  TSQuestion.h
//  takestok
//
//  Created by Artem on 9/15/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSBaseEntity.h"
@class TSAnswer;

@interface TSQuestion : TSBaseEntity

@property (nonatomic, readonly, assign) NSNumber* userIdent;
@property (nonatomic, readonly, retain) NSString* userName;
@property (nonatomic, readonly, retain) NSString* message;
@property (nonatomic, readonly, retain) NSDate* dateCreated;
@property (nonatomic, readonly, retain) TSAnswer* answer;
@property (nonatomic, readonly, assign) NSNumber* advertId;
@property (nonatomic, readonly, assign) BOOL isNew;

@end
