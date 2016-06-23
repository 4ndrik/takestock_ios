//
//  SubBusinessType+CoreDataProperties.h
//  takestok
//
//  Created by Artem on 6/22/16.
//  Copyright © 2016 Artem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SubBusinessType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SubBusinessType (CoreDataProperties)

@property (nonatomic) int32_t ident;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) BusinessType *businessType;
@property (nullable, nonatomic, retain) NSSet<User *> *user;

@end

@interface SubBusinessType (CoreDataGeneratedAccessors)

- (void)addUserObject:(User *)value;
- (void)removeUserObject:(User *)value;
- (void)addUser:(NSSet<User *> *)values;
- (void)removeUser:(NSSet<User *> *)values;

@end

NS_ASSUME_NONNULL_END
