//
//  User.h
//  takestok
//
//  Created by Artem on 5/4/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEntity.h"
#import "Image.h"
#import "Category.h"
#import "Condition.h"
#import "Shipping.h"
#import "SizeType.h"
#import "Certification.h"
#import "User.h"
#import "Packaging.h"
#import "Question.h"


#define USER_ID_PARAM           @"id"
#define USER_LAST_LOGIN_PARAM   @"last_login"
#define USER_TOKEN_PARAM        @"token"
#define USER_USER_NAME_PARAM    @"username"
#define USER_FIRST_NAME_PARAM   @"first_name"
#define USER_LAST_NAME_PARAM    @"last_name"
#define USER_EMAIL_PARAM        @"email"
#define USER_VERIFIED_PARAM     @"is_verified"
#define USER_SUBSCRIBED_PARAMS  @"is_subscribed"
#define USER_AVG_RATING_PARAM   @"avg_rating"

@class Advert, Image, Offer;

NS_ASSUME_NONNULL_BEGIN

@interface User : BaseEntity{

}

+(User*)getMe;

@end

NS_ASSUME_NONNULL_END

#import "User+CoreDataProperties.h"
