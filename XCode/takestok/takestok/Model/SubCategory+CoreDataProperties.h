//
//  SubCategory+CoreDataProperties.h
//  takestok
//
//  Created by Artem on 5/5/16.
//  Copyright © 2016 Artem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SubCategory.h"

NS_ASSUME_NONNULL_BEGIN

@interface SubCategory (CoreDataProperties)

@property (nullable, nonatomic, retain) NSSet<Advert *> *subAdverb;
@property (nullable, nonatomic, retain) Category *category;

@end

@interface SubCategory (CoreDataGeneratedAccessors)

- (void)addSubAdverbObject:(Advert *)value;
- (void)removeSubAdverbObject:(Advert *)value;
- (void)addSubAdverb:(NSSet<Advert *> *)values;
- (void)removeSubAdverb:(NSSet<Advert *> *)values;

@end

NS_ASSUME_NONNULL_END
