//
//  Advert.m
//  takestok
//
//  Created by Artem on 4/14/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "Advert.h"

@implementation Advert

+(NSArray*)getAll{
    NSFetchRequest* request = [self getFetchRequestForPredicate:nil withSortDescriptions:nil];
    return [[DB sharedInstance].managedObjectContext executeFetchRequest:request error:nil];
}

+ (NSString *)entityName {
    return @"Advert";
}

@end
