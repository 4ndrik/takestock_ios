//
//  AdvertsCollectionViewController.h
//  takestok
//
//  Created by Artem on 10/11/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSAdvert;

@protocol SimilarAdvertsProtocol <NSObject>

-(void)dataLoaded:(BOOL)isEmpty;
-(BOOL)isForUser;

@end

@interface AdvertsCollectionViewController : UICollectionViewController{
    int _page;
    NSMutableArray* _adverts;
    TSAdvert* _parentAdvert;
    UIRefreshControl *_refreshControl;
    UIActivityIndicatorView* _loadingIndicator;
}

-(void)setAdvert:(TSAdvert*)advert;

@property (assign)id<SimilarAdvertsProtocol> delegate;

@end
