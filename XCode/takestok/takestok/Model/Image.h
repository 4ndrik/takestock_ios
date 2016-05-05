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

@class User;
@class Advert;
@class Certification;
NS_ASSUME_NONNULL_BEGIN

@interface Image : BaseEntity<ImageProtocol>



@end

NS_ASSUME_NONNULL_END

#import "Image+CoreDataProperties.h"
