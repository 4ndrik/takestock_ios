//
//  TSAuthorEntity.m
//  takestok
//
//  Created by Artem on 9/13/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSUserEntity.h"
#import "UserServiceManager.h"
#import "TSUserBusinessType.h"
#import "TSUserSubBusinessType.h"

#define AUTHOR_ID_PARAM                 @"id"
#define AUTHOR_USER_NAME_PARAM          @"username"
#define AUTHOR_FIRST_NAME_PARAM         @"first_name"
#define AUTHOR_LAST_NAME_PARAM          @"last_name"
#define AUTHOR_EMAIL_PARAM              @"email"
#define AUTHOR_VERIFIED_PARAM           @"is_verified"
#define AUTHOR_IS_VAT_PARAM             @"is_vat_exempt"
#define AUTHOR_RATING_PARAM             @"avg_rating"
#define AUTHOR_PHOTO_PARAM              @"photo"
#define AUTHOR_POSTCODE_PARAM           @"postcode"
#define AUTHOR_VAT_NUMBER_PARAM         @"vat_number"
#define AUTHOR_STRIPE_PARAM             @"stripe_id"
#define AUTHOR_LAST4_PARAM              @"last4"
#define AUTHOR_BUSINESS_TYPE_PARAM      @"bussines_type"
#define AUTHOR_BUSINESS_SUB_TYPE_PARAM  @"business_sub_type"

//"last_login": null,
//"is_superuser": true,
//"role": null,
//"partnerparent": null,
//"partner": null,
//"remember_token": null,
//"payment_method": null,
//"sort_code": null,
//"account_number": null,
//"service": null,
//"group_reference": null,
//"group_code": null,
//"is_seller": false,
//"description": null,
//"old_id": "",
//"is_staff": true,
//"is_active": true,
//"date_joined": "2016-08-31T23:40:34.146068Z",
//"is_subscribed": false,
//"is_verified": false,
//"bussines_name": null,
//"has_notifications": false,

@implementation TSUserEntity


-(void)updateWithDic:(NSDictionary*)dict{
    _ident = [TSUserEntity identFromDic:dict];
    _userName = [dict objectForKeyNotNull:AUTHOR_USER_NAME_PARAM];
    
    _userName = [dict objectForKeyNotNull:AUTHOR_USER_NAME_PARAM];
    _firstName = [dict objectForKeyNotNull:AUTHOR_FIRST_NAME_PARAM];
    _lastName = [dict objectForKeyNotNull:AUTHOR_LAST_NAME_PARAM];
    _email = [dict objectForKeyNotNull:AUTHOR_EMAIL_PARAM];
    _isVerified = [[dict objectForKeyNotNull:AUTHOR_VERIFIED_PARAM] boolValue];
    _isVatExtempt = [[dict objectForKeyNotNull:AUTHOR_IS_VAT_PARAM] boolValue];
    _rating = [[dict objectForKeyNotNull:AUTHOR_RATING_PARAM] floatValue];
    
    _postCode = [dict objectForKeyNotNull:AUTHOR_POSTCODE_PARAM];
    _vatNumber = [dict objectForKeyNotNull:AUTHOR_VAT_NUMBER_PARAM];
    _stripeId = [dict objectForKeyNotNull:AUTHOR_STRIPE_PARAM];
    _last4 = [dict objectForKeyNotNull:AUTHOR_LAST4_PARAM];
    
    NSNumber* btIdent = [dict objectForKeyNotNull:AUTHOR_BUSINESS_TYPE_PARAM];
    _businessType = [[UserServiceManager sharedManager]getBusinessTypeWithId:btIdent];
    
    NSNumber* subBtIdent = [dict objectForKeyNotNull:AUTHOR_BUSINESS_SUB_TYPE_PARAM];
    if (subBtIdent){
        for (TSUserSubBusinessType* subBt in _businessType.subTypes) {
            if ([subBt.ident isEqualToNumber:subBtIdent]){
                _subBusinessType = subBt;
                break;
            }
        }
    }
}

+(NSNumber*)identFromDic:(NSDictionary*)dict{
    return [dict objectForKeyNotNull:AUTHOR_ID_PARAM];
}


@end
