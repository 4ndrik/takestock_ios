//
//  Answer+CoreDataProperties.h
//  takestok
//
//  Created by Artem on 5/26/16.
//  Copyright © 2016 Artem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Answer.h"

NS_ASSUME_NONNULL_BEGIN

@interface Answer (CoreDataProperties)

@property (nonatomic) NSTimeInterval created;
@property (nonatomic) int32_t ident;
@property (nullable, nonatomic, retain) NSString *message;
@property (nullable, nonatomic, retain) Question *question;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
