//
//  ImageCacheUrlResolver.h
//  takestok
//
//  Created by Artem on 4/14/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageProtocol.h"
@class Image;
@interface ImageCacheUrlResolver : NSObject

+(NSString*)getUrlForImage:(id<ImageProtocol>)image;
+(NSString*)getPathForImage:(id<ImageProtocol>)image;

@end
