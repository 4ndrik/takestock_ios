//
//  Shipping+CoreDataProperties.h
//  takestok
//
//  Created by Artem on 4/21/16.
//  Copyright © 2016 Artem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Shipping.h"

NS_ASSUME_NONNULL_BEGIN

@class Advert;

@interface Shipping (CoreDataProperties)

@property (nullable, nonatomic, retain) Advert *advert;

@end

NS_ASSUME_NONNULL_END
