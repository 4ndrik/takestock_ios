//
//  SubCategory.h
//  takestok
//
//  Created by Artem on 5/5/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dictionary.h"

@class Advert, Category;

NS_ASSUME_NONNULL_BEGIN

@interface SubCategory : Dictionary

+(NSArray*)getForParent:(int)parentId;

@end

NS_ASSUME_NONNULL_END

#import "SubCategory+CoreDataProperties.h"
