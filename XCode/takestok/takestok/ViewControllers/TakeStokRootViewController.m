
//
//  TakeStokRootViewController.m
//  takestok
//
//  Created by Artem on 6/13/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TakeStokRootViewController.h"
#import "OfferManagerViewController.h"
#import "QAViewController.h"
#import "BuyingOffersViewController.h"
#import "AdvertDetailViewController.h"

@implementation TakeStokRootViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:ADVERT_STORYBOARD bundle:nil];
    self.contentViewController = [storyboard instantiateViewControllerWithIdentifier:HOME_CONTROLLER];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:MENU_CONTROLLER];
}

-(void)showNotificationDetails:(TSNotification*)notification{
    switch (notification.type) {
        case kGeneral:{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:ADVERT_STORYBOARD bundle:nil];
            self.contentViewController = [storyboard instantiateViewControllerWithIdentifier:HOME_CONTROLLER];
            break;
        }
        case kBuying:{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:BUYING_STORYBOARD bundle:nil];
            
            BuyingOffersViewController* vc = [storyboard instantiateViewControllerWithIdentifier:BUYING_OFFER_CONTROLLER];
            [vc loadAdvertId:notification.advertId offerId:notification.offerId];
            
            UINavigationController* navC = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:navC animated:YES completion:nil];

            break;
        }
        case kSelling:{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:SELLING_STORYBOARD bundle:nil];

            OfferManagerViewController* vc = [storyboard instantiateViewControllerWithIdentifier:OFFER_MANAGER_CONTROLLER];
            if (notification.advertId){
                vc.advertId = notification.advertId;
            }else{
                vc.offerId = notification.offerId;
            }
            
            UINavigationController* navC = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:navC animated:YES completion:nil];
            
            break;
        }
        case kQuestion:{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:SELLING_STORYBOARD bundle:nil];
            AdvertDetailViewController* vc = [storyboard instantiateViewControllerWithIdentifier:ADVERT_DETAIL_CONTROLLER];
            [vc loadAdvert:notification.advertId];
            
            UINavigationController* navC = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:navC animated:YES completion:nil];
            
            break;
        }
        default:
            break;
    }

}

@end
