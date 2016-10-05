//
//  StoredImage.h
//  takestok
//
//  Created by Artem on 5/31/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageProtocol.h"

@interface StoredImage : NSObject<ImageProtocol>{
    NSString *_resId;
    NSString *_url;
}

@end
