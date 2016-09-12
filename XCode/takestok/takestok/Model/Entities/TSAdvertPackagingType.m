//
//  TSAdvertPackagingType.m
//  takestok
//
//  Created by Artem on 9/12/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSAdvertPackagingType.h"

#define PACKAGE_ID_PARAM               @"id"
#define PACKAGE_NAME_PARAM             @"name"

@implementation TSAdvertPackagingType

-(void)updateWithDic:(NSDictionary*)jsonDic{
    _ident = [TSAdvertPackagingType identFromDic:jsonDic];
    _title = [jsonDic objectForKeyNotNull:PACKAGE_NAME_PARAM];
}

+(NSNumber*)identFromDic:(NSDictionary*)jsonDic{
    return [jsonDic objectForKeyNotNull:PACKAGE_ID_PARAM];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    _ident = [aDecoder decodeObjectForKey:PACKAGE_ID_PARAM];
    _title = [aDecoder decodeObjectForKey:PACKAGE_NAME_PARAM];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_ident forKey:PACKAGE_ID_PARAM];
    [aCoder encodeObject:_title forKey:PACKAGE_NAME_PARAM];
}

@end
