//
//  NSManagedObject+NSManagedObject_RevertChanges.h
//  takestok
//
//  Created by Artem on 5/31/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (NSManagedObject_RevertChanges)

- (void) revertChanges;

@end
