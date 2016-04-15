//
//  UIImage+ImageFromColor.h
//  Panda
//
//  Created by Serbin Artem on 11/28/14.
//  Copyright (c) 2014 devabit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(ExtendedImage)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
- (UIImage *)fixOrientation;
-(void)saveToPath:(NSString*)path;

@end
