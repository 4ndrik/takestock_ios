//
//  Question.m
//  takestok
//
//  Created by Artem on 5/16/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "Question.h"
#import "Advert.h"
#import "User.h"
#import "Answer.h"

@implementation Question

+ (NSString *)entityName {
    return @"Question";
}

-(void)updateWithDic:(NSDictionary*)jsonDic{
    self.ident = [[jsonDic objectForKeyNotNull:QUESTION_ID_PARAM] intValue];
    
    User* user = [User getEntityWithId:[[jsonDic objectForKeyNotNull:QUESTION_USER_PARAM] intValue]];
    if (user && user.managedObjectContext != self.managedObjectContext){
        user = [self.managedObjectContext objectWithID:[user objectID]];
    }
    self.user = user;
    
    Advert* advert = [Advert getEntityWithId:[[jsonDic objectForKeyNotNull:QUESTION_ADVERT_PARAM] intValue]];
    if (advert && advert.managedObjectContext != self.managedObjectContext){
        advert = [self.managedObjectContext objectWithID:[advert objectID]];
    }
    self.advert = advert;
    if (self.ident == 0 || !self.user){
        [self.managedObjectContext deleteObject:self];
        NSLog(@"Offer %i hasn't required data", self.ident);
        return;
    }
    NSTimeZone* timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    self.created = [[NSDate dateFromString:[jsonDic objectForKeyNotNull:QUESTION_CREATED_PARAM] format:DEFAULT_DATE_FORMAT timeZone:timeZone] timeIntervalSinceReferenceDate];
    
    self.message = [jsonDic objectForKeyNotNull:QUESTION_MESSAGE_PARAM];
    NSDictionary* ansDic = [jsonDic objectForKeyNotNull:QUESTION_ANSWER_PARAM];
    
    int answerId = [[ansDic objectForKeyNotNull:ANSWER_ID_PARAM] intValue];
    if (answerId > 0){
        Answer* answer = [Answer getEntityWithId:answerId];
        if (!answer){
            answer = self.isForStore ? [Answer storedEntity] : [Answer tempEntity];
        }else if (answer.managedObjectContext != self.managedObjectContext){
            answer = [self.managedObjectContext objectWithID:[answer objectID]];
        }
        self.answer = answer;
        [answer updateWithDic:ansDic];
    }
}

-(NSDictionary*)getDictionary{
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    if (self.ident > 0){
        [result setValue:[NSNumber numberWithInt:self.ident] forKey:QUESTION_ID_PARAM];
    }
    [result setValue:[NSNumber numberWithInt:self.user.ident] forKey:QUESTION_USER_PARAM];
    [result setValue:[NSNumber numberWithInt:self.advert.ident] forKey:QUESTION_ADVERT_PARAM];
    [result setValue:self.message forKey:QUESTION_MESSAGE_PARAM];
    
    return result;
}

@end
