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


#define USER_ID_PARAM                   @"id"
#define USER_PHOTO_PARAM                @"photo"
#define USER_LAST_LOGIN_PARAM           @"last_login"
#define USER_TOKEN_PARAM                @"token"
#define USER_USER_NAME_PARAM            @"username"
#define USER_FIRST_NAME_PARAM           @"first_name"
#define USER_LAST_NAME_PARAM            @"last_name"
#define USER_EMAIL_PARAM                @"email"
#define USER_VERIFIED_PARAM             @"is_verified"
#define USER_SUBSCRIBED_PARAMS          @"is_subscribed"
#define USER_AVG_RATING_PARAM           @"avg_rating"
#define USER_VAT_REGISTERED_PARAM       @"is_vat_exempt"
#define USER_BUSINESS_NAME_PARAM        @"bussines_name"
#define USER_POST_CODE_PARAM            @"postcode"
#define USER_VAT_NUMBER_PARAM           @"vat_number"
#define USER_BUSINESS_TYPE_PARAM        @"bussines_type"
#define USER_BUSINESS_SYBTYPE_PARAM     @"business_sub_type"

@class Advert, Image, Offer, BusinessType, SubBusinessType;

NS_ASSUME_NONNULL_BEGIN

@interface User : BaseEntity{

}

+(User*)getMe;
+(void)refreshUser;

@end

NS_ASSUME_NONNULL_END

#import "User+CoreDataProperties.h"
