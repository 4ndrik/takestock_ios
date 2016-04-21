//
//  Advert+CoreDataProperties.h
//  takestok
//
//  Created by Artem on 4/21/16.
//  Copyright © 2016 Artem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Advert.h"

NS_ASSUME_NONNULL_BEGIN

@class Shipping;
@class Condition;

@interface Advert (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *adDescription;
@property (nonatomic) NSTimeInterval created;
@property (nonatomic) NSTimeInterval expires;
@property (nonatomic) float guidePrice;
@property (nullable, nonatomic, retain) NSString *location;
@property (nullable, nonatomic, retain) NSString *name;
@property (nonatomic) NSTimeInterval updated;
@property (nullable, nonatomic, retain) NSOrderedSet<Image *> *images;
@property (nullable, nonatomic, retain) Shipping *shipping;
@property (nullable, nonatomic, retain) Condition *condition;
@property (nullable, nonatomic, retain) Certification *certification;
@property (nullable, nonatomic, retain) NSManagedObject *sizeType;
@property (nullable, nonatomic, retain) NSManagedObject *category;
@property (nullable, nonatomic, retain) NSManagedObject *subCategory;

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

@end

NS_ASSUME_NONNULL_END
