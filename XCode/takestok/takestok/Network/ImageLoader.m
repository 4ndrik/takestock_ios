//
//  ImageLoader.m
//  takestok
//
//  Created by Artem on 4/14/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "ImageLoader.h"
#import "ImageCacheUrlResolver.h"
#import "ImageProtocol.h"
#import "UIImage+ExtendedImage.h"

#define MAX_ALIVE_THREADS 10
#define MAX_PRIORITY_ITEMS 10

@implementation ImageLoader

-(id)init
{
    self = [super init];
    _downloadItemQueue = [NSMutableArray array];
    _downloadPriorityQueue = [NSMutableArray arrayWithCapacity:5];
    _loadingItemsArray = [NSMutableArray arrayWithCapacity:MAX_ALIVE_THREADS];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        //        [self loadingLoop];
    });
    
    return self;
}

+(instancetype) sharedInstance
{
    static ImageLoader *singleton = nil;
    static dispatch_once_t predicate;
    dispatch_once( &predicate, ^{
        singleton = [[ self alloc ] init];
    } );
    return singleton;
}

-(UIImage*)decompressImage:(UIImage*)image{
    if (image) {
        UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
        [image drawAtPoint:CGPointZero];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return image;
}

-(void)loadImage:(id<ImageProtocol>)image success:(void(^)(UIImage* image, NSString* filename))success;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* filePath = [ImageCacheUrlResolver getPathForImage:image];
        NSFileManager* fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:filePath] && [[[fileManager attributesOfItemAtPath:filePath error:nil] objectForKey:@"NSFileSize"]intValue] > 0)
        {
            NSData *imageData = [NSData dataWithContentsOfFile:filePath];
            UIImage* result = [UIImage imageWithData:imageData];
            result = [self decompressImage:result];
            if (success){
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(result, image.resId);
                });
            }
        }
        else
        {
//            beforeLoad();
            
                    NSLog(@"Load from www");
            //
            //        DownloadItem* item = [[DownloadItem alloc] initWithIdent:im.ident withUrl:[ImageCacheUrlResolver getUrlForImage:im isBig:isBig] withSavePath:filePath];
            //        item.callBack = success;
            //        [[ImageLoader singleton] loadItem:item];
        }
    });
}


@end
