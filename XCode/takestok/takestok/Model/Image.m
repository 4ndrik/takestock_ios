//
//  Image.m
//  takestok
//
//  Created by Artem on 4/14/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "Image.h"
#import "Advert.h"
#import "GUIDCreator.h"

@implementation Image

+ (instancetype)disconnectedEntity {
    Image* entity = [super tempEntity];
    if (entity.resId.length <= 0){
        entity.resId = [GUIDCreator getGuid];
    }
    return entity;
}

+ (instancetype)storedEntity {
    Image* entity = [super storedEntity];
    if (entity.resId.length <= 0){
        entity.resId = [GUIDCreator getGuid];
    }
    return entity;
}

+ (NSString *)entityName {
    return @"Image";
}

-(void)updateWithDic:(NSDictionary*)imageDic{
    self.ident = [[imageDic objectForKeyNotNull:IMAGE_ID_PARAM] intValue];
    self.height = [[imageDic objectForKeyNotNull:PHOTOS_HEIGHT_PARAM] intValue];
    self.width = [[imageDic objectForKeyNotNull:PHOTOS_WIDTH_PARAM] intValue];
    
    self.url = [imageDic objectForKeyNotNull:PHOTOS_IMAGE_PARAM];
    self.resId = [self.url lastPathComponent];
}

@end
