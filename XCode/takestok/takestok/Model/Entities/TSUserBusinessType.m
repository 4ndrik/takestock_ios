//
//  TSUserBusinessType.m
//  takestok
//
//  Created by Artem on 9/13/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSUserBusinessType.h"
#import "TSUserSubBusinessType.h"

#define BUSINESS_ID_PARAM               @"id"
#define BUSINESS_NAME_PARAM             @"name"
#define BUSINESS_SUB_PARAM              @"sub"

@implementation TSUserBusinessType
@synthesize subTypes = _subTypes;

-(void)updateWithDic:(NSDictionary*)dict{
    _ident = [TSUserBusinessType identFromDic:dict];
    _title = [dict objectForKeyNotNull:BUSINESS_NAME_PARAM];
    if (!_subTypes){
        _subTypes = [NSMutableArray array];
    }
    for (NSDictionary* subBTDic in [dict objectForKeyNotNull:BUSINESS_SUB_PARAM]){
        NSNumber* sident = [TSUserSubBusinessType identFromDic:subBTDic];
        NSUInteger index = [_subTypes indexOfObjectPassingTest:^BOOL(TSUserSubBusinessType*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [obj.ident isEqual:sident];
        }];
        
        TSUserSubBusinessType* subBt;
        if (index != NSNotFound){
            subBt = [_subTypes objectAtIndex:index];
        }else{
            subBt = [[TSUserSubBusinessType alloc] init];
            @synchronized (self) {
                [(NSMutableArray*)_subTypes addObject:subBt];
            }
        }
        [subBt updateWithDic:subBTDic];
    }
}

+(NSNumber*)identFromDic:(NSDictionary*)dict{
    return [dict objectForKeyNotNull:BUSINESS_ID_PARAM];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    _subTypes = [aDecoder decodeObjectForKey:BUSINESS_SUB_PARAM];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_subTypes forKey:BUSINESS_SUB_PARAM];
}

@end
