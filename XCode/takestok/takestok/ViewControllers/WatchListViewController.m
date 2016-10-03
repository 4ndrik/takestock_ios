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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
}

#pragma mark - Helpers

-(void)reloadData{
//    _watcArray = [Advert getWatchList];
//    [_watchListTableView reloadData];
//    if (_watcArray.count == 0){
//        [self showNoItems];
//    }else{
//        [self hideNoItems];
//    }
}

-(void)updateWatchList:(TSAdvert*)advert{
//    [self showLoading];
//    [[AdvertServiceManager sharedManager] addToWatchList:advert compleate:^(NSError *error) {
//        [self hideLoading];
//        NSString* title = @"";
//        NSString* message = advert.isIn ? @"Advert added to watch list" : @"Advert removed to watch list";
//        if (error){
//            title = @"Error";
//            message = ERROR_MESSAGE(error);
//        }
//        [self showOkAlert:title text:message];
//        
//        [self reloadData];
//    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _watcArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Advert* advert = [_watcArray objectAtIndex:indexPath.row];
    WatchTableViewCell* cell = (WatchTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"WatchCell"];
//    [cell.adImageView loadImage:advert.images.firstObject];
//    
//    cell.titleLabel.text = advert.name;
//    cell.priceLabel.text = [NSString stringWithFormat:@"£%.02f", advert.guidePrice];
//    cell.locationLabel.text = advert.location;
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateStyle = kCFDateFormatterMediumStyle;
//    NSDate* updatedDate = [NSDate dateWithTimeIntervalSinceReferenceDate:advert.date_updated];
//    cell.expiresLabel.text = [NSString stringWithFormat:@"Updated: %@", [dateFormatter stringFromDate:updatedDate]];
//    
//    cell.offersCountLabel.text = [NSString stringWithFormat:@"%i", advert.offers.count];
//    cell.questionsLabel.text = [NSString stringWithFormat:@"%i", advert.questions.count];
//    
//    cell.daysLeftLabel.text = advert.expires > 0 ? [NSString stringWithFormat:@"%i", [[NSDate dateWithTimeIntervalSinceReferenceDate:advert.expires] daysFromDate:[NSDate date]]] : @"N/A";
//    
//    cell.delegate = self;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Advert* advert = [_watcArray objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self performSegueWithIdentifier:ADVERT_DETAIL_SEGUE sender:advert];
}

#pragma mark - WatchListProtocol

-(void)addRemoveWatchList:(id)owner{
//    if ([self checkUserLogin]){
//        NSIndexPath* indexPath = [_watchListTableView indexPathForCell:owner];
//        Advert* advert = [_watcArray objectAtIndex:indexPath.row];
//        BOOL addToWatchList = !advert.inWatchList;
//        NSString* message = addToWatchList ? @"Add to watch list?" : @"Remove from watch list?";
//        UIAlertController* errorController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction* yesAction = [UIAlertAction
//                                    actionWithTitle:@"YES"
//                                    style:UIAlertActionStyleDefault
//                                    handler:^(UIAlertAction * action)
//                                    {
//                                        [self updateWatchList:advert];
//                                        [errorController dismissViewControllerAnimated:YES completion:nil];
//                                        
//                                    }];
//        
//        UIAlertAction* noAction = [UIAlertAction
//                                   actionWithTitle:@"NO"
//                                   style:UIAlertActionStyleCancel
//                                   handler:^(UIAlertAction * action)
//                                   {
//                                       [errorController dismissViewControllerAnimated:YES completion:nil];
//                                       
//                                   }];
//        
//        
//        [errorController addAction:yesAction];
//        [errorController addAction:noAction];
//        
//        [self presentViewController:errorController animated:YES completion:nil];
//    }
}

@end
