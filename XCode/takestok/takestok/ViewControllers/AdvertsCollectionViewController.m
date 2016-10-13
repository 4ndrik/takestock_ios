//
//  AdvertsCollectionViewController.m
//  takestok
//
//  Created by Artem on 10/11/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "AdvertsCollectionViewController.h"
#import "AdvertServiceManager.h"
#import "AdvertSmallCollectionViewCell.h"
#import "TSAdvert.h"
#import "TSImageEntity.h"
#import "BackgroundImageView.h"
#import "AdvertDetailViewController.h"

@interface AdvertsCollectionViewController ()

@end

@implementation AdvertsCollectionViewController

static NSString * const reuseIdentifier = @"AdvertSmallCollectionViewCell";

-(void)setAdvert:(TSAdvert*)advert{
    _parentAdvert = advert;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _adverts = [NSMutableArray array];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = OliveMainColor;
    [_refreshControl addTarget:self action:@selector(reloadData:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:_refreshControl];
    
    _loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _loadingIndicator.color = OliveMainColor;
    _loadingIndicator.hidesWhenStopped = YES;
    [_loadingIndicator stopAnimating];
    [self.collectionView addSubview:_loadingIndicator];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_parentAdvert)
        [self reloadData:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:ADVERT_DETAIL_SEGUE]) {
        AdvertDetailViewController* vc = (AdvertDetailViewController*)segue.destinationViewController;
        [vc setAdvert:sender];
    }
}

-(void)reloadData:(id)owner{
    _page = 1;
    [_adverts removeAllObjects];
    [self.collectionView reloadData];
    [_refreshControl beginRefreshing];
    [self loadData];
}

-(void)loadData{
    
    void (^compleateBlock)(NSArray *result, NSDictionary *additionalData, NSError *error) = ^void(NSArray *result, NSDictionary *additionalData, NSError *error) {
        if (!error){
            if ([additionalData objectForKeyNotNull:@"next"]){
                _page ++;
            }else{
                _page = 0;
            };
            [_adverts addObjectsFromArray:result];
            [self.collectionView reloadData];
            
        }
        [_loadingIndicator stopAnimating];
        if (_refreshControl.isRefreshing)
            [_refreshControl endRefreshing];
        self.collectionView.contentInset = UIEdgeInsetsZero;
        [self.delegate dataLoaded:_adverts.count == 0];
    };
    
    if ([self.delegate isForUser]){
        [[AdvertServiceManager sharedManager] loadUserAdverts:_parentAdvert withPage:_page compleate:compleateBlock];
    }else{
        [[AdvertServiceManager sharedManager] loadSimilarAdverts:_parentAdvert withPage:_page compleate:compleateBlock];
    }
}

#pragma mark <UICollectionViewDataSource>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TSAdvert* advert = [_adverts objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:ADVERT_DETAIL_SEGUE sender:advert];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _adverts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AdvertSmallCollectionViewCell *cell = (AdvertSmallCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    TSAdvert* adv = [_adverts objectAtIndex:indexPath.row];
    TSImageEntity* image = [adv.photos firstObject];
    
    [cell.imageView loadImage:image];
    cell.titleLabel.text = adv.name;
    cell.priceLabel.text = [NSString stringWithFormat:@"%.02f", adv.guidePrice];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(94, self.collectionView.bounds.size.height);
}


@end
