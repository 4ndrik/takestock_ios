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

+ (NSString *)entityName {
    return @"Image";
}

@end
