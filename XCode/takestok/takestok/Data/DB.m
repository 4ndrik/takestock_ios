//
//  DB.m
//  takestok
//
//  Created by Artem on 4/14/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "DB.h"

@implementation TempManagedObjectContext

- (BOOL)save:(NSError **)error{
    NSAssert(YES, @"Save is forbidden");
    return NO;
}

@end

@implementation DB
@synthesize storedManagedObjectContext = _storedManagedObjectContext;
@synthesize tempManagedObjectContext = _tempManagedObjectContext;

+(DB*)sharedInstance
{
    static DB* singleton = nil;
    static dispatch_once_t predicate;
    dispatch_once( &predicate, ^{
        singleton = [[ self alloc ] init];
    } );
    return singleton;
}

-(id) init
{
    self = [super init];
    return self;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)storedManagedObjectContext
{
    if (_storedManagedObjectContext != nil) {
        return _storedManagedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _storedManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_storedManagedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _storedManagedObjectContext;
}

-(TempManagedObjectContext*)tempManagedObjectContext{
    if (_tempManagedObjectContext != nil) {
        return _tempManagedObjectContext;
    }
    
    _tempManagedObjectContext = [[TempManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//    [_tempManagedObjectContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
    _tempManagedObjectContext.parentContext = self.storedManagedObjectContext;
    
    return _tempManagedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DB.sqlite"];
    
    NSError *error = nil;
    NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption : @(YES),
                               NSInferMappingModelAutomaticallyOption : @(YES) };
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

@end