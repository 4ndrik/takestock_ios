//
//  Answer.h
//  takestok
//
//  Created by Artem on 5/16/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseEntity.h"

@class Question, User;

#define ANSWER_ID_PARAM              @"id"
#define ANSWER_USER_PARAM            @"user"
#define ANSWER_MESSAGE_PARAM         @"message"
#define ANSWER_CREATED_PARAM         @"created_at"
#define ANSWER_QUESTION_SET_PARAM    @"question_set"


NS_ASSUME_NONNULL_BEGIN

@interface Answer : BaseEntity

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Answer+CoreDataProperties.h"
