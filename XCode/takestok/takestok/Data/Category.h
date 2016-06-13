//
//  Categoriy.h
//  takestok
//
//  Created by Artem on 4/21/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dictionary.h"

#define CATEGORY_ID_PARAM               @"pk"
#define CATEGORY_NAME_PARAM             @"name"
#define CATEGORY_SUBCATEGORIES_PARAM    @"subcategories"


@class Advert;
@class SubCategory;

NS_ASSUME_NONNULL_BEGIN

@interface Category : Dictionary

@end

NS_ASSUME_NONNULL_END

#import "Category+CoreDataProperties.h"
