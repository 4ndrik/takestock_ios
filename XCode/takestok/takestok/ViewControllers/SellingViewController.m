//
//  SellingViewControllers.m
//  takestok
//
//  Created by Artem on 4/20/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "SellingViewController.h"
#import "SellingTableViewCell.h"
#import "TSAdvert.h"
#import "BackgroundImageView.h"
#import "NSDate+Extended.h"
#import "PaddingLabel.h"
#import "AdvertDetailViewController.h"
#import "CreateAdvertViewController.h"
#import "OfferManagerViewController.h"
#import "QAViewController.h"
#import "AdvertServiceManager.h"

@implementation SellingViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"SELLING";
    _adverts = [NSMutableArray array];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = OliveMainColor;
    [_refreshControl addTarget:self action:@selector(reloadData:) forControlEvents:UIControlEventValueChanged];
    [_sellingTableView addSubview:_refreshControl];
    
    _loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _loadingIndicator.color = OliveMainColor;
    _loadingIndicator.hidesWhenStopped = YES;
    [_loadingIndicator stopAnimating];
    [_sellingTableView addSubview:_loadingIndicator];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_sellingTableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_adverts.count == 0 || _shouldRefresh)
        [self reloadData:nil];
}

-(void)reloadData:(id)owner{
    _page = 1;
    [_adverts removeAllObjects];
    [_sellingTableView reloadData];
    [_refreshControl beginRefreshing];
    if (_sellingTableView.contentOffset.y == 0) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
            _sellingTableView.contentOffset = CGPointMake(0, -_refreshControl.frame.size.height);
        } completion:nil];
    }
    [self loadData];
}

-(void)loadData{
    [[AdvertServiceManager sharedManager] loadMyAdvertsWithPage:_page compleate:^(NSArray *result, NSDictionary *additionalData, NSError *error) {
        if (error){
            [self showOkAlert:@"Error" text:ERROR_MESSAGE(error)];
        }
        else
        {
            if ([additionalData objectForKeyNotNull:@"next"]){
                _page ++;
            }else{
                _page = 0;
            };
            [_adverts addObjectsFromArray:result];
            [_sellingTableView reloadData];
            
            if (_adverts.count == 0){
                [self showNoItems];
            }else{
                [self hideNoItems];
            }
        }
        [_loadingIndicator stopAnimating];
        if (_refreshControl.isRefreshing)
            [_refreshControl endRefreshing];
        _sellingTableView.contentInset = UIEdgeInsetsZero;
    }];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _adverts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SellingTableViewCell* cell = (SellingTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"SellingTableViewCell"];
    TSAdvert* advert = [_adverts objectAtIndex:indexPath.row];
    [cell.adImageView loadImage:advert.photos.firstObject];
    cell.titleLabel.text = advert.name;
    
    cell.priceLabel.text = [NSString stringWithFormat:@"£%.02f", advert.guidePrice];
    cell.countLabel.text = [NSString stringWithFormat:@"%i%@", advert.count, advert.packaging ? advert.packaging.title: @""];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = kCFDateFormatterMediumStyle;
    cell.createdLabel.text = [NSString stringWithFormat:@"Updated: %@", [dateFormatter stringFromDate:advert.dateUpdated]];
    
    cell.offersCountLabel.text = [NSString stringWithFormat:@"%i", advert.offersCount];
    cell.questionCountLabel.text = [NSString stringWithFormat:@"%i", advert.questionCount];
    
    cell.expiresDayCountLabel.text = advert.dateExpires > 0 ? [NSString stringWithFormat:@"%i", [advert.dateExpires daysFromDate:[NSDate date]]] : @"N/A";
    
    if (_page > 0 && indexPath.row > _adverts.count -2){
        _loadingIndicator.center = CGPointMake(_sellingTableView.center.x, _sellingTableView.contentSize.height + 22);
        _sellingTableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
        [_loadingIndicator startAnimating];
        [self loadData];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TSAdvert* advert = [_adverts objectAtIndex:indexPath.row];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *manageOffersAction = [UIAlertAction actionWithTitle:@"Manage offers"
                                                             style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                 [tableView deselectRowAtIndexPath:indexPath animated:NO];
                                                                 [self performSegueWithIdentifier:ADVERT_OFFERS_SEGUE sender:advert];
                                                             }];
    UIAlertAction *viewMessagesAction = [UIAlertAction actionWithTitle:@"View messages"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              [tableView deselectRowAtIndexPath:indexPath animated:NO];
                                                              [self performSegueWithIdentifier:ADVERT_QUESTIONS_SEGUE sender:advert];
                                                          }];
    UIAlertAction *viewAdvertAction = [UIAlertAction actionWithTitle:@"View advert"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                [tableView deselectRowAtIndexPath:indexPath animated:NO];
                                                                [self performSegueWithIdentifier:ADVERT_DETAIL_SEGUE sender:advert];
                                                           }];
    
    UIAlertAction *editAdvertAction = [UIAlertAction actionWithTitle:@"Edit advert"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                _shouldRefresh = YES;
                                                                [tableView deselectRowAtIndexPath:indexPath animated:NO];
                                                                [self performSegueWithIdentifier:EDIT_ADVERT_SEGUE sender:advert];
                                                           }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                          style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
                                                               [tableView deselectRowAtIndexPath:indexPath animated:NO];
                                                          }];
    if (advert.offersCount > 0)
        [alert addAction:manageOffersAction];
    if (advert.questionCount > 0)
        [alert addAction:viewMessagesAction];
    [alert addAction:viewAdvertAction];
    [alert addAction:editAdvertAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
