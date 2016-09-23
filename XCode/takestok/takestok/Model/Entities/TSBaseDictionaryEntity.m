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
@synthesize title = _title;

-(void)updateWithDic:(NSDictionary*)jsonDic{
    _ident = [TSBaseDictionaryEntity identFromDic:jsonDic];
    _title = [jsonDic allValues].firstObject;
}

+(NSNumber*)identFromDic:(NSDictionary*)jsonDic{
    id ident = [jsonDic allKeys].firstObject;
    return [NSNumber numberWithInt:[ident intValue]];
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
