//
//  TSAdvertCategory.m
//  takestok
//
//  Created by Artem on 9/9/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSAdvertCategory.h"
#import "TSAdvertSubCategory.h"

#define CATEGORY_ID_PARAM               @"id"
#define CATEGORY_NAME_PARAM             @"name"
#define CATEGORY_ISFOOD_PARAM           @"is_food"
#define CATEGORY_SUBCATEGORY_PARAM      @"subcategories"

@implementation TSAdvertCategory
@synthesize isFood = _isFood, subCategories = _subCategories;

-(void)updateWithDic:(NSDictionary*)dict{
    _ident = [TSAdvertCategory identFromDic:dict];
    _title = [dict objectForKeyNotNull:CATEGORY_NAME_PARAM];
    _isFood = [[dict objectForKeyNotNull:CATEGORY_ISFOOD_PARAM] boolValue];
    if (!_subCategories){
        _subCategories = [NSMutableArray array];
    }
    for (NSDictionary* subCatDic in [dict objectForKeyNotNull:CATEGORY_SUBCATEGORY_PARAM]){
        NSNumber* sident = [TSAdvertSubCategory identFromDic:subCatDic];
        int index = [_subCategories indexOfObjectPassingTest:^BOOL(TSAdvertSubCategory*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [obj.ident isEqual:sident];
        }];
        
        TSAdvertSubCategory* subCategory;
        if (index != NSNotFound){
            subCategory = [_subCategories objectAtIndex:index];
        }else{
            subCategory = [[TSAdvertSubCategory alloc] initWithParentIdent:_ident];
            @synchronized (self) {
                [_subCategories addObject:subCategory];
            }
        }
        [subCategory updateWithDic:subCatDic];
    }
}

+(NSNumber*)identFromDic:(NSDictionary*)dict{
    return [dict objectForKeyNotNull:CATEGORY_ID_PARAM];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    _isFood = [aDecoder decodeBoolForKey:CATEGORY_ISFOOD_PARAM];
    _subCategories = [aDecoder decodeObjectForKey:CATEGORY_SUBCATEGORY_PARAM];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeBool:_isFood forKey:CATEGORY_ISFOOD_PARAM];
    [aCoder encodeObject:_subCategories forKey:CATEGORY_SUBCATEGORY_PARAM];
}

@end
