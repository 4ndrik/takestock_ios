//
//  ImageCacheUrlResolver.m
//  takestok
//
//  Created by Artem on 4/14/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "ImageCacheUrlResolver.h"
#import "Image.h"

@implementation ImageCacheUrlResolver

+(NSString*)getUrlForImage:(id<ImageProtocol>)image {
    NSString* url = image.url;
//TODO: 
//    if (url.length <= 0){
        url = [NSString stringWithFormat:@"%@/%@", TAKESTOK_IMAGE_URL, image.resId];
//    }
    return url;
}


+(NSString*)getPathForImage:(id<ImageProtocol>)image{
    NSString* cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [cacheDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", image.resId]];
    return filePath;
}

@end
