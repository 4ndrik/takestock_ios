//
//  Shipping+CoreDataProperties.h
//  takestok
//
//  Created by Artem on 5/16/16.
//  Copyright © 2016 Artem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Shipping.h"

NS_ASSUME_NONNULL_BEGIN

@interface Shipping (CoreDataProperties)

@property (nullable, nonatomic, retain) NSSet<Advert *> *adverts;

@end

@interface Shipping (CoreDataGeneratedAccessors)

- (void)addAdvertsObject:(Advert *)value;
- (void)removeAdvertsObject:(Advert *)value;
- (void)addAdverts:(NSSet<Advert *> *)values;
- (void)removeAdverts:(NSSet<Advert *> *)values;

@end

NS_ASSUME_NONNULL_END
