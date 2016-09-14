//
//  TSAdvert.m
//  takestok
//
//  Created by Artem on 9/12/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSAdvert.h"
#import "AdvertServiceManager.h"
#import "TSImageEntity.h"
#import "UserServiceManager.h"

#define ADVERT_ID_PARAM                    @"id"
#define ADVERT_NAME_PARAM                  @"name"
#define ADVERT_CREATED_PARAM               @"created_at"
#define ADVERT_EXPIRES_PARAM               @"expires_at"
#define ADVERT_UPDATED_AT_PARAM            @"updated_at"
#define ADVERT_GUIDE_PRICE_PARAM           @"guide_price"
#define ADVERT_DESCRIPTION_PARAM           @"description"
#define ADVERT_LOCATION_PARAM              @"location"
#define ADVERT_SHIPPING_PARAM              @"shipping"
#define ADVERT_IS_VAT_EXTEMP_PARAM         @"is_vat_exempt"
#define ADVERT_PHOTOS_PARAM                @"photos"
#define ADVERT_AUTHOR_PARAM                @"author_detailed"
#define ADVERT_CATEGORY_PARAM              @"category"
#define ADVERT_SUBCATEGORY_PARAM           @"subcategory"
#define ADVERT_PACKAGING_PARAM             @"packaging"
#define ADVERT_MAIN_ORDER_QUANTITY_PARAM   @"min_order_quantity"
#define ADVERT_SIZE_PARAM                  @"size"
#define ADVERT_CERTIFICATIONS_EXTRA_PARAM  @"certification_extra"
#define ADVERT_CERTIFICATION_PARAM         @"certification_id"
#define ADVERT_CONDITION_PARAM             @"condition"
#define ADVERT_ITEMS_COUNT_PARAM           @"items_count"
#define ADVERT_ITEMS_COUNT_NOW_PARAM       @"items_count_now"
#define ADVERT_TAGS_PARAM                  @"tags"
#define ADVERT_AUTHOR_DETAILS_PARAM        @"author_detailed"
#define ADVERT_OFFERS_COUNT_PARAM          @"offers_count"
#define ADVERT_QUESTION_COUNT_PARAM        @"questions_count"
#define ADVERT_IN_DRAFTS_PARAM             @"in_drafts"
#define ADVERT_CAN_OFFER_PARAM             @"can_offer"
#define ADVERT_NOTIFICATIONS_PARAM         @"notifications"
#define ADVERT_NEW_QUESTIONS_PARAM         @"new_q_count"
#define ADVERT_NEW_OFFERS_PARAM            @"new_offers_count"
#define ADVERT_STATE_PARAM                 @"state"

@implementation TSAdvert

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    [self updateWithDic:dict];
    return self;
}

