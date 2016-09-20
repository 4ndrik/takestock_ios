//
//  TSQuestion.h
//  takestok
//
//  Created by Artem on 9/15/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSBaseEntity.h"
@class TSAnswer;

@interface TSQuestion : TSBaseEntity{
    NSNumber* _userIdent;
    NSString* _userName;
    NSString* _message;
    NSDate* _dateCreated;
    TSAnswer* _answer;
    NSNumber* _advertId;
    BOOL _isNew;
}

@property (nonatomic, readonly, retain) NSNumber* userIdent;
@property (nonatomic, readonly, retain) NSString* userName;
@property (nonatomic, readonly, retain) NSString* message;
@property (nonatomic, readonly, retain) NSDate* dateCreated;
@property (nonatomic, readonly, retain) TSAnswer* answer;
@property (nonatomic, readonly, retain) NSNumber* advertId;
@property (nonatomic, readonly, assign) BOOL isNew;

@end
