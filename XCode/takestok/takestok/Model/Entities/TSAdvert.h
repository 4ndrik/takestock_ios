//
//  TSAdvert.h
//  takestok
//
//  Created by Artem on 9/12/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSBaseEntity.h"
#import "TSAdvertShipping.h"
#import "TSAdvertCategory.h"
#import "TSAdvertSubCategory.h"
#import "TSAdvertPackagingType.h"
#import "TSAdvertCertification.h"
#import "TSAdvertCondition.h"
#import "TSAdvertState.h"
#import "TSUserEntity.h"

@interface TSAdvert : TSBaseEntity

@property (readonly, nonatomic, retain) NSString *name;
@property (readonly, nonatomic, retain) NSDate* dateCreated;
@property (readonly, nonatomic, retain) NSDate* dateExpires;
@property (readonly, nonatomic, retain) NSDate* dateUpdated;
@property (readonly, nonatomic, assign) float guidePrice;
@property (readonly, nonatomic, retain) NSString *adDescription;
@property (readonly, nonatomic, retain) NSString *location;
@property (readonly, nonatomic, retain) TSAdvertShipping *shipping;
@property (readonly, nonatomic, assign) BOOL isVatExtempt;
@property (readonly, nonatomic, retain) NSArray* photos;
@property (readonly, nonatomic, retain) TSUserEntity* author;
@property (readonly, nonatomic, retain) TSAdvertCategory* category;
@property (readonly, nonatomic, retain) TSAdvertSubCategory* subCategory;
@property (readonly, nonatomic, retain) TSAdvertPackagingType *packaging;
@property (readonly, nonatomic, assign) int minOrderQuantity;
@property (readonly, nonatomic, retain) NSString *size;
@property (readonly, nonatomic, retain) NSString *certificationOther;
@property (readonly, nonatomic, retain) TSAdvertCertification* certification;
@property (readonly, nonatomic, retain) TSAdvertCondition *condition;
@property (readonly, nonatomic, assign) int count;
@property (readonly, nonatomic, assign) int countNow;
@property (readonly, nonatomic, retain) NSString *tags;
@property (readonly, nonatomic, assign)int newOffersCount;
@property (readonly, nonatomic, assign) int offersCount;
@property (readonly, nonatomic, assign)int newQuestionsCount;
@property (readonly, nonatomic, assign) int questionCount;
@property (readonly, nonatomic, assign) BOOL isInDrafts;
@property (readonly, nonatomic, assign) BOOL canOffer;
@property (readonly, nonatomic, assign) int notifications;
@property (readonly, nonatomic, retain) TSAdvertState* state;

@end