//
//  Certification+CoreDataProperties.h
//  takestok
//
//  Created by Artem on 4/21/16.
//  Copyright © 2016 Artem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Certification.h"

NS_ASSUME_NONNULL_BEGIN

@interface Certification (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *certDescription;
@property (nullable, nonatomic, retain) Image *image;
@property (nullable, nonatomic, retain) Advert *advert;

@end

NS_ASSUME_NONNULL_END
