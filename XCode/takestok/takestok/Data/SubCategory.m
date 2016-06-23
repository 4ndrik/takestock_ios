//
//  SubCategory.m
//  takestok
//
//  Created by Artem on 5/5/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "SubCategory.h"
#import "Advert.h"
#import "Category.h"

@implementation SubCategory

+ (NSString *)entityName {
    return @"SubCategory";
}

+(NSArray*)getForParent:(int)parentId{
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ident" ascending:YES];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"category.ident = %i", parentId];
    NSFetchRequest* request = [self getFetchRequestForPredicate:predicate withSortDescriptions:[NSArray arrayWithObjects:sortDescriptor, nil]];
    return [[DB sharedInstance].storedManagedObjectContext executeFetchRequest:request error:nil];
}

@end
