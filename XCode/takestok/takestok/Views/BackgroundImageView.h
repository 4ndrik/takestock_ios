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
    UIActivityIndicatorView* _activityIndicator;
    
    __block void (^_successBlock) (UIImage *image, NSString* fileIdent);
}

@property (nonatomic, retain)UIImage* placeHolder;

- (void)loadImage:(id<ImageProtocol>)image;

@end
