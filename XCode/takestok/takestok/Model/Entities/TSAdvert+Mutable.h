//
//  TSAdvert+Mutable.h
//  takestok
//
//  Created by Artem on 9/20/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSAdvert.h"

@class TSImageEntity;

@interface TSAdvert (Mutable)

@property (readwrite, nonatomic, retain) NSString *name;
@property (readwrite, nonatomic, retain) NSDate* dateExpires;
@property (readwrite, nonatomic, assign) float guidePrice;
@property (readwrite, nonatomic, retain) NSString *adDescription;
@property (readwrite, nonatomic, retain) NSString *location;
@property (readwrite, nonatomic, retain) TSAdvertShipping *shipping;
@property (readwrite, nonatomic, assign) BOOL isVatExtempt;
@property (readwrite, nonatomic, retain) NSArray<TSImageEntity*> *photos;
@property (readwrite, nonatomic, retain) TSUserEntity* author;
@property (readwrite, nonatomic, retain) TSAdvertCategory* category;
@property (readwrite, nonatomic, retain) TSAdvertSubCategory* subCategory;
@property (readwrite, nonatomic, retain) TSAdvertPackagingType *packaging;
@property (readwrite, nonatomic, assign) int minOrderQuantity;
@property (readwrite, nonatomic, retain) NSString *size;
@property (readwrite, nonatomic, retain) NSString *certificationOther;
@property (readwrite, nonatomic, retain) TSAdvertCertification* certification;
@property (readwrite, nonatomic, retain) TSAdvertCondition *condition;
@property (readwrite, nonatomic, assign) int count;
@property (readwrite, nonatomic, retain) NSString *tags;
@property (readwrite, nonatomic, assign) BOOL isInDrafts;
@property (readwrite, nonatomic, retain) TSAdvertState* state;


@end
