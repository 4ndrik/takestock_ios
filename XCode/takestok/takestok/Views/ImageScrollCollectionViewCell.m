//
//  ImageScrollCollectionViewCell.m
//  takestok
//
//  Created by Artem on 4/18/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "ImageScrollCollectionViewCell.h"

@implementation ImageScrollCollectionViewCell

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

@end
