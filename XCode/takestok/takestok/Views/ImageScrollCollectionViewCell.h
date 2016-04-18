//
//  ImageScrollCollectionViewCell.h
//  takestok
//
//  Created by Artem on 4/18/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackgroundImageView.h"
@interface ImageScrollCollectionViewCell : UICollectionViewCell<UIScrollViewDelegate>{
    
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet BackgroundImageView *imageView;


@end
