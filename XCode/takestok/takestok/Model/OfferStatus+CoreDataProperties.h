//
//  OfferStatus+CoreDataProperties.h
//  takestok
//
//  Created by Artem on 5/13/16.
//  Copyright © 2016 Artem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "OfferStatus.h"

NS_ASSUME_NONNULL_BEGIN

@interface OfferStatus (CoreDataProperties)

@property (nullable, nonatomic, retain) NSSet<Offer *> *offer;

@end

@interface OfferStatus (CoreDataGeneratedAccessors)

- (void)addOfferObject:(Offer *)value;
- (void)removeOfferObject:(Offer *)value;
- (void)addOffer:(NSSet<Offer *> *)values;
- (void)removeOffer:(NSSet<Offer *> *)values;

@end

NS_ASSUME_NONNULL_END
