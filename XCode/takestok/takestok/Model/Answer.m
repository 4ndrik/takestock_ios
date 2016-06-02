//
//  Answer.m
//  takestok
//
//  Created by Artem on 5/16/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "Answer.h"
#import "Question.h"
#import "User.h"

@implementation Answer

+ (NSString *)entityName {
    return @"Answer";
}

-(void)updateWithDic:(NSDictionary*)jsonDic{
    self.ident = [[jsonDic objectForKeyNotNull:ANSWER_ID_PARAM] intValue];
    self.user = [User getEntityWithId:[[jsonDic objectForKeyNotNull:ANSWER_USER_PARAM] intValue]];
    self.message = [jsonDic objectForKeyNotNull:ANSWER_MESSAGE_PARAM];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    self.created = [[NSDate dateFromString:[jsonDic objectForKeyNotNull:ANSWER_CREATED_PARAM] format:DEFAULT_DATE_FORMAT timeZone:timeZone] timeIntervalSinceReferenceDate];
}

-(NSDictionary*)getDictionary{
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    if (self.ident > 0){
        [result setValue:[NSNumber numberWithInt:self.ident] forKey:ANSWER_ID_PARAM];
    }
    [result setValue:[NSNumber numberWithInt:self.user.ident] forKey:ANSWER_USER_PARAM];
    [result setValue:self.message forKey:ANSWER_MESSAGE_PARAM];
    [result setValue:[NSArray arrayWithObjects:[NSNumber numberWithInt:self.question.ident], nil] forKey:ANSWER_QUESTION_SET_PARAM];
    return result;
}

@end
