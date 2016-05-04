//
//  Shipping+CoreDataProperties.h
//  takestok
//
//  Created by Artem on 4/28/16.
//  Copyright © 2016 Artem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Shipping.h"

NS_ASSUME_NONNULL_BEGIN

@interface Shipping (CoreDataProperties)

@property (nullable, nonatomic, retain) NSSet<Advert *> *advert;

@end

@interface Shipping (CoreDataGeneratedAccessors)

- (void)addAdvertObject:(Advert *)value;
- (void)removeAdvertObject:(Advert *)value;
- (void)addAdvert:(NSSet<Advert *> *)values;
- (void)removeAdvert:(NSSet<Advert *> *)values;

@end

NS_ASSUME_NONNULL_END
