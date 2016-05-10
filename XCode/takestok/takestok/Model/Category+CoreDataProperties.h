//
//  Category+CoreDataProperties.h
//  takestok
//
//  Created by Artem on 5/5/16.
//  Copyright © 2016 Artem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Category.h"

NS_ASSUME_NONNULL_BEGIN

@interface Category (CoreDataProperties)

@property (nullable, nonatomic, retain) NSSet<Advert *> *advert;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *subCategories;

@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addAdvertObject:(Advert *)value;
- (void)removeAdvertObject:(Advert *)value;
- (void)addAdvert:(NSSet<Advert *> *)values;
- (void)removeAdvert:(NSSet<Advert *> *)values;

- (void)addSubCategoriesObject:(NSManagedObject *)value;
- (void)removeSubCategoriesObject:(NSManagedObject *)value;
- (void)addSubCategories:(NSSet<NSManagedObject *> *)values;
- (void)removeSubCategories:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
