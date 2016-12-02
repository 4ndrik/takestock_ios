//
//  WatchListViewController.m
//  takestok
//
//  Created by Artem on 6/24/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "WatchListViewController.h"
#import "AdvertServiceManager.h"
#import "TSAdvert.h"

@interface WatchListViewController ()

@end

@implementation WatchListViewController

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
    [[AdvertServiceManager sharedManager] loadWatchListWithPage:_page compleate:^(NSArray *result, NSDictionary *additionalData, NSError *error) {
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


#pragma mark - WatchListProtocol

-(void)updateWatchList:(TSAdvert*)advert{
    [self showLoading];
    
    [[AdvertServiceManager sharedManager] addToWatchList:advert compleate:^(NSError *error) {
        [self hideLoading];
        NSString* title = @"";
        NSString* message = advert.isInWatchList ? @"Advert added to watch list" : @"Advert removed from watch list";
        if (error){
            title = @"Error";
            message = ERROR_MESSAGE(error);
        }else{
            [self reloadData:nil];
        }
        [self showOkAlert:title text:message compleate:nil];
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _needUpdate = YES;
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

-(void)mainAction:(id)owner{
    NSIndexPath* indexPath = [_advertListTableView indexPathForCell:owner];
    TSAdvert* advert = [_advertsArray objectAtIndex:indexPath.row];
    BOOL addToWatchList = !advert.isInWatchList;
    NSString* message = addToWatchList ? @"Add to watch list?" : @"Remove from watch list?";
    UIAlertController* errorController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesAction = [UIAlertAction
                                actionWithTitle:@"YES"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [self updateWatchList:advert];
                                    [errorController dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
    
    UIAlertAction* noAction = [UIAlertAction
                               actionWithTitle:@"NO"
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action)
                               {
                                   [errorController dismissViewControllerAnimated:YES completion:nil];
                                   
                               }];
    
    
    [errorController addAction:yesAction];
    [errorController addAction:noAction];
    
    [self presentViewController:errorController animated:YES completion:nil];
}

@end
