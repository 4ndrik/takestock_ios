//
//  Packaging.h
//  takestok
//
//  Created by Artem on 5/11/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dictionary.h"

@class Advert;

#define PACKAGING_ID_PARAM               @"id"
#define PACKAGING_NAME_PARAM             @"name"

NS_ASSUME_NONNULL_BEGIN

@interface Packaging : Dictionary

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Packaging+CoreDataProperties.h"
