//
//  Question.h
//  takestok
//
//  Created by Artem on 5/16/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEntity.h"

@class Advert, User, Answer;

#define QUESTION_ID_PARAM              @"id"
#define QUESTION_USER_PARAM            @"user"
#define QUESTION_ADVERT_PARAM          @"advert"
#define QUESTION_MESSAGE_PARAM         @"message"
#define QUESTION_CREATED_PARAM         @"created_at"
#define QUESTION_ANSWER_PARAM          @"answer"

//#define OFFER_ACCEPT_COMMENT_PARAM  @"is_new"



NS_ASSUME_NONNULL_BEGIN

@interface Question : BaseEntity

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Question+CoreDataProperties.h"
