//
//  NotificationsViewController.m
//  takestok
//
//  Created by Artem on 11/1/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "NotificationsViewController.h"
#import "NotificationServiceManager.h"
#import "TSNotification.h"
#import "NotificationTableViewCell.h"
#import "REFrostedViewController.h"
#import "MenuViewController.h"

@interface NotificationsViewController ()

@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView registerNib:[UINib nibWithNibName:@"NotificationTableViewCell" bundle:nil] forCellReuseIdentifier:@"NotificationTableViewCell"];
    _tableView.estimatedRowHeight = 72.0;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:NOTIFICATION_UPDATED_NOTIFICATION object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_UPDATED_NOTIFICATION object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
}

-(void)reloadData{
    _notifications = [[NotificationServiceManager sharedManager].getNotifications sortedArrayUsingComparator:^NSComparisonResult(TSNotification*  _Nonnull obj1, TSNotification*  _Nonnull obj2) {
        return [obj2.dateCreated compare:obj1.dateCreated];
        
    }];
    [_tableView reloadData];
    if (_notifications.count == 0){
        _tableView.hidden = YES;
        [self showNoItems];
    }else{
        _tableView.hidden = NO;
        [self hideNoItems];
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _notifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TSNotification* notification = _notifications[indexPath.row];
    NotificationTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationTableViewCell"];
    cell.notificationTitleLabel.text = notification.title;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
   [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    
    cell.notificationDateLabel.text = [dateFormatter stringFromDate:notification.dateCreated];
    cell.notificationTextLabel.text = notification.text;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TSNotification* notification = _notifications[indexPath.row];
    switch (notification.type) {
        case kGeneral:{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:ADVERT_STORYBOARD bundle:nil];
            self.frostedViewController.contentViewController = [storyboard instantiateViewControllerWithIdentifier:HOME_CONTROLLER];
            break;
        }
        case kBuying:{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:BUYING_STORYBOARD bundle:nil];
            self.frostedViewController.contentViewController = [storyboard instantiateViewControllerWithIdentifier:BUYING_CONTROLLER];
            break;
        }
        case kSelling:{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:SELLING_STORYBOARD bundle:nil];
            self.frostedViewController.contentViewController = [storyboard instantiateViewControllerWithIdentifier:SELLING_CONTROLLER];
            break;
        }
        case kQuestion:{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:SELLING_STORYBOARD bundle:nil];
            self.frostedViewController.contentViewController = [storyboard instantiateViewControllerWithIdentifier:SELLING_CONTROLLER];
            break;
        }
        default:
            break;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TSNotification* notification = _notifications[indexPath.row];
        [[NotificationServiceManager sharedManager] removeNotification:notification];
        [self reloadData];
    }
}

@end
