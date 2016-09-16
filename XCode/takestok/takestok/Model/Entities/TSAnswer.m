//
//  TSAnswer.m
//  takestok
//
//  Created by Artem on 9/15/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSAnswer.h"

#define ANSWERS_ID_PARAM                 @"id"
#define ANSWERS_USER_ID_PARAM            @"user"
#define ANSWERS_MESSAGE_PARAM            @"message"
#define ANSWERS_CREATED_PARAM            @"created_at"
#define ANSWERS_USER_NAME_PARAM          @"user_username"

@implementation TSAnswer

-(instancetype)initWithQuestionIdent:(NSNumber*)questionId withDic:(NSDictionary*)dic{
    self = [super init];
    _questionId = questionId;
    [self updateWithDic:dic];
    return self;
}

-(void)updateWithDic:(NSDictionary*)dict{
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    _ident = [TSAnswer identFromDic:dict];
    _userIdent = [dict objectForKeyNotNull:ANSWERS_USER_ID_PARAM];
    _message = [dict objectForKeyNotNull:ANSWERS_MESSAGE_PARAM];
    _dateCreated = [NSDate dateFromString:[dict objectForKeyNotNull:ANSWERS_CREATED_PARAM] format:DEFAULT_DATE_FORMAT timeZone:timeZone];
    _userName = [dict objectForKeyNotNull:ANSWERS_USER_NAME_PARAM];
}

+(NSNumber*)identFromDic:(NSDictionary*)dict{
    return [dict objectForKeyNotNull:ANSWERS_ID_PARAM];
}

@end
