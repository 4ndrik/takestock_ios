//
//  TSBaseDictionaryEntity.m
//  takestok
//
//  Created by Artem on 9/9/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSBaseDictionaryEntity.h"

#define DICTIONARY_ID_PARAM               @"id"
#define DICTIONARY_NAME_PARAM             @"name"

@implementation TSBaseDictionaryEntity
@synthesize ident = _ident, title = _title;

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    [self updateWithDic:dict];
    return self;
}

-(void)updateWithDic:(NSDictionary*)jsonDic{
    _ident = [TSBaseDictionaryEntity identFromDic:jsonDic];
    _title = [jsonDic allValues].firstObject;
}

+(NSNumber*)identFromDic:(NSDictionary*)jsonDic{
    return [jsonDic allKeys].firstObject;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    _ident = [aDecoder decodeObjectForKey:DICTIONARY_ID_PARAM];
    _title = [aDecoder decodeObjectForKey:DICTIONARY_NAME_PARAM];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_ident forKey:DICTIONARY_ID_PARAM];
    [aCoder encodeObject:_title forKey:DICTIONARY_NAME_PARAM];
}

@end
