//
//  TSAnswer.h
//  takestok
//
//  Created by Artem on 9/15/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSBaseEntity.h"

@interface TSAnswer : TSBaseEntity{
    NSNumber* _questionId;
    NSNumber* _userIdent;
    NSString* _userName;
    NSString* _message;
    NSDate* _dateCreated;
}

@property (nonatomic, readonly, retain) NSNumber* questionId;
@property (nonatomic, readonly, retain) NSNumber* userIdent;
@property (nonatomic, readonly, retain) NSString* userName;
@property (nonatomic, readonly, retain) NSString* message;
@property (nonatomic, readonly, retain) NSDate* dateCreated;

-(instancetype)initWithQuestionIdent:(NSNumber*)questionId withDic:(NSDictionary*)dic;

@end
