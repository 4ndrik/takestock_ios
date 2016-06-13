//
//  User+CoreDataProperties.h
//  takestok
//
//  Created by Artem on 5/26/16.
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
@property (nonatomic) int32_t ident;
@property (nonatomic) BOOL isSubscribed;
@property (nonatomic) BOOL isVerified;
@property (nonatomic) NSTimeInterval lastLogin;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nonatomic) float rating;
@property (nullable, nonatomic, retain) NSString *userName;
@property (nullable, nonatomic, retain) NSSet<Advert *> *adverts;
@property (nullable, nonatomic, retain) NSSet<Answer *> *answers;
@property (nullable, nonatomic, retain) Image *image;
@property (nullable, nonatomic, retain) NSSet<Offer *> *offers;
@property (nullable, nonatomic, retain) NSSet<Question *> *questions;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addAdvertsObject:(Advert *)value;
- (void)removeAdvertsObject:(Advert *)value;
- (void)addAdverts:(NSSet<Advert *> *)values;
- (void)removeAdverts:(NSSet<Advert *> *)values;

- (void)addAnswersObject:(Answer *)value;
- (void)removeAnswersObject:(Answer *)value;
- (void)addAnswers:(NSSet<Answer *> *)values;
- (void)removeAnswers:(NSSet<Answer *> *)values;

- (void)addOffersObject:(Offer *)value;
- (void)removeOffersObject:(Offer *)value;
- (void)addOffers:(NSSet<Offer *> *)values;
- (void)removeOffers:(NSSet<Offer *> *)values;

- (void)addQuestionsObject:(Question *)value;
- (void)removeQuestionsObject:(Question *)value;
- (void)addQuestions:(NSSet<Question *> *)values;
- (void)removeQuestions:(NSSet<Question *> *)values;

@end

NS_ASSUME_NONNULL_END
