//
//  LODomainObject.h
//  takestok
//
//  Created by Artem on 4/14/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "DB.h"

@interface BaseManagadObject : NSManagedObject

+ (NSString *)entityName;
+ (instancetype)disconnectedEntity;
+ (instancetype)entity;
- (void)addToContext;

+(NSFetchRequest*)getFetchRequestForPredicate:(NSPredicate*)predicate withSortDescriptions:(NSArray*)sortDescriptors;

@end
