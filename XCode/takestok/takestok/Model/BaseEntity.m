//
//  BaseEntity.m
//  takestok
//
//  Created by Artem on 4/21/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BaseEntity.h"

@implementation BaseEntity

+ (NSString *)entityName {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

+ (instancetype)tempEntity {
    NSManagedObjectContext *context = [DB sharedInstance].tempManagedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:context];
    return [[self alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:[DB sharedInstance].tempManagedObjectContext];
}

+ (instancetype)storedEntity{
    NSManagedObjectContext *context = [DB sharedInstance].storedManagedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:context];
    return [[self alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:[DB sharedInstance].storedManagedObjectContext];
}

+(NSFetchRequest*)getFetchRequestForPredicate:(NSPredicate* _Nullable)predicate withSortDescriptions:(NSArray* _Nullable)sortDescriptors
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.includesSubentities = YES;
    [fetchRequest setEntity: [NSEntityDescription entityForName:[[self class] entityName] inManagedObjectContext:[DB sharedInstance].storedManagedObjectContext]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sortDescriptors];
    return fetchRequest;
}

+ (instancetype)getEntityWithId:(int)ident{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ident == %i", ident];
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ident" ascending:YES];
    NSFetchRequest* request = [self getFetchRequestForPredicate:predicate withSortDescriptions:[NSArray arrayWithObjects:sortDescriptor, nil]];
    return [[DB sharedInstance].storedManagedObjectContext executeFetchRequest:request error:nil].firstObject;
}

+(NSArray*)getAll{
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ident" ascending:YES];
    NSFetchRequest* request = [self getFetchRequestForPredicate:nil withSortDescriptions:[NSArray arrayWithObjects:sortDescriptor, nil]];
    return [[DB sharedInstance].storedManagedObjectContext executeFetchRequest:request error:nil];
}

-(BOOL)isForStore{
    return self.managedObjectContext == [DB sharedInstance].storedManagedObjectContext;
}

-(void)updateWithDic:(NSDictionary*)jsonDic{
    [self doesNotRecognizeSelector:_cmd];
}

-(NSDictionary*)getDictionary{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
