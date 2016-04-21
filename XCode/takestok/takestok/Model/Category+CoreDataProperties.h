//
//  Categoriy+CoreDataProperties.h
//  takestok
//
//  Created by Artem on 4/21/16.
//  Copyright © 2016 Artem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Category.h"

NS_ASSUME_NONNULL_BEGIN

@interface Category (CoreDataProperties)

@property (nullable, nonatomic, retain) Advert *advert;
@property (nullable, nonatomic, retain) Advert *advertSub;

@end

NS_ASSUME_NONNULL_END
