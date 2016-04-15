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
//    NSString* url = im.url;
//    if (url.length <= 0){
//        
//        if ([im isKindOfClass:[Image class]])
//        {
//            Image* image = (Image*)im;
//            if (image.user)
//            {
//                if (isBig)
//                    url = [NSString stringWithFormat:@"%@/userpictures/Getpicture/%@", PANDA_SYNC_URL, im.ident];
//                else
//                    url =[NSString stringWithFormat:@"%@/userpictures/getthumbnail/%@", PANDA_SYNC_URL, im.ident];
//            }
//            else if (image.clubLogo || image.clubBackground || image.floor)
//            {
//                url = [NSString stringWithFormat:@"%@/club/GetClubPicture/%@", PANDA_SYNC_URL, im.ident];
//            }else if (image.message){
//                url = [NSString stringWithFormat:@"%@/chat/getMsgImage?id=%@&mid=%i", PANDA_SYNC_URL, im.ident, image.message.serverIdent];
//            }
//        }
//    }
    return nil;
}


+(NSString*)getPathForImage:(id<ImageProtocol>)image{
    NSString* cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [cacheDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", image.resId]];
    return filePath;
}

@end
