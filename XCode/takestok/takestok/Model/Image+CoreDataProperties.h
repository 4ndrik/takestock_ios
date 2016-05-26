//
//  Image+CoreDataProperties.h
//  takestok
//
//  Created by Artem on 5/26/16.
//  Copyright © 2016 Artem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Image.h"

NS_ASSUME_NONNULL_BEGIN

@interface Image (CoreDataProperties)

@property (nonatomic) int32_t height;
@property (nonatomic) int32_t ident;
@property (nullable, nonatomic, retain) NSString *resId;
@property (nullable, nonatomic, retain) NSString *url;
@property (nonatomic) int32_t width;
@property (nullable, nonatomic, retain) Advert *advert;
@property (nullable, nonatomic, retain) Certification *certification;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
