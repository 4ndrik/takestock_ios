//
//  UserDetailsViewController.h
//  takestok
//
//  Created by Artem on 5/26/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BaseViewController.h"
#import "AdvertsCollectionViewController.h"

@class TSUserEntity;
@class BackgroundImageView;
@class RatingView;

@interface UserDetailsViewController : BaseViewController<SimilarAdvertsProtocol>{
    TSUserEntity* _user;
    
    TSAdvert* _parentAdvert;
    
    __weak IBOutlet BackgroundImageView *_userPicture;
    __weak IBOutlet UILabel *_userameLabel;
    __weak IBOutlet RatingView *_ratingView;
    __weak IBOutlet UILabel *_ratingLabel;
    
    __weak IBOutlet UILabel *_otherUserDetails;
    __weak IBOutlet NSLayoutConstraint *_similarAdvertsHeight;
    
    __weak AdvertsCollectionViewController *_advertsViewController;
    
}

-(void)setAdvert:(TSAdvert*)advert;
-(void)setUser:(TSUserEntity*)user;

@end
