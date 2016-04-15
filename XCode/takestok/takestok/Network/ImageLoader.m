//
//  ImageLoader.m
//  takestok
//
//  Created by Artem on 4/14/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "ImageLoader.h"
#import "ImageCacheUrlResolver.h"

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

-(void)loadImage:(id<ImageProtocol>)image beforeLoad:(void(^)())beforeLoad success:(void(^)(NSData* imageData, NSString* filename))success;
{
    NSString* filePath = [ImageCacheUrlResolver getPathForImage:image];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:filePath] && [[[fileManager attributesOfItemAtPath:filePath error:nil] objectForKey:@"NSFileSize"]intValue] > 0)
    {
        NSData *imageData = [NSData dataWithContentsOfFile:filePath];
        if (success)
            success(imageData, image.resId);
        //        NSLog(@"Load from phone");
    }
    else
    {
        beforeLoad();
        
        //        NSLog(@"Load from www");
//        
//        DownloadItem* item = [[DownloadItem alloc] initWithIdent:im.ident withUrl:[ImageCacheUrlResolver getUrlForImage:im isBig:isBig] withSavePath:filePath];
//        item.callBack = success;
//        [[ImageLoader singleton] loadItem:item];
    }
}


@end
