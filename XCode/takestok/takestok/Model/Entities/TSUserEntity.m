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
#define AUTHOR_SUBSCRIBED_PARAM         @"is_subscribed"
#define AUTHOR_VERIFIED_PARAM           @"is_verified"
#define AUTHOR_IS_VAT_PARAM             @"is_vat_exempt"
#define AUTHOR_RATING_PARAM             @"avg_rating"
#define AUTHOR_PHOTO_PARAM              @"photo"
#define AUTHOR_POSTCODE_PARAM           @"postcode"
#define AUTHOR_VAT_NUMBER_PARAM         @"vat_number"
#define AUTHOR_STRIPE_PARAM             @"stripe_id"
#define AUTHOR_LAST4_PARAM              @"last4"
#define AUTHOR_BUSINESS_NAME_PARAM      @"bussines_name"
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
//"has_notifications": false,

@implementation TSUserEntity

@synthesize userName = _userName;
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize email = _email;
@synthesize isSuscribed = _isSuscribed;
@synthesize isVerified = _isVerified;
@synthesize isVatExtempt = _isVatExtempt;
@synthesize rating = _rating;
@synthesize photo = _photo;
@synthesize postCode = _postCode;
@synthesize vatNumber = _vatNumber;
@synthesize stripeId = _stripeId;
@synthesize last4 = _last4;
@synthesize businessName = _businessName;
@synthesize businessType = _businessType;
@synthesize subBusinessType = _subBusinessType;

-(void)updateWithDic:(NSDictionary*)dict{
    _ident = [TSUserEntity identFromDic:dict];
    _userName = [dict objectForKeyNotNull:AUTHOR_USER_NAME_PARAM];
    if ([dict objectForKeyNotNull:AUTHOR_PHOTO_PARAM]){
        _photo = [[TSImageEntity alloc] initWithUrl:[dict objectForKeyNotNull:AUTHOR_PHOTO_PARAM]];
    }
    
    _userName = [dict objectForKeyNotNull:AUTHOR_USER_NAME_PARAM];
    _firstName = [dict objectForKeyNotNull:AUTHOR_FIRST_NAME_PARAM];
    _lastName = [dict objectForKeyNotNull:AUTHOR_LAST_NAME_PARAM];
    _email = [dict objectForKeyNotNull:AUTHOR_EMAIL_PARAM];
    _isSuscribed = [[dict objectForKeyNotNull:AUTHOR_SUBSCRIBED_PARAM] boolValue];
    _isVerified = [[dict objectForKeyNotNull:AUTHOR_VERIFIED_PARAM] boolValue];
    _isVatExtempt = [[dict objectForKeyNotNull:AUTHOR_IS_VAT_PARAM] boolValue];
    _rating = [[dict objectForKeyNotNull:AUTHOR_RATING_PARAM] floatValue];
    
    _postCode = [dict objectForKeyNotNull:AUTHOR_POSTCODE_PARAM];
    _vatNumber = [dict objectForKeyNotNull:AUTHOR_VAT_NUMBER_PARAM];
    _stripeId = [dict objectForKeyNotNull:AUTHOR_STRIPE_PARAM];
    _last4 = [dict objectForKeyNotNull:AUTHOR_LAST4_PARAM];
    
    _businessName = [dict objectForKeyNotNull:AUTHOR_BUSINESS_NAME_PARAM];
    
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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    _ident = [aDecoder decodeObjectForKey:AUTHOR_ID_PARAM];
    _photo = [aDecoder decodeObjectForKey:AUTHOR_PHOTO_PARAM];
    _userName = [aDecoder decodeObjectForKey:AUTHOR_USER_NAME_PARAM];
    _firstName = [aDecoder decodeObjectForKey:AUTHOR_FIRST_NAME_PARAM];
    _lastName = [aDecoder decodeObjectForKey:AUTHOR_LAST_NAME_PARAM];
    _email = [aDecoder decodeObjectForKey:AUTHOR_EMAIL_PARAM];
    _isSuscribed = [[aDecoder decodeObjectForKey:AUTHOR_SUBSCRIBED_PARAM] boolValue];
    _isVerified = [[aDecoder decodeObjectForKey:AUTHOR_VERIFIED_PARAM] boolValue];
    _isVatExtempt = [[aDecoder decodeObjectForKey:AUTHOR_IS_VAT_PARAM] boolValue];
    _rating = [[aDecoder decodeObjectForKey:AUTHOR_RATING_PARAM] floatValue];
    
    _postCode = [aDecoder decodeObjectForKey:AUTHOR_POSTCODE_PARAM];
    _vatNumber = [aDecoder decodeObjectForKey:AUTHOR_VAT_NUMBER_PARAM];
    _stripeId = [aDecoder decodeObjectForKey:AUTHOR_STRIPE_PARAM];
    _last4 = [aDecoder decodeObjectForKey:AUTHOR_LAST4_PARAM];
    
    _businessName = [aDecoder decodeObjectForKey:AUTHOR_BUSINESS_NAME_PARAM];
    _businessType = [aDecoder decodeObjectForKey:AUTHOR_BUSINESS_TYPE_PARAM];
    _subBusinessType = [aDecoder decodeObjectForKey:AUTHOR_BUSINESS_SUB_TYPE_PARAM];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_ident forKey:AUTHOR_ID_PARAM];
    [aCoder encodeObject:_photo forKey:AUTHOR_PHOTO_PARAM];
    [aCoder encodeObject:_userName forKey:AUTHOR_USER_NAME_PARAM];
    [aCoder encodeObject:_firstName forKey:AUTHOR_FIRST_NAME_PARAM];
    [aCoder encodeObject:_lastName forKey:AUTHOR_LAST_NAME_PARAM];
    [aCoder encodeObject:_email forKey:AUTHOR_EMAIL_PARAM];
    [aCoder encodeBool:_isSuscribed forKey:AUTHOR_SUBSCRIBED_PARAM];
    [aCoder encodeBool:_isVerified forKey:AUTHOR_VERIFIED_PARAM];
    [aCoder encodeBool:_isVatExtempt forKey:AUTHOR_IS_VAT_PARAM];
    [aCoder encodeFloat:_rating forKey:AUTHOR_RATING_PARAM];
    [aCoder encodeObject:_postCode forKey:AUTHOR_POSTCODE_PARAM];
    [aCoder encodeObject:_vatNumber forKey:AUTHOR_VAT_NUMBER_PARAM];
    [aCoder encodeObject:_stripeId forKey:AUTHOR_STRIPE_PARAM];
    [aCoder encodeObject:_last4 forKey:AUTHOR_LAST4_PARAM];
    [aCoder encodeObject:_businessName forKey:AUTHOR_BUSINESS_NAME_PARAM];
    [aCoder encodeObject:_businessType forKey:AUTHOR_BUSINESS_TYPE_PARAM];
    [aCoder encodeObject:_subBusinessType forKey:AUTHOR_BUSINESS_SUB_TYPE_PARAM];
}

