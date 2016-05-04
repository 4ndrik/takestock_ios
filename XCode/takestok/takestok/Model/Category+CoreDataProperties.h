//
//  Category+CoreDataProperties.h
//  takestok
//
//  Created by Artem on 4/28/16.
//  Copyright © 2016 Artem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Category.h"

NS_ASSUME_NONNULL_BEGIN

@interface Category (CoreDataProperties)

@property (nullable, nonatomic, retain) NSSet<Advert *> *advert;
@property (nullable, nonatomic, retain) NSSet<Advert *> *advertSub;
@property (nullable, nonatomic, retain) NSSet<Category *> *subCategories;
@property (nullable, nonatomic, retain) Category *parentCategory;

@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addAdvertObject:(Advert *)value;
- (void)removeAdvertObject:(Advert *)value;
- (void)addAdvert:(NSSet<Advert *> *)values;
- (void)removeAdvert:(NSSet<Advert *> *)values;

- (void)addAdvertSubObject:(Advert *)value;
- (void)removeAdvertSubObject:(Advert *)value;
- (void)addAdvertSub:(NSSet<Advert *> *)values;
- (void)removeAdvertSub:(NSSet<Advert *> *)values;

- (void)addSubCategoriesObject:(Category *)value;
- (void)removeSubCategoriesObject:(Category *)value;
- (void)addSubCategories:(NSSet<Category *> *)values;
- (void)removeSubCategories:(NSSet<Category *> *)values;

@end

NS_ASSUME_NONNULL_END
