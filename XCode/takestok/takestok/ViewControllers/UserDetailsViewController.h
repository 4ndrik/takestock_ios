//
//  UserDetailsViewController.h
//  takestok
//
//  Created by Artem on 5/26/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BaseViewController.h"
@class User;
@class BackgroundImageView;
@class RatingView;

@interface UserDetailsViewController : BaseViewController{
    User* _user;
    
    __weak IBOutlet BackgroundImageView *_userPicture;
    __weak IBOutlet UILabel *_noImageLabel;
    __weak IBOutlet UILabel *_userameLabel;
    __weak IBOutlet RatingView *_ratingView;
    __weak IBOutlet UILabel *_ratingLabel;
}

-(void)setUser:(User*)user;

@end
