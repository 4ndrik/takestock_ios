//
//  TSBaseDictionaryEntity.m
//  takestok
//
//  Created by Artem on 9/9/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSBaseEntity.h"

@implementation TSBaseEntity
@synthesize ident = _ident;

+ (instancetype)objectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    [self updateWithDic:dict];
    return self;
}

-(NSDictionary*)dictionaryRepresentation{
     NSAssert(NO, @"Must be overridden in subclasses");
    return nil;
}

+(NSNumber*)identFromDic:(NSDictionary*)jsonDic{
    NSAssert(NO, @"Must be overridden in subclasses");
    return nil;
}

-(void)updateWithDic:(NSDictionary*)jsonDic{
    NSAssert(NO, @"Must be overridden in subclasses");
}

@end
