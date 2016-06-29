//
//  Advert+CoreDataProperties.h
//  takestok
//
//  Created by Artem on 5/26/16.
//  Copyright © 2016 Artem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Advert.h"

NS_ASSUME_NONNULL_BEGIN

@interface Advert (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *adDescription;
@property (nullable, nonatomic, retain) NSString *certificationOther;
@property (nonatomic) int32_t count;
@property (nonatomic) NSTimeInterval created;
@property (nonatomic) NSTimeInterval expires;
@property (nonatomic) float guidePrice;
@property (nonatomic) int32_t ident;
@property (nullable, nonatomic, retain) NSString *location;
@property (nonatomic) int32_t minOrderQuantity;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *size;
@property (nullable, nonatomic, retain) NSString *tags;
@property (nonatomic) NSTimeInterval date_updated;
@property (nullable, nonatomic, retain) User *author;
@property (nullable, nonatomic, retain) Category *category;
@property (nullable, nonatomic, retain) Certification *certification;
@property (nullable, nonatomic, retain) Condition *condition;
@property (nullable, nonatomic, retain) NSOrderedSet<Image *> *images;
@property (nullable, nonatomic, retain) NSSet<Offer *> *offers;
@property (nullable, nonatomic, retain) Packaging *packaging;
@property (nullable, nonatomic, retain) NSSet<Question *> *questions;
@property (nullable, nonatomic, retain) Shipping *shipping;
@property (nullable, nonatomic, retain) SizeType *sizeType;
@property (nullable, nonatomic, retain) SubCategory *subCategory;
@property (nonatomic) BOOL inWatchList;


@end

@interface Advert (CoreDataGeneratedAccessors)

- (void)insertObject:(Image *)value inImagesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromImagesAtIndex:(NSUInteger)idx;
- (void)insertImages:(NSArray<Image *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeImagesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInImagesAtIndex:(NSUInteger)idx withObject:(Image *)value;
- (void)replaceImagesAtIndexes:(NSIndexSet *)indexes withImages:(NSArray<Image *> *)values;
- (void)addImagesObject:(Image *)value;
- (void)removeImagesObject:(Image *)value;
- (void)addImages:(NSOrderedSet<Image *> *)values;
- (void)removeImages:(NSOrderedSet<Image *> *)values;

- (void)addOffersObject:(Offer *)value;
- (void)removeOffersObject:(Offer *)value;
- (void)addOffers:(NSSet<Offer *> *)values;
- (void)removeOffers:(NSSet<Offer *> *)values;

- (void)addQuestionsObject:(Question *)value;
- (void)removeQuestionsObject:(Question *)value;
- (void)addQuestions:(NSSet<Question *> *)values;
- (void)removeQuestions:(NSSet<Question *> *)values;

@end

NS_ASSUME_NONNULL_END
