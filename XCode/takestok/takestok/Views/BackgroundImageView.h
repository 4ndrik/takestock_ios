//
//  BackgroundImageView.h
//  UnsharedTV
//
//  Created by N-iX Artem Serbin on 12/10/10.
//  Copyright (c) 2013 App Dev LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageProtocol.h"

@interface BackgroundImageView : UIImageView
{
    UIImage* _placeHolder;
    
    __block void (^_successBlock) (NSData *imageData, NSString* fileIdent);
    __block void (^_beforeLoadBlock) ();
}

@property (nonatomic, retain)UIImage* placeHolder;

- (void)loadImage:(id<ImageProtocol>)image;

@end
