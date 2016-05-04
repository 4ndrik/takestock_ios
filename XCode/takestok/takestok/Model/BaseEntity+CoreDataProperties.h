//
//  BaseEntity+CoreDataProperties.h
//  takestok
//
//  Created by Artem on 4/28/16.
//  Copyright © 2016 Artem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BaseEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseEntity (CoreDataProperties)

@property (nonatomic) int32_t ident;

@end

NS_ASSUME_NONNULL_END
