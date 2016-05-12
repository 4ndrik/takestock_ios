//
//  SortData.m
//  takestok
//
//  Created by Artem on 5/10/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "SortData.h"

@implementation SortData
@synthesize ident = _ident;
@synthesize title = _title;
@synthesize value = _value;


-(instancetype)initWith:(int)ident withTitle:(NSString*)title withValue:(NSString*)value{
    self = [super init];
    _ident = ident;
    _title = title;
    _value = value;
    return self;
}

+(NSArray*)getAll{
    static NSArray* sortDataArray = nil;
    static dispatch_once_t predicate;
    dispatch_once( &predicate, ^{
        NSMutableArray* tempSortData = [NSMutableArray array];
        SortData* sortData = [[SortData alloc] initWith:1 withTitle:@"Newest post" withValue:@"created_at"];
        [tempSortData addObject:sortData];
        
        sortData = [[SortData alloc] initWith:2 withTitle:@"Oldest post" withValue:@"-created_at"];
        [tempSortData addObject:sortData];
        
        sortData = [[SortData alloc] initWith:3 withTitle:@"Guide price (hight to low)" withValue:@"guide_price"];
        [tempSortData addObject:sortData];
        
        sortData = [[SortData alloc] initWith:4 withTitle:@"Guide price (low to hight)" withValue:@"-guide_price"];
        [tempSortData addObject:sortData];
        
        sortData = [[SortData alloc] initWith:5 withTitle:@"Soonest expiry date" withValue:@"expires_at"];
        [tempSortData addObject:sortData];
        
        sortData = [[SortData alloc] initWith:6 withTitle:@"Longest expiry date" withValue:@"-expires_at"];
        [tempSortData addObject:sortData];
        
        sortDataArray = [NSMutableArray arrayWithArray:tempSortData];
        
    } );
    return sortDataArray;
}

@end
