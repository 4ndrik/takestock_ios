//
//  Categoriy.h
//  takestok
//
//  Created by Artem on 4/21/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dictionary.h"

@class Advert;

NS_ASSUME_NONNULL_BEGIN

@interface Category : Dictionary

+(NSArray*)getAllCategories;
+(NSArray*)getAllSubCategories;

@end

NS_ASSUME_NONNULL_END

#import "Category+CoreDataProperties.h"
