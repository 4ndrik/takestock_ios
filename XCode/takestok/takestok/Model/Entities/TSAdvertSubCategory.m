//
//  TSAdvertSubCategory.m
//  takestok
//
//  Created by Artem on 9/9/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSAdvertSubCategory.h"

@implementation TSAdvertSubCategory

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    [self updateWithDic:dict];
    return self;
}

@end
