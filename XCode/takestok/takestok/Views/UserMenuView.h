//
//  UserMenuView.h
//  takestok
//
//  Created by Artem on 6/13/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BackgroundImageView;

@interface UserMenuView : UIView
+(float)defaulHeight;

@property (weak, nonatomic) IBOutlet BackgroundImageView *userPhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end
