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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = DEFAULT_DATE_FORMAT;
    
    self.ident = [[jsonDic objectForKeyNotNull:ANSWER_ID_PARAM] intValue];
    self.user = [User getEntityWithId:[[jsonDic objectForKeyNotNull:ANSWER_USER_PARAM] intValue]];
    self.created = [[dateFormatter dateFromString:[jsonDic objectForKeyNotNull:ANSWER_CREATED_PARAM]] timeIntervalSinceReferenceDate];
    self.message = [jsonDic objectForKeyNotNull:ANSWER_MESSAGE_PARAM];
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
