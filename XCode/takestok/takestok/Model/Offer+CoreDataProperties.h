//
//  Offer+CoreDataProperties.h
//  takestok
//
//  Created by Artem on 5/26/16.
//  Copyright © 2016 Artem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Offer.h"

NS_ASSUME_NONNULL_BEGIN

@interface Offer (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *comment;
@property (nonatomic) NSTimeInterval created;
@property (nonatomic) int32_t ident;
@property (nonatomic) double price;
@property (nonatomic) int32_t quantity;
@property (nonatomic) NSTimeInterval date_updated;
@property (nullable, nonatomic, retain) Advert *advert;
@property (nullable, nonatomic, retain) Offer *counterOffer;
@property (nullable, nonatomic, retain) Offer *parentOffer;
@property (nullable, nonatomic, retain) OfferStatus *status;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
