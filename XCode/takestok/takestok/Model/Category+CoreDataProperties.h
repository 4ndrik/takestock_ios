//
//  Category+CoreDataProperties.h
//  takestok
//
//  Created by Artem on 5/26/16.
//  Copyright © 2016 Artem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Category.h"

NS_ASSUME_NONNULL_BEGIN

@interface Category (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nonatomic) int32_t ident;
@property (nullable, nonatomic, retain) NSSet<Advert *> *adverts;
@property (nullable, nonatomic, retain) NSSet<SubCategory *> *subCategories;

@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addAdvertsObject:(Advert *)value;
- (void)removeAdvertsObject:(Advert *)value;
- (void)addAdverts:(NSSet<Advert *> *)values;
- (void)removeAdverts:(NSSet<Advert *> *)values;

- (void)addSubCategoriesObject:(SubCategory *)value;
- (void)removeSubCategoriesObject:(SubCategory *)value;
- (void)addSubCategories:(NSSet<SubCategory *> *)values;
- (void)removeSubCategories:(NSSet<SubCategory *> *)values;

@end

NS_ASSUME_NONNULL_END
