//
//  TSAdvertSubCategory.m
//  takestok
//
//  Created by Artem on 9/9/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSAdvertSubCategory.h"

#define SUBCATEGORY_PARENT_ID_PARAM               @"parent_id"
#define SUBCATEGORY_ID_PARAM                      @"pk"
#define SUBCATEGORY_NAME_PARAM                    @"name"

@implementation TSAdvertSubCategory

-(instancetype)initWithParentIdent:(NSNumber*)parentIdent{
    self = [super init];
    _parentIdent = parentIdent;
    return self;
}

-(void)updateWithDic:(NSDictionary*)dict{
    _ident = [TSAdvertSubCategory identFromDic:dict];
    _title = [dict objectForKeyNotNull:SUBCATEGORY_NAME_PARAM];
}

+(NSNumber*)identFromDic:(NSDictionary*)dict{
    return [dict objectForKeyNotNull:SUBCATEGORY_ID_PARAM];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    _parentIdent = [aDecoder decodeObjectForKey:SUBCATEGORY_PARENT_ID_PARAM];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_parentIdent forKey:SUBCATEGORY_PARENT_ID_PARAM];
}

@end
