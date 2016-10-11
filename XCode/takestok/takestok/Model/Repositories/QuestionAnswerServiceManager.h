//
//  QuestionAnswerServiceManager.h
//  takestok
//
//  Created by Artem on 9/15/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TSAdvert;
@class TSQuestion;
@class TSAnswer;

@interface QuestionAnswerServiceManager : NSObject{
    
}

+(instancetype)sharedManager;
-(void)loadQuestionsAnswers:(TSAdvert*)advert page:(int)page compleate:(resultBlock)compleate;
-(void)askQuestion:(TSQuestion*)question compleate:(errorBlock)compleate;
-(void)makeAnswer:(TSAnswer*)answer compleate:(errorBlock)compleate;
@end
