//
//  Image.h
//  takestok
//
//  Created by Artem on 4/14/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseEntity.h"
#import "ImageProtocol.h"

#define IMAGE_ID_PARAM             @"id"
#define IMAGE_HEIGHT_PARAM         @"height"
#define IMAGE_WIDTH_PARAM          @"width"
#define IAMGE_IMAGE_PARAM          @"image"
#define IMAGE_IS_MAIN_PARAM        @"is_main"

@class User;
@class Advert;
@class Certification;
NS_ASSUME_NONNULL_BEGIN

@interface Image : BaseEntity<ImageProtocol>

+(instancetype)getImageWithResId:(NSString*)resId;

@end

NS_ASSUME_NONNULL_END

#import "Image+CoreDataProperties.h"