-(NSDictionary*)dictionaryRepresentation{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObjectNotNull:_ident forKey:AUTHOR_ID_PARAM];
    [dic setObjectNotNull:_userName forKey:AUTHOR_USER_NAME_PARAM];
    [dic setObjectNotNull:_firstName forKey:AUTHOR_FIRST_NAME_PARAM];
    [dic setObjectNotNull:_lastName forKey:AUTHOR_LAST_NAME_PARAM];
    [dic setObjectNotNull:_email forKey:AUTHOR_EMAIL_PARAM];
    [dic setObjectNotNull:[NSNumber numberWithBool:_isSuscribed] forKey:AUTHOR_SUBSCRIBED_PARAM];
    [dic setObjectNotNull:[NSNumber numberWithBool:YES] forKey:AUTHOR_VERIFIED_PARAM];
    [dic setObjectNotNull:[NSNumber numberWithBool:_isVatExtempt] forKey:AUTHOR_IS_VAT_PARAM];
    [dic setObjectNotNull:_postCode forKey:AUTHOR_POSTCODE_PARAM];
    [dic setObjectNotNull:_vatNumber forKey:AUTHOR_VAT_NUMBER_PARAM];
    [dic setObjectNotNull:_stripeId forKey:AUTHOR_STRIPE_PARAM];
    [dic setObjectNotNull:_last4 forKey:AUTHOR_LAST4_PARAM];
    [dic setObjectNotNull:_businessName forKey:AUTHOR_BUSINESS_NAME_PARAM];
    [dic setObjectNotNull:_businessType.ident forKey:AUTHOR_BUSINESS_TYPE_PARAM];
    [dic setObjectNotNull:_subBusinessType.ident forKey:AUTHOR_BUSINESS_SUB_TYPE_PARAM];
    return dic;
}

-(NSDictionary*)fullDictionaryRepresentation{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithDictionary:[self dictionaryRepresentation]];
    [dic setObjectNotNull:_photo.url forKey:AUTHOR_PHOTO_PARAM];
    [dic setObjectNotNull:[NSNumber numberWithFloat:_rating] forKey:AUTHOR_RATING_PARAM];
    return dic;
}

- (id)copyWithZone:(nullable NSZone *)zone{
    TSUserEntity* copy = [[TSUserEntity allocWithZone:zone] init];
    [copy updateWithDic:[self fullDictionaryRepresentation]];
    return copy;
}


@end
