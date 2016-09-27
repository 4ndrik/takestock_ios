//
//  TakeStokRootViewController.m
//  takestok
//
//  Created by Artem on 6/13/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TakeStokRootViewController.h"

@implementation TakeStokRootViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:ADVERT_STORYBOARD bundle:nil];
    self.contentViewController = [storyboard instantiateViewControllerWithIdentifier:HOME_CONTROLLER];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:MENU_CONTROLLER];
}

@end
