//
//  User+CoreDataProperties.h
//  takestok
//
//  Created by Artem on 5/4/16.
//  Copyright © 2016 Artem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *userName;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSString *email;
@property (nonatomic) BOOL isVerified;
@property (nonatomic) float rating;
@property (nonatomic) NSTimeInterval lastLogin;
@property (nonatomic) BOOL isSubscribed;
@property (nullable, nonatomic, retain) NSSet<Advert *> *advert;
@property (nullable, nonatomic, retain) Image *image;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addAdvertObject:(Advert *)value;
- (void)removeAdvertObject:(Advert *)value;
- (void)addAdvert:(NSSet<Advert *> *)values;
- (void)removeAdvert:(NSSet<Advert *> *)values;

@end

NS_ASSUME_NONNULL_END
