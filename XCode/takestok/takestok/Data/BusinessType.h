//
//  BusinessType.h
//  takestok
//
//  Created by Artem on 6/22/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Dictionary.h"

#define BT_ID_PARAM               @"id"
#define BT_NAME_PARAM             @"name"
#define BT_SUBTYPE_PARAM          @"sub"

@class SubBusinessType, User;

NS_ASSUME_NONNULL_BEGIN

@interface BusinessType : Dictionary

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "BusinessType+CoreDataProperties.h"
