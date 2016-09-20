//
//  UserDetailsViewController.h
//  takestok
//
//  Created by Artem on 5/26/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BaseViewController.h"
@class TSUserEntity;
@class BackgroundImageView;
@class RatingView;

@interface UserDetailsViewController : BaseViewController{
    TSUserEntity* _user;
    
    __weak IBOutlet BackgroundImageView *_userPicture;
    __weak IBOutlet UILabel *_userameLabel;
    __weak IBOutlet RatingView *_ratingView;
    __weak IBOutlet UILabel *_ratingLabel;
    
    __weak IBOutlet UILabel *_otherUserDetails;
    
}

-(void)setUser:(TSUserEntity*)user;

@end
