//
//  NSManagedObject+NSManagedObject_RevertChanges.m
//  takestok
//
//  Created by Artem on 5/31/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "NSManagedObject+NSManagedObject_RevertChanges.h"

@implementation NSManagedObject (NSManagedObject_RevertChanges)

- (void) revertChanges {
    // Revert to original Values
    NSDictionary *changedValues = [self changedValues];
    NSDictionary *committedValues = [self committedValuesForKeys:[changedValues allKeys]];
    NSEnumerator *enumerator;
    id key;
    enumerator = [changedValues keyEnumerator];
    
    while ((key = [enumerator nextObject])) {
        NSLog(@"Reverting field ""%@"" from ""%@"" to ""%@""", key, [changedValues objectForKey:key], [committedValues objectForKey:key]);
        [self setValue:[committedValues objectForKey:key] forKey:key];
    }
}

@end
