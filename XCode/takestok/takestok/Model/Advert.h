//
//  Advert.h
//  takestok
//
//  Created by Artem on 4/14/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseEntity.h"
#import "Image.h"
#import "Category.h"
#import "Condition.h"
#import "Shipping.h"
#import "SizeType.h"
#import "Certification.h"
#import "User.h"
#import "Packaging.h"


#define ADVERT_ID_PARAM                    @"id"
#define ADVERT_NAME_PARAM                  @"name"
#define ADVERT_CREATED_PARAM               @"created_at"
#define ADVERT_EXPIRES_PARAM               @"expires_at"
#define ADVERT_UPDATED_AT                  @"updated_at"
#define ADVERT_GUIDE_PRICE_PARAM           @"guide_price"
#define ADVERT_DESCRIPTION_PARAM           @"description"
#define ADVERT_LOCATION_PARAM              @"location"
#define ADVERT_MAIN_ORDER_QUANTITY_PARAM   @"min_order_quantity"
#define ADVERT_ITEMS_COUNT_PARAM           @"items_count"
#define ADVERT_CERTIFICARIONS_EXTRA_PARAM  @"certification_extra"
#define ADVERT_SIZE_PARAM                  @"size"
#define ADVERT_TAGS_PARAM                  @"tags"
#define ADVERT_SHIPPING_PARAM              @"shipping"
#define ADVERT_CATEGORY_PARAM              @"category"
#define ADVERT_SUBCATEGORY_PARAM           @"subcategory"
#define ADVERT_CERTIFICATIONS_PARAM        @"certification"
#define ADVERT_CONDITION_PARAM             @"condition"
#define ADVERT_AUTHOR_PARAM                @"author"
#define ADVERT_AUTHOR_DETAILS_PARAM        @"author_detailed"
#define ADVERT_PHOTOS_PARAM                @"photos"
#define ADVERT_PACKAGING_PARAM             @"packaging"

#define PHOTOS_HEIGHT_PARAM         @"height"
#define PHOTOS_WIDTH_PARAM          @"width"
#define PHOTOS_IMAGE_PARAM          @"image"
#define PHOTOS_IS_MAIN_PARAM        @"is_main"

NS_ASSUME_NONNULL_BEGIN

@interface Advert : BaseEntity

+(NSArray*)getMyAdverts;
+(NSArray*)getAdvertsForMe;

@end

NS_ASSUME_NONNULL_END

#import "Advert+CoreDataProperties.h"
