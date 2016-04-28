//
//  Category+CoreDataProperties.h
//  takestok
//
//  Created by Artem on 4/27/16.
//  Copyright © 2016 Artem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Category.h"

NS_ASSUME_NONNULL_BEGIN

@interface Category (CoreDataProperties)

@property (nullable, nonatomic, retain) Advert *advert;
@property (nullable, nonatomic, retain) Advert *advertSub;
@property (nullable, nonatomic, retain) NSSet<Category *> *subCategories;
@property (nullable, nonatomic, retain) Category *parentCategory;

@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addSubCategoriesObject:(Category *)value;
- (void)removeSubCategoriesObject:(Category *)value;
- (void)addSubCategories:(NSSet<Category *> *)values;
- (void)removeSubCategories:(NSSet<Category *> *)values;

@end

NS_ASSUME_NONNULL_END
