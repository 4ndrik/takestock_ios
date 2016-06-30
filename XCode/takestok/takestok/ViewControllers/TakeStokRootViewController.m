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
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:HOME_CONTROLLER];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:MENU_CONTROLLER];
}

@end
