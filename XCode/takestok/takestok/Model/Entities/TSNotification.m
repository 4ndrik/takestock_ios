//
//  TSNotification.m
//  takestok
//
//  Created by Artem on 10/28/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSNotification.h"

#define NOTIFICATION_ID_PARAM                @"gcm.message_id"
#define NOTIFICATION_TITLE_PARAM             @"title"
#define NOTIFICATION_TEXT_PARAM              @"body"
#define NOTIFICATION_DATE_CREATED_PARAM      @"date_created"
#define NOTIFICATION_ADVERT_ID_PARAM         @"advert_id"
#define NOTIFICATION_OFFER_ID_PARAM          @"offer_id"
#define NOTIFICATION_TYPE_PARAM              @"action"

#define GENERAL_STRING_TYPE     @"com.takestock.action.MAIN"
#define SELLING_STRING_TYPE     @"com.takestock.action.SELLING"
#define BUYING_STRING_TYPE      @"com.takestock.action.BUYING"
#define QUESTION_STRING         @"com.takestock.action.ADVERT_QUESTION"
#define ANSWER_STRING           @"com.takestock.action.ADVERT_ANSWER"

@implementation TSNotification

+ (instancetype)objectWithDictionary:(NSDictionary *)dict{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    _notId = [dict objectForKeyNotNull:NOTIFICATION_TITLE_PARAM];
    _title = [dict objectForKeyNotNull:NOTIFICATION_TITLE_PARAM];
    _text = [dict objectForKeyNotNull:NOTIFICATION_TEXT_PARAM];
    _dateCreated = [NSDate date];
    _advertId = [dict objectForKeyNotNull:NOTIFICATION_ADVERT_ID_PARAM];
    _offerId = [dict objectForKeyNotNull:NOTIFICATION_OFFER_ID_PARAM];
    
    NSString* typeString =[dict objectForKeyNotNull:NOTIFICATION_TYPE_PARAM];
    if ([typeString isEqualToString:GENERAL_STRING_TYPE])
        _type = kGeneral;
    else if ([typeString isEqualToString:BUYING_STRING_TYPE])
        _type = kBuying;
    else if ([typeString isEqualToString:QUESTION_STRING] || [typeString isEqualToString:ANSWER_STRING])
        _type = kQuestion;
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    _notId = [aDecoder decodeObjectForKey:NOTIFICATION_TITLE_PARAM];
    _title = [aDecoder decodeObjectForKey:NOTIFICATION_TITLE_PARAM];
    _text = [aDecoder decodeObjectForKey:NOTIFICATION_TEXT_PARAM];
    _dateCreated = [aDecoder decodeObjectForKey:NOTIFICATION_DATE_CREATED_PARAM];
    _advertId = [aDecoder decodeObjectForKey:NOTIFICATION_ADVERT_ID_PARAM];
    _offerId = [aDecoder decodeObjectForKey:NOTIFICATION_OFFER_ID_PARAM];
    _type = [[aDecoder decodeObjectForKey:NOTIFICATION_TYPE_PARAM] intValue];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_title forKey:NOTIFICATION_TITLE_PARAM];
    [aCoder encodeObject:_text forKey:NOTIFICATION_TEXT_PARAM];
    [aCoder encodeObject:_dateCreated forKey:NOTIFICATION_DATE_CREATED_PARAM];
    [aCoder encodeObject:_advertId forKey:NOTIFICATION_ADVERT_ID_PARAM];
    [aCoder encodeObject:_offerId forKey:NOTIFICATION_OFFER_ID_PARAM];
    [aCoder encodeInt:_type forKey:NOTIFICATION_TYPE_PARAM];
}

@end
