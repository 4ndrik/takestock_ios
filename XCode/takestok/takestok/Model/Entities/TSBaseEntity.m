//
//  TSBaseDictionaryEntity.m
//  takestok
//
//  Created by Artem on 9/9/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSBaseEntity.h"

@implementation TSBaseEntity

+ (instancetype)objectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    NSAssert(YES, @"Must be overridden in subclasses");
    return nil;
}

-(NSDictionary*)dictionaryRepresentation{
     NSAssert(YES, @"Must be overridden in subclasses");
    return nil;
}

@end
