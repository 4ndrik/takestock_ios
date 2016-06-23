//
//  SubBusinessType.m
//  takestok
//
//  Created by Artem on 6/22/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "SubBusinessType.h"
#import "User.h"

@implementation SubBusinessType

+ (NSString *)entityName {
    return @"SubBusinessType";
}

+(NSArray*)getForParent:(int)parentId{
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ident" ascending:YES];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"businessType.ident = %i", parentId];
    NSFetchRequest* request = [self getFetchRequestForPredicate:predicate withSortDescriptions:[NSArray arrayWithObjects:sortDescriptor, nil]];
    return [[DB sharedInstance].storedManagedObjectContext executeFetchRequest:request error:nil];
}

@end
