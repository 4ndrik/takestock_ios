//
//  SubCategory+CoreDataProperties.h
//  takestok
//
//  Created by Artem on 5/26/16.
//  Copyright © 2016 Artem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SubCategory.h"

NS_ASSUME_NONNULL_BEGIN

@interface SubCategory (CoreDataProperties)

@property (nonatomic) int32_t ident;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) Category *category;
@property (nullable, nonatomic, retain) NSSet<Advert *> *subAdverbs;

@end

@interface SubCategory (CoreDataGeneratedAccessors)

- (void)addSubAdverbsObject:(Advert *)value;
- (void)removeSubAdverbsObject:(Advert *)value;
- (void)addSubAdverbs:(NSSet<Advert *> *)values;
- (void)removeSubAdverbs:(NSSet<Advert *> *)values;

@end

NS_ASSUME_NONNULL_END
