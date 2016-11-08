//
//  DraftsViewController.m
//  takestok
//
//  Created by Artem on 10/6/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "DraftsViewController.h"
#import "AdvertServiceManager.h"

@interface DraftsViewController ()

@end

@implementation DraftsViewController

#pragma mark - Helpers

-(void)reloadData:(id)owner{
    _page = 1;
    [_advertsArray removeAllObjects];
    [_advertListTableView reloadData];
    [_refreshControl beginRefreshing];
    if (_advertListTableView.contentOffset.y == 0) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
            _advertListTableView.contentOffset = CGPointMake(0, -_refreshControl.frame.size.height);
        } completion:nil];
    }
    [self loadData];
}

-(void)loadData{
    _loading = YES;
    [[AdvertServiceManager sharedManager] loadDraftsWithPage:_page compleate:^(NSArray *result, NSDictionary *additionalData, NSError *error) {
        if (error){
            [self showOkAlert:@"Error" text:ERROR_MESSAGE(error) compleate:nil];
        }
        else
        {
            if ([additionalData objectForKeyNotNull:@"next"]){
                _page ++;
            }else{
                _page = 0;
            };
            [_advertsArray addObjectsFromArray:result];
            [_advertListTableView reloadData];
            
            if (_advertsArray.count == 0){
                [self showNoItems];
            }else{
                [self hideNoItems];
            }
        }
        _loading = NO;
        [_loadingIndicator stopAnimating];
        if (_refreshControl.isRefreshing)
            [_refreshControl endRefreshing];
        _advertListTableView.contentInset = UIEdgeInsetsZero;
    }];
}

-(void)mainAction:(id)owner{
    _needUpdate = YES;
    NSIndexPath* indexPath = [_advertListTableView indexPathForCell:owner];
    TSAdvert* advert = [_advertsArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:EDIT_ADVERT_SEGUE sender:advert];
}

@end
