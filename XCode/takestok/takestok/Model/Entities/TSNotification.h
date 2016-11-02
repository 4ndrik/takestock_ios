//
//  TSNotification.h
//  takestok
//
//  Created by Artem on 10/28/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSBaseEntity.h"

typedef enum {
    kGeneral = 0,
    kSelling = 1,
    kBuying = 2,
    kQuestion = 3
} NotificationType;

@interface TSNotification : TSBaseEntity<NSCoding>{
    NSString* _notId;
    NSString* _title;
    NSString* _text;
    NSDate* _dateCreated;
    NSNumber* _advertId;
    NSNumber* _offerId;
    NotificationType _type;
}

@property (readonly) NSString* notId;
@property (readonly) NotificationType type;
@property (readonly) NSString* title;
@property (readonly) NSString* text;
@property (readonly) NSDate* dateCreated;
@property (readonly) NSNumber* advertId;
@property (readonly) NSNumber* offerId;

+ (instancetype)objectWithDictionary:(NSDictionary *)dict;

@end
