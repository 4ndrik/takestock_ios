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
#import "ServerConnectionHelper.h"

#define MAX_ALIVE_THREADS 10
#define MAX_PRIORITY_ITEMS 10

@interface DownloadItem : NSObject{
    id<ImageProtocol> _image;
    void (^_callBack) (UIImage *image, NSString* fileIdent);
}

@property (readonly) id<ImageProtocol> image;
@property (atomic, copy) void (^callBack)(UIImage *image, NSString* fileIdent);

-(instancetype)initWithImage:(id<ImageProtocol>)image callback:(void(^)(UIImage* image, NSString* filename))callback;

@end

@implementation DownloadItem
@synthesize image = _image;
@synthesize callBack = _callBack;

-(instancetype)initWithImage:(id<ImageProtocol>)image callback:(void(^)(UIImage* image, NSString* filename))callback{
    self = [super init];
    _image = image;
    _callBack = [callback copy];
    return self;
}


-(BOOL)isEqual:(id)object{
    if ([object isKindOfClass:[DownloadItem class]]){
        DownloadItem* object2 = (DownloadItem*)object;
        return [_image.resId isEqualToString:object2.image.resId];
    }
    return NO;
}

-(NSUInteger)hash{
    return [_image.resId hash];
}

-(void)dealloc
{
    _image = nil;
    _callBack = nil;
}

@end

@implementation ImageLoader

-(id)init
{
    self = [super init];
    _downloadItemQueue = [NSMutableArray array];
    _downloadPriorityQueue = [NSMutableArray arrayWithCapacity:5];
    _loadingItemsArray = [NSMutableArray arrayWithCapacity:MAX_ALIVE_THREADS];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
    [self loadingLoop];
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

-(void)asyncDownLoadItem:(DownloadItem*)item{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        //        NSLog(@"Load from %@", item.url);
        NSData *imageData = nil;
        UIImage* result;
        if ([ServerConnectionHelper sharedInstance].isInternetConnection){
            NSString* url = [ImageCacheUrlResolver getUrlForImage:item.image];
            NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:180];
            NSHTTPURLResponse* responce;
            NSError* reqError;
            
            imageData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responce error:&reqError];
            if (([responce isKindOfClass:[NSHTTPURLResponse class]] && responce.statusCode != 200) || reqError)
            {
                imageData = nil;
            }
            if ([imageData length] > 0){
                NSString* savePath = [ImageCacheUrlResolver getPathForImage:item.image];
                [[NSFileManager defaultManager] createFileAtPath:savePath contents:imageData attributes:nil];
            }
            result = [UIImage imageWithData:imageData];
            result = [self decompressImage:result];
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            item.callBack(result, item.image.resId);
        });
        @synchronized(self) {
            [_loadingItemsArray removeObject:item];
        }
    });
}

-(void)loadingLoop{
    while (YES) {
        while (_loadingItemsArray.count < MAX_ALIVE_THREADS && (_downloadItemQueue.count > 0 || _downloadPriorityQueue.count > 0)) {
            DownloadItem* item;
            @synchronized(self){
                if (_downloadPriorityQueue.count > 0){
                    item = _downloadPriorityQueue.firstObject;
                    [_downloadPriorityQueue removeObjectAtIndex:0];
                    [_loadingItemsArray addObject:item];
                }
                else if (_downloadItemQueue.count > 0){
                    item = _downloadItemQueue.firstObject;
                    [_downloadItemQueue removeObjectAtIndex:0];
                    [_loadingItemsArray addObject:item];
                }
            }
            
            if (item){
                [self asyncDownLoadItem:item];
                item = nil;
                sleep(0.2);
            }
        }
        sleep(2.0);
    }
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
            DownloadItem* downloadItem = [[DownloadItem alloc] initWithImage:image callback:success];
            @synchronized(self)
            {
                NSUInteger index = [_loadingItemsArray indexOfObject:downloadItem];
                if (index != NSNotFound){
                    DownloadItem* item = [_loadingItemsArray objectAtIndex:index];
                    item.callBack = downloadItem.callBack;
                }else {
                    [_downloadPriorityQueue removeObject:downloadItem];
                    [_downloadItemQueue removeObject:downloadItem];
                    [_downloadPriorityQueue addObject:downloadItem];
                    
                    if (_downloadPriorityQueue.count > MAX_PRIORITY_ITEMS)
                    {
                        DownloadItem* item = [_downloadPriorityQueue firstObject];
                        [_downloadPriorityQueue removeObjectAtIndex:0];
                        [_downloadItemQueue insertObject:item atIndex:0];
                    }
                }
            }
        }
    });
}


@end
