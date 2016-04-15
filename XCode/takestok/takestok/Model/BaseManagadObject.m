//
//  LODomainObject.m
//  takestok
//
//  Created by Artem on 4/14/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BaseManagadObject.h"

@implementation BaseManagadObject

+ (NSString *)entityName {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

+ (instancetype)disconnectedEntity {
    NSManagedObjectContext *context = [DB sharedInstance].managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:context];
    return [[self alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:nil];
}

+ (instancetype)entity{
    id entity = [self disconnectedEntity];
    [entity addToContext];
    return entity;
}

- (void)addToContext{
    [[DB sharedInstance].managedObjectContext insertObject:self];
}

+(NSFetchRequest*)getFetchRequestForPredicate:(NSPredicate*)predicate withSortDescriptions:(NSArray*)sortDescriptors
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.includesSubentities = YES;
    [fetchRequest setEntity: [NSEntityDescription entityForName:[[self class] entityName] inManagedObjectContext:[DB sharedInstance].managedObjectContext]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sortDescriptors];
    return fetchRequest;
}

@end
