//
//  SubBusinessType.h
//  takestok
//
//  Created by Artem on 6/22/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Dictionary.h"

@class User, BusinessType;

NS_ASSUME_NONNULL_BEGIN

@interface SubBusinessType : Dictionary

+(NSArray*)getForParent:(int)parentId;

@end

NS_ASSUME_NONNULL_END

#import "SubBusinessType+CoreDataProperties.h"
