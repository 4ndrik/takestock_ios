//
//  ImagesCollectionViewController.m
//  takestok
//
//  Created by Artem on 4/18/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "ImagesCollectionViewController.h"
#import "ImageScrollCollectionViewCell.h"

@implementation ImagesCollectionViewController

-(void)setImages:(NSArray*)images withCurrentIndex:(int)currentIndex{
    _images = images;
    _startIndex = currentIndex;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshData];
}

-(void)refreshData{
    self.collectionView.contentOffset = CGPointMake(_startIndex * self.collectionView.bounds.size.width, 0);
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageScrollCollectionViewCell* cell = (ImageScrollCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageScrollCollectionViewCell" forIndexPath:indexPath];
    cell.scrollView.zoomScale = 1.;
    [cell.imageView loadImage:[_images objectAtIndex:indexPath.row]];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _images.count;
}

@end
