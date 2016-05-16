//
//  User+CoreDataProperties.h
//  takestok
//
//  Created by Artem on 5/16/16.
//  Copyright © 2016 Artem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nonatomic) BOOL isSubscribed;
@property (nonatomic) BOOL isVerified;
@property (nonatomic) NSTimeInterval lastLogin;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nonatomic) float rating;
@property (nullable, nonatomic, retain) NSString *userName;
@property (nullable, nonatomic, retain) NSSet<Advert *> *adverts;
@property (nullable, nonatomic, retain) Image *image;
@property (nullable, nonatomic, retain) NSSet<Offer *> *offers;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *questions;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *answers;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addAdvertsObject:(Advert *)value;
- (void)removeAdvertsObject:(Advert *)value;
- (void)addAdverts:(NSSet<Advert *> *)values;
- (void)removeAdverts:(NSSet<Advert *> *)values;

- (void)addOffersObject:(Offer *)value;
- (void)removeOffersObject:(Offer *)value;
- (void)addOffers:(NSSet<Offer *> *)values;
- (void)removeOffers:(NSSet<Offer *> *)values;

- (void)addQuestionsObject:(NSManagedObject *)value;
- (void)removeQuestionsObject:(NSManagedObject *)value;
- (void)addQuestions:(NSSet<NSManagedObject *> *)values;
- (void)removeQuestions:(NSSet<NSManagedObject *> *)values;

- (void)addAnswersObject:(NSManagedObject *)value;
- (void)removeAnswersObject:(NSManagedObject *)value;
- (void)addAnswers:(NSSet<NSManagedObject *> *)values;
- (void)removeAnswers:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
