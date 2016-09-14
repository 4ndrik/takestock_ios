//
//  TSUserSubBusinessType.m
//  takestok
//
//  Created by Artem on 9/13/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSUserSubBusinessType.h"

#define BUSINESS_ID_PARAM               @"id"
#define BUSINESS_NAME_PARAM             @"name"

@implementation TSUserSubBusinessType

-(void)updateWithDic:(NSDictionary*)dict{
    _ident = [TSUserSubBusinessType identFromDic:dict];
    _title = [dict objectForKeyNotNull:BUSINESS_NAME_PARAM];
}

+(NSNumber*)identFromDic:(NSDictionary*)dict{
    return [dict objectForKeyNotNull:BUSINESS_ID_PARAM];
}

@end
