//
//  TSQuestion.m
//  takestok
//
//  Created by Artem on 9/15/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSQuestion.h"
#import "TSAnswer.h"

#define QUESTION_ID_PARAM                 @"id"
#define QUESTION_USER_ID_PARAM            @"user"
#define QUESTION_MESSAGE_PARAM            @"message"
#define QUESTION_ANSWER_PARAM             @"answer"
#define QUESTION_ADVERT_ID_PARAM          @"advert"
#define QUESTION_CREATED_PARAM            @"created_at"
#define QUESTION_IS_NEW_PARAM             @"is_new"
#define QUESTION_USER_NAME_PARAM          @"user_username"

@implementation TSQuestion

-(void)updateWithDic:(NSDictionary*)dict{
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    _ident = [TSQuestion identFromDic:dict];
    _userIdent = [dict objectForKeyNotNull:QUESTION_USER_ID_PARAM];
    _message = [dict objectForKeyNotNull:QUESTION_MESSAGE_PARAM];
    NSDictionary* answerDic = [dict objectForKeyNotNull:QUESTION_ANSWER_PARAM];
    if (answerDic){
        _answer = [[TSAnswer alloc] initWithQuestionIdent:_ident withDic:answerDic];
    }
    _advertId = [dict objectForKeyNotNull:QUESTION_ADVERT_ID_PARAM];
    _dateCreated = [NSDate dateFromString:[dict objectForKeyNotNull:QUESTION_CREATED_PARAM] format:DEFAULT_DATE_FORMAT timeZone:timeZone];
    _isNew = [[dict objectForKeyNotNull:QUESTION_IS_NEW_PARAM] boolValue];
    _userName = [dict objectForKeyNotNull:QUESTION_USER_NAME_PARAM];
}

+(NSNumber*)identFromDic:(NSDictionary*)dict{
    return [dict objectForKeyNotNull:QUESTION_ID_PARAM];
}

@end
