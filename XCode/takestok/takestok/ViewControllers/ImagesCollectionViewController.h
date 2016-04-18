//
//  ImagesCollectionViewController.h
//  takestok
//
//  Created by Artem on 4/18/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagesCollectionViewController : UICollectionViewController{
    NSArray* _images;
    int _startIndex;
}

-(void)setImages:(NSArray*)images withCurrentIndex:(int)currentIndex;

@end
