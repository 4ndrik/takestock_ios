//
//  WatchListViewController.m
//  takestok
//
//  Created by Artem on 6/24/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "WatchListViewController.h"
#import "BackgroundImageView.h"
#import "PaddingLabel.h"
#import "TopBottomStripesLabel.h"
#import "WatchTableViewCell.h"
#import "TSAdvert.h"
#import "ServerConnectionHelper.h"
#import "AdvertServiceManager.h"

@interface WatchListViewController ()

@end

@implementation WatchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"WATCH LIST";
    
    _watcArray = [NSMutableArray array];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = OliveMainColor;
    [_refreshControl addTarget:self action:@selector(reloadData:) forControlEvents:UIControlEventValueChanged];
    [_watchListTableView addSubview:_refreshControl];
    
    _loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _loadingIndicator.color = OliveMainColor;
    _loadingIndicator.hidesWhenStopped = YES;
    [_loadingIndicator stopAnimating];
    [_watchListTableView addSubview:_loadingIndicator];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_watchListTableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_watcArray.count == 0)
        [self reloadData:nil];
}

#pragma mark - Helpers


-(void)reloadData:(id)owner{
    _page = 1;
    [_watcArray removeAllObjects];
    [_watchListTableView reloadData];
    [_refreshControl beginRefreshing];
    if (_watchListTableView.contentOffset.y == 0) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
            _watchListTableView.contentOffset = CGPointMake(0, -_refreshControl.frame.size.height);
        } completion:nil];
    }
    [self loadData];
}

-(void)loadData{
    
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
            [_watcArray addObjectsFromArray:result];
            [_watchListTableView reloadData];
            
            if (_watcArray.count == 0){
                [self showNoItems];
            }else{
                [self hideNoItems];
            }
        }
        [_loadingIndicator stopAnimating];
        if (_refreshControl.isRefreshing)
            [_refreshControl endRefreshing];
        _watchListTableView.contentInset = UIEdgeInsetsZero;
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _watcArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TSAdvert* advert = [_watcArray objectAtIndex:indexPath.row];
    WatchTableViewCell* cell = (WatchTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"WatchCell"];
    [cell.adImageView loadImage:advert.photos.firstObject];
    
    cell.titleLabel.text = advert.name;
    cell.priceLabel.text = [NSString stringWithFormat:@"£%.02f", advert.guidePrice];
    cell.locationLabel.text = advert.location;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = kCFDateFormatterMediumStyle;
    cell.expiresLabel.text = [NSString stringWithFormat:@"Updated: %@", [dateFormatter stringFromDate:advert.dateUpdated]];
    
    cell.offersCountLabel.text = [NSString stringWithFormat:@"%i", advert.offersCount];
    cell.questionsLabel.text = [NSString stringWithFormat:@"%i", advert.questionCount];
    
    cell.daysLeftLabel.text = advert.dateExpires ? [NSString stringWithFormat:@"%i", [advert.dateExpires daysFromDate:[NSDate date]]] : @"N/A";
    
    cell.delegate = self;
    
    if (_page > 0 && indexPath.row > _watcArray.count -2){
        _loadingIndicator.center = CGPointMake(_watchListTableView.center.x, _watchListTableView.contentSize.height + 22);
        _watchListTableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
        [_loadingIndicator startAnimating];
        [self loadData];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TSAdvert* advert = [_watcArray objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self performSegueWithIdentifier:ADVERT_DETAIL_SEGUE sender:advert];
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

-(void)addRemoveWatchList:(id)owner{
    if ([self checkUserLogin]){
        NSIndexPath* indexPath = [_watchListTableView indexPathForCell:owner];
        TSAdvert* advert = [_watcArray objectAtIndex:indexPath.row];
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
}

@end