-(void)updateWithDic:(NSDictionary*)dict{
    NSTimeZone* timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    _ident = [TSAdvert identFromDic:dict];
    _name = [dict objectForKeyNotNull:ADVERT_NAME_PARAM];
    _dateCreated = [NSDate dateFromString:[dict objectForKeyNotNull:ADVERT_CREATED_PARAM] format:DEFAULT_DATE_FORMAT timeZone:timeZone];
    _dateExpires = [NSDate dateFromString:[dict objectForKeyNotNull:ADVERT_EXPIRES_PARAM] format:DEFAULT_DATE_FORMAT timeZone:timeZone];
    _dateUpdated = [NSDate dateFromString:[dict objectForKeyNotNull:ADVERT_UPDATED_AT_PARAM] format:DEFAULT_DATE_FORMAT timeZone:timeZone];
    _guidePrice = [[dict objectForKeyNotNull:ADVERT_GUIDE_PRICE_PARAM] floatValue];
    _adDescription = [dict objectForKeyNotNull:ADVERT_DESCRIPTION_PARAM];
    _location = [dict objectForKeyNotNull:ADVERT_LOCATION_PARAM];
    
    NSNumber* shippingIdent = [dict objectForKeyNotNull:ADVERT_SHIPPING_PARAM];
    TSAdvertShipping* shipping = [[AdvertServiceManager sharedManager] getShippingWithId:shippingIdent];
    _shipping = shipping;
    
    _isVatExtempt = [[dict objectForKeyNotNull:ADVERT_IS_VAT_EXTEMP_PARAM] boolValue];
    
    NSMutableArray* advPhotos = [NSMutableArray array];
    for (NSDictionary* photoDic in [dict objectForKeyNotNull:ADVERT_PHOTOS_PARAM]){
        TSImageEntity* image = [TSImageEntity objectWithDictionary:photoDic];
        if (image.isMain){
            [advPhotos insertObject:image atIndex:0];
        }else{
            [advPhotos addObject:image];
        }
    }
    _photos = [NSArray arrayWithArray:advPhotos];
    
    NSDictionary* authorDic = [dict objectForKeyNotNull:ADVERT_AUTHOR_PARAM];
    _author = [[UserServiceManager sharedManager] getOrCreateAuthor:authorDic];
    
    NSNumber* categoryIdent = [dict objectForKeyNotNull:ADVERT_CATEGORY_PARAM];
    TSAdvertCategory* category = [[AdvertServiceManager sharedManager] getCategoyWithId:categoryIdent];
    _category = category;
    
    NSNumber* subcategoryIdent = [dict objectForKeyNotNull:ADVERT_SUBCATEGORY_PARAM];
    for (TSAdvertSubCategory* subCategory in category.subCategories) {
        if ([subCategory.ident isEqualToNumber:subcategoryIdent]){
            _subCategory = subCategory;
            break;
        }
    }
    
    NSNumber* packagingIdent = [dict objectForKeyNotNull:ADVERT_PACKAGING_PARAM];
    TSAdvertPackagingType* packaging = [[AdvertServiceManager sharedManager] getPackageTypeWithId:packagingIdent];
    _packaging = packaging;
    
    _minOrderQuantity = [[dict objectForKeyNotNull:ADVERT_MAIN_ORDER_QUANTITY_PARAM] intValue];
    _size = [dict objectForKeyNotNull:ADVERT_SIZE_PARAM];
    _certificationOther = [dict objectForKeyNotNull:ADVERT_CERTIFICATIONS_EXTRA_PARAM];
    
    NSNumber* cetIdent = [dict objectForKeyNotNull:ADVERT_CERTIFICATION_PARAM];
    TSAdvertCertification* certificate = [[AdvertServiceManager sharedManager] getCertificationWithId:cetIdent];
    _certification = certificate;
    
    NSNumber* conditionIdent = [dict objectForKeyNotNull:ADVERT_CONDITION_PARAM];
    TSAdvertCondition* condition = [[AdvertServiceManager sharedManager] getConditionWithId:conditionIdent];
    _condition = condition;
    
    _count = [[dict objectForKeyNotNull:ADVERT_ITEMS_COUNT_PARAM] intValue];
    _countNow = [[dict objectForKeyNotNull:ADVERT_ITEMS_COUNT_NOW_PARAM] intValue];
    _tags = [dict objectForKeyNotNull:ADVERT_TAGS_PARAM];
    _newOffersCount = [[dict objectForKeyNotNull:ADVERT_NEW_OFFERS_PARAM] intValue];
    _newQuestionsCount = [[dict objectForKeyNotNull:ADVERT_NEW_QUESTIONS_PARAM] intValue];
    _questionCount = [[dict objectForKeyNotNull:ADVERT_QUESTION_COUNT_PARAM] intValue];
    _isInDrafts = [[dict objectForKeyNotNull:ADVERT_IN_DRAFTS_PARAM] boolValue];
    _canOffer = [[dict objectForKeyNotNull:ADVERT_CAN_OFFER_PARAM] boolValue];
    _notifications = [[dict objectForKeyNotNull:ADVERT_NOTIFICATIONS_PARAM] intValue];
    
    NSNumber* stateIdent = [dict objectForKeyNotNull:ADVERT_STATE_PARAM];
    TSAdvertState* state = [[AdvertServiceManager sharedManager] getStateWithId:stateIdent];
    _state = state;
    
}

+(NSNumber*)identFromDic:(NSDictionary*)dict{
    return [dict objectForKeyNotNull:ADVERT_ID_PARAM];
}

@end
