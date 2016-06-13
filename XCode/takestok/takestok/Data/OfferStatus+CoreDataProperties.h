//
//  OfferStatus+CoreDataProperties.h
//  takestok
//
//  Created by Artem on 5/26/16.
//  Copyright © 2016 Artem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "OfferStatus.h"

NS_ASSUME_NONNULL_BEGIN

@interface OfferStatus (CoreDataProperties)

@property (nonatomic) int32_t ident;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSSet<Offer *> *offers;

@end

@interface OfferStatus (CoreDataGeneratedAccessors)

- (void)addOffersObject:(Offer *)value;
- (void)removeOffersObject:(Offer *)value;
- (void)addOffers:(NSSet<Offer *> *)values;
- (void)removeOffers:(NSSet<Offer *> *)values;

@end

NS_ASSUME_NONNULL_END
