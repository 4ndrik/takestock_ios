//
//  BaseEntity.h
//  takestok
//
//  Created by Artem on 4/21/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DB.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseEntity : NSManagedObject

+ (NSString *)entityName;
+ (instancetype)tempEntity;
+ (instancetype)storedEntity;
+ (instancetype)getEntityWithId:(int)ident;
+(NSArray*)getAll;
+(NSFetchRequest*)getFetchRequestForPredicate:(NSPredicate* _Nullable)predicate withSortDescriptions:(NSArray* _Nullable)sortDescriptors;

-(void)updateWithDic:(NSDictionary*)jsonDic;
-(NSDictionary*)getDictionary;

-(BOOL)isForStore;

@end

NS_ASSUME_NONNULL_END

#import "BaseEntity+CoreDataProperties.h"
