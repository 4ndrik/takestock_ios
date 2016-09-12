//
//  TSAdvertState.m
//  takestok
//
//  Created by Artem on 9/9/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSAdvertState.h"

#define STATE_ID_PARAM                  @"pk"
#define STATE_NAME_PARAM                @"name"

@implementation TSAdvertState

-(void)updateWithDic:(NSDictionary*)dict{
    _ident = [TSAdvertState identFromDic:dict];
    _title = [dict objectForKeyNotNull:STATE_NAME_PARAM];
}

+(NSNumber*)identFromDic:(NSDictionary*)dict{
    return [dict objectForKeyNotNull:STATE_ID_PARAM];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    _ident = [aDecoder decodeObjectForKey:STATE_ID_PARAM];
    _title = [aDecoder decodeObjectForKey:STATE_NAME_PARAM];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_ident forKey:STATE_ID_PARAM];
    [aCoder encodeObject:_title forKey:STATE_NAME_PARAM];
}

@end
