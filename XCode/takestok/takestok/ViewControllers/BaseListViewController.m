//
//  BaseListViewController.m
//  takestok
//
//  Created by Artem on 10/6/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BaseListViewController.h"
#import "BackgroundImageView.h"
#import "PaddingLabel.h"
#import "TopBottomStripesLabel.h"
#import "AdvertTableViewCell.h"
#import "TSAdvert.h"
#import "ServerConnectionHelper.h"
#import "AdvertServiceManager.h"
#import "UserServiceManager.h"
#import "WatchListViewController.h"

@interface BaseListViewController ()

@end

@implementation BaseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_advertListTableView registerNib:[UINib nibWithNibName:@"AdvertTableViewCell" bundle:nil] forCellReuseIdentifier:@"AdvertTableViewCell"];
    
    _advertsArray = [NSMutableArray array];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = OliveMainColor;
    [_refreshControl addTarget:self action:@selector(reloadData:) forControlEvents:UIControlEventValueChanged];
    [_advertListTableView addSubview:_refreshControl];
    
    _loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _loadingIndicator.color = OliveMainColor;
    _loadingIndicator.hidesWhenStopped = YES;
    [_loadingIndicator stopAnimating];
    [_advertListTableView addSubview:_loadingIndicator];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_advertListTableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_advertsArray.count == 0 || _needUpdate)
        [self reloadData:nil];
}

#pragma mark - AdvertListProtocol

-(void)mainAction:(id)owner{
    NSAssert(NO, @"Must be overridden in subclasses");
}

#pragma mark - Helpers

-(void)reloadData:(id)owner{
    NSAssert(NO, @"Must be overridden in subclasses");
}

-(void)loadData{
    NSAssert(NO, @"Must be overridden in subclasses");
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _advertsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TSAdvert* advert = [_advertsArray objectAtIndex:indexPath.row];
    AdvertTableViewCell* cell = (AdvertTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"AdvertTableViewCell"];
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
    
    if ([self isKindOfClass:[WatchListViewController class]]){
        [cell.mainActionButton setImage:[UIImage imageNamed:@"searchItemSeen"] forState:UIControlStateNormal];
    }else{
        [cell.mainActionButton setImage:[UIImage imageNamed:@"editButton"] forState:UIControlStateNormal];
    }
    
    cell.delegate = self;
    
    if (!_loading && _page > 0 && indexPath.row > _advertsArray.count -2){
        _loadingIndicator.center = CGPointMake(_advertListTableView.center.x, _advertListTableView.contentSize.height + 22);
        _advertListTableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
        [_loadingIndicator startAnimating];
        [self loadData];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TSAdvert* advert = [_advertsArray objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self performSegueWithIdentifier:ADVERT_DETAIL_SEGUE sender:advert];
}

@end
