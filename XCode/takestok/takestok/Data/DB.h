//
//  DB.h
//  takestok
//
//  Created by Artem on 4/14/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface TempManagedObjectContext : NSManagedObjectContext

@end

@interface DB : NSObject{
//    NSManagedObjectContext *_managedObjectContext;
    NSManagedObjectModel *_managedObjectModel;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
    NSManagedObjectContext *_storedManagedObjectContext;
}

+(DB*)sharedInstance;

@property (readonly) NSManagedObjectContext *storedManagedObjectContext;
@property (readonly) TempManagedObjectContext *tempManagedObjectContext;

@end
