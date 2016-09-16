//
//  QuestionAnswerServiceManager.m
//  takestok
//
//  Created by Artem on 9/15/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "QuestionAnswerServiceManager.h"
#import "ServerConnectionHelper.h"
#import "TSAdvert.h"
#import "TSQuestion.h"

@implementation QuestionAnswerServiceManager

static QuestionAnswerServiceManager *_manager = nil;

+(instancetype)sharedManager
{
    @synchronized([QuestionAnswerServiceManager class])
    {
        return _manager?_manager:[[self alloc] init];
    }
    return nil;
}

+(id)alloc {
    @synchronized([QuestionAnswerServiceManager class])
    {
        NSAssert(_manager == nil, @"Attempted to allocate a second instance of a singleton.");
        _manager = [super alloc];
        return _manager;
    }
    return nil;
}

-(id)init{
    self = [super init];
    return self;
}

-(void)loadQuestionsAnswers:(TSAdvert*)advert page:(int)page compleate:(resultBlock)compleate{
    
    [[ServerConnectionHelper sharedInstance] loadQuestionAnswersWith:advert.ident page:page compleate:^(id result, NSError *error) {
        NSMutableArray* questions;
        NSMutableDictionary* additionalDic;
        if (!error){
            additionalDic = [NSMutableDictionary dictionaryWithDictionary:result];
            [additionalDic removeObjectForKey:@"results"];
            NSArray* questionResult = [result objectForKeyNotNull:@"results"];
            questions = [NSMutableArray arrayWithCapacity:questionResult.count];
            
            for (NSDictionary* questionDic in questionResult) {
                TSQuestion* question = [TSQuestion objectWithDictionary:questionDic];
                if (question){
                    [questions addObject:question];
                }
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            compleate(questions, additionalDic, error);
        });
    }];
}

@end
