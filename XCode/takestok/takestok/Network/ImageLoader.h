//
//  ImageLoader.h
//  takestok
//
//  Created by Artem on 4/14/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageProtocol.h"

@interface ImageLoader : NSObject{
    NSMutableArray* _downloadItemQueue;
    NSMutableArray* _downloadPriorityQueue;
    NSMutableArray* _loadingItemsArray;
    int _aliveThreads;
}

+(instancetype) sharedInstance;
-(void)loadImage:(id<ImageProtocol>)image success:(void(^)(UIImage* image, NSString* filename))success;

@end
