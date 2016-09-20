//
//  TSImageEntity.m
//  takestok
//
//  Created by Artem on 9/13/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSImageEntity.h"

#define IMAGE_ID_PARAM             @"id"
#define IMAGE_HEIGHT_PARAM         @"height"
#define IMAGE_WIDTH_PARAM          @"width"
#define IMAGE_URL_PARAM            @"image"
#define IMAGE_IS_MAIN_PARAM        @"is_main"
#define IMAGE_RES_ID_PARAM         @"res_id"

@implementation TSImageEntity
@synthesize url = _url, resId = _resId;

-(instancetype)initWithUrl:(NSString *)url{
    self = [super init];
    _url = url;
    if (![_url hasPrefix:@"http:"]){
        _url = [NSString stringWithFormat:@"%@%@", TAKESTOK_IMAGE_URL, _url];
    }
    _resId = [_url lastPathComponent];
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    [self updateWithDic:dict];
    return self;
}

+(NSNumber*)identFromDic:(NSDictionary*)dict{
    return [dict objectForKeyNotNull:IMAGE_ID_PARAM];
}

-(void)updateWithDic:(NSDictionary*)dict{
    _ident = [TSImageEntity identFromDic:dict];
    _height = [[dict objectForKeyNotNull:IMAGE_HEIGHT_PARAM] intValue];
    _width = [[dict objectForKeyNotNull:IMAGE_WIDTH_PARAM] intValue];
    _url = [dict objectForKeyNotNull:IMAGE_URL_PARAM];
    if (![_url hasPrefix:@"http:"]){
        _url = [NSString stringWithFormat:@"%@%@", TAKESTOK_IMAGE_URL, _url];
    }
    _resId = [_url lastPathComponent];
    _isMain = [[dict objectForKeyNotNull:IMAGE_IS_MAIN_PARAM] boolValue];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    _ident = [aDecoder decodeObjectForKey:IMAGE_ID_PARAM];
    _height = [[aDecoder decodeObjectForKey:IMAGE_HEIGHT_PARAM] intValue];
    _width = [[aDecoder decodeObjectForKey:IMAGE_WIDTH_PARAM] intValue];
    _url = [aDecoder decodeObjectForKey:IMAGE_URL_PARAM];
    _isMain = [[aDecoder decodeObjectForKey:IMAGE_IS_MAIN_PARAM] boolValue];
    _resId = [aDecoder decodeObjectForKey:IMAGE_RES_ID_PARAM];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_ident forKey:IMAGE_ID_PARAM];
    [aCoder encodeInt:_height forKey:IMAGE_HEIGHT_PARAM];
    [aCoder encodeInt:_width forKey:IMAGE_WIDTH_PARAM];
    [aCoder encodeObject:_url forKey:IMAGE_URL_PARAM];
    [aCoder encodeBool:_isMain forKey:IMAGE_IS_MAIN_PARAM];
    [aCoder encodeObject:_resId forKey:IMAGE_RES_ID_PARAM];
}

@end
