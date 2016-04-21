//
//  SellingViewControllers.m
//  takestok
//
//  Created by Artem on 4/20/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "SellingViewController.h"
#import "SellingTableViewCell.h"
#import "Advert.h"
#import "BackgroundImageView.h"

@implementation SellingViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    _adverts = [Advert getAll];
}
   
#pragma mark - UITableViewDelegate UITableViewDataSource
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _adverts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SellingTableViewCell* cell = (SellingTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"SellingTableViewCell"];
    Advert* advert = [_adverts objectAtIndex:indexPath.row];
    [cell.adImageView loadImage:advert.images.firstObject];
    cell.titleLabel.text = advert.name;
    cell.createdLabel.text = @"Offer made";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Manage offers"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              [tableView deselectRowAtIndexPath:indexPath animated:NO];
                                                              NSLog(@"You pressed button one");
                                                          }];
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"View advert"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                [tableView deselectRowAtIndexPath:indexPath animated:NO];
                                                               NSLog(@"You pressed button two");
                                                           }];
    
    UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"Edit advert"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                [tableView deselectRowAtIndexPath:indexPath animated:NO];
                                                               NSLog(@"You pressed button two");
                                                           }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                          style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
                                                               [tableView deselectRowAtIndexPath:indexPath animated:NO];
                                                              NSLog(@"You pressed button two");
                                                          }];
    
    [alert addAction:firstAction];
    [alert addAction:secondAction];
    [alert addAction:thirdAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
