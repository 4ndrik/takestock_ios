//
//  SearchViewController.m
//  takestok
//
//  Created by Artem on 4/8/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchFilterSortView.h"
#import "ImageCacheUrlResolver.h"
#import "BackgroundImageView.h"
#import "NSDate+Extended.h"
#import "AdvertDetailViewController.h"
#import "SearchTitleView.h"
#import "SortData.h"
#import "NSDictionary+HandleNil.h"
#import "AppSettings.h"
#import "AdvertServiceManager.h"
#import "TSBaseDictionaryEntity.h"
#import "TSAdvert.h"
#import "TSImageEntity.h"
#import "TSAdvertSubCategory.h"
#import "TSAdvertCategory.h"

#define CellTitleFont [UIFont fontWithName:@"HelveticaNeue-Bold" size:16]
#define CellOtherFont [UIFont fontWithName:@"HelveticaNeue" size:16]
#define CellPriceFont [UIFont fontWithName:@"HelveticaNeue-Bold" size:24]
#define SmallMargin 4
#define LongMargin 10

@interface SearchViewController()<UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, CategoryProtocol, WatchListProtocol, UIGestureRecognizerDelegate, SearchCollectionViewLayoutProtocol>
@end

@implementation SearchViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    _adverts = [NSMutableArray array];
    
    int defaultSort = [AppSettings getSearchSort];
    if (defaultSort > 0){
        NSArray* sortData = [SortData getAll];
        NSInteger index = [sortData indexOfObjectPassingTest:^BOOL(SortData*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return obj.ident == defaultSort;
        }];
        if (index != NSNotFound)
            _sortData = [sortData objectAtIndex:index];
    }
    
    if (!_sortData)
        _sortData = [SortData getAll].firstObject;
    
    SearchCollectionViewLayout* layout = (SearchCollectionViewLayout*)_searchCollectionView.collectionViewLayout;
    layout.numberOfColumns = 2;
    layout.cellPadding = 10;
    layout.delegate = self;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = OliveMainColor;
    [_refreshControl addTarget:self action:@selector(reloadData:) forControlEvents:UIControlEventValueChanged];
    [_searchCollectionView addSubview:_refreshControl];
    
    _loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _loadingIndicator.color = OliveMainColor;
    _loadingIndicator.hidesWhenStopped = YES;
    [_loadingIndicator stopAnimating];
    [_searchCollectionView addSubview:_loadingIndicator];
    
    [self reloadData:nil];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.numberOfLines = 2;
    [self refreshTitleLabelForCount:-1];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _titleLabel.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
    self.navigationItem.titleView = _titleLabel;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [_searchCollectionView.collectionViewLayout invalidateLayout];
}

-(void)refreshTitleLabelForCount:(int)count{
    
    NSMutableAttributedString* titleString = [[NSMutableAttributedString alloc] init];
    
    NSMutableAttributedString* searchString = [[NSMutableAttributedString alloc] initWithString:_searchText.length > 0 ? [NSString stringWithFormat:@"\"%@\"",_searchText] : @"ALL"];
    [searchString addAttribute:NSFontAttributeName
                         value:BrandonGrotesqueBold16
                         range:NSMakeRange(0, searchString.length)];
    [searchString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, searchString.length)];
    [titleString appendAttributedString:searchString];
    
    NSMutableAttributedString* countResultString = [[NSMutableAttributedString alloc] initWithString:count >= 0 ? [NSString stringWithFormat:@"\n%i results", count] : @"\nLoading results"];
    [countResultString addAttribute:NSFontAttributeName
                              value:BrandonGrotesqueBold13
                              range:NSMakeRange(0, countResultString.length)];
    [countResultString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:1. alpha:0.7] range:NSMakeRange(0, countResultString.length)];
    [titleString appendAttributedString:countResultString];
    
    _titleLabel.attributedText = titleString;
}

-(void)loadData{
    [[AdvertServiceManager sharedManager] loadAdverts:_sortData search:_searchText category:_searchCategory page:_page compleate:^(NSArray *result, NSDictionary *additionalData, NSError *error) {
        if (error){
            [self showOkAlert:@"Error" text:ERROR_MESSAGE(error)];
        }
        else
        {
            [self refreshTitleLabelForCount:[[additionalData objectForKeyNotNull:@"count"] intValue]];
            if ([additionalData objectForKeyNotNull:@"next"]){
                _page ++;
            }else{
                _page = 0;
            };
            [_adverts addObjectsFromArray:result];
            [_searchCollectionView reloadData];
        }
        [_loadingIndicator stopAnimating];
        if (_refreshControl.isRefreshing)
            [_refreshControl endRefreshing];
        _searchCollectionView.contentInset = UIEdgeInsetsZero;
    }];
}

-(void)reloadData:(id)owner{
    [_sortButton setTitle:_sortData.title forState:UIControlStateNormal];
    if (_searchCategory){
        _categoryButton.titleLabel.minimumScaleFactor = 5;
        _categoryButton.titleLabel.numberOfLines = 2;
        
        NSMutableAttributedString* titleString = [[NSMutableAttributedString alloc] init];
        
        if ([_searchCategory isKindOfClass:[TSAdvertSubCategory class]]){
            TSAdvertCategory* category = [[AdvertServiceManager sharedManager] getCategoyWithId:((TSAdvertSubCategory*)_searchCategory).parentIdent];
            NSMutableAttributedString* categoryString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", category.title]];
            [categoryString addAttribute:NSFontAttributeName
                                 value:Helvetica14
                                 range:NSMakeRange(0, categoryString.length)];
            [categoryString addAttribute:NSForegroundColorAttributeName value:OliveMainColor range:NSMakeRange(0, categoryString.length)];
            [titleString appendAttributedString:categoryString];
        }
        
        NSMutableAttributedString* lastString = [[NSMutableAttributedString alloc] initWithString:_searchCategory.title];
        [lastString addAttribute:NSFontAttributeName
                                  value:Helvetica14
                                  range:NSMakeRange(0, lastString.length)];
        [lastString addAttribute:NSForegroundColorAttributeName value:OliveMainColor range:NSMakeRange(0, lastString.length)];
        [titleString appendAttributedString:lastString];
        
        _categoryButton.titleLabel.adjustsFontSizeToFitWidth = true;
        _categoryButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_categoryButton setAttributedTitle:titleString forState:UIControlStateNormal];
        _categoryButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    }else{
        [_categoryButton setAttributedTitle:nil forState:UIControlStateNormal];
        [_categoryButton setTitle:@"Category" forState:UIControlStateNormal];
        _categoryButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    _page = 1;
     [self refreshTitleLabelForCount:-1];
    [_adverts removeAllObjects];
    [_refreshControl beginRefreshing];
    [_searchCollectionView reloadData];
    [self loadData];
}

-(void)setSearchText:(NSString*)searchText{
    _searchText = searchText;
    if (self.isViewLoaded)
        [self reloadData:nil];
}

-(void)setCategory:(TSBaseDictionaryEntity*)category{
    _searchCategory = category;
    if (self.isViewLoaded)
        [self reloadData:nil];
}

- (IBAction)selectCategory:(id)sender {
    [self performSegueWithIdentifier:CATEGORIES_SEGUE sender:nil];
}

- (IBAction)selectSort:(id)sender {
    _sortView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
    _sortView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_sortView];
    
    UIView* background = [[UIView alloc] initWithFrame:CGRectMake(0, _sortView.bounds.size.height - 200, _sortView.bounds.size.width, 200)];
    background.backgroundColor = [UIColor colorWithRed:235./255. green:235./255. blue:235./255. alpha:1.];
    [_sortView addSubview:background];
    
    UIPickerView* picker = [[UIPickerView alloc] initWithFrame:CGRectMake(20, _sortView.bounds.size.height - 200, _sortView.bounds.size.width - 40, 200)];
    picker.backgroundColor = [UIColor clearColor];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    [_sortView addSubview:picker];
    
    UITapGestureRecognizer *tapToSelect = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedToSelectRow:)];
    tapToSelect.delegate = self;
    [picker addGestureRecognizer:tapToSelect];

    [UIView animateWithDuration:0.3 animations:^{
        _sortView.frame = self.view.bounds;
    }];
    
}

-(void)updateWatchList:(TSAdvert*)advert{
//    [self showLoading];
//    [[ServerConnectionHelper sharedInstance] addToWatchList:advert compleate:^(NSError *error){
//        [self hideLoading];
//        NSString* title = @"";
//        NSString* message = advert.inWatchList ? @"Advert added to watch list" : @"Advert removed to watch list";
//        if (error){
//            title = @"Error";
//            message = ERROR_MESSAGE(error);
//        }
//        [self showOkAlert:title text:message];
//    }];
}

#pragma mark - CategoryProtocol
-(void)categorySelected:(TSBaseDictionaryEntity*)category{
    _searchCategory = category;
    [self reloadData:nil];
}

-(void)addRemoveWatchList:(SearchCollectionViewCell*)owner{
//    if ([self checkUserLogin]){
//        NSIndexPath* indexPath = [_searchCollectionView indexPathForCell:owner];
//        Advert* advert = [_adverts objectAtIndex:indexPath.row];
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
//                                        [owner.watchListButton setHighlighted:!advert.inWatchList];
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

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _adverts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchCollectionViewCell* cell = (SearchCollectionViewCell*)[collectionView
                                                                 dequeueReusableCellWithReuseIdentifier:@"SearchCollectionViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    if (_page > 0 && indexPath.row > _adverts.count -2){
        _loadingIndicator.center = CGPointMake(_searchCollectionView.center.x, _searchCollectionView.contentSize.height + 22);
        _searchCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
        [_loadingIndicator startAnimating];
        [self loadData];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(SearchCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    TSAdvert* adv = [_adverts objectAtIndex:indexPath.row];
    TSImageEntity* image = [adv.photos firstObject];
    
    [cell.imageView loadImage:image];
    
    cell.titleLabel.text = adv.name;
    cell.locationLabel.text = adv.location;
    
    cell.dateLabel.text = adv.dateExpires ? [NSDate stringFromDate:adv.dateExpires] : @"N/A";
    
    cell.priceLabel.text = [NSString stringWithFormat:@"%.02f", adv.guidePrice];
//    [cell.watchListButton setHighlighted:adv.is];
}

-(int)heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    TSAdvert* adv = [_adverts objectAtIndex:indexPath.row];
    float height = 172;
    TSImageEntity* image = [adv.photos firstObject];
    if (image){
        height += image.height * (_searchCollectionView.frame.size.width - 30) / 2 / image.width;
    }else{
        height += 176;
    }
    return height;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:ADVERT_DETAIL_SEGUE sender:[_adverts objectAtIndex:indexPath.row]];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return true;
}

- (void)tappedToSelectRow:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        UIPickerView* picker = (UIPickerView*)tapRecognizer.view;
        CGFloat rowHeight = [picker rowSizeForComponent:0].height;
        CGRect selectedRowFrame = CGRectInset(picker.bounds, 0.0, (CGRectGetHeight(picker.frame) - rowHeight) / 2.0 );
        BOOL userTappedOnSelectedRow = (CGRectContainsPoint(selectedRowFrame, [tapRecognizer locationInView:picker]));
        if (userTappedOnSelectedRow) {
            NSInteger selectedRow = [picker selectedRowInComponent:0];
            SortData* newSortData = [[SortData getAll] objectAtIndex:selectedRow];
            if (newSortData.ident != _sortData.ident){
                _sortData = newSortData;
                [AppSettings setSearchSort:_sortData.ident];
                [self reloadData:nil];
                CGRect r = _sortView.frame;
                r.origin.y = r.size.height;
                [UIView animateWithDuration:0.3 animations:^{
                    _sortView.frame = r;
                }];
            }
        }
    }
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [SortData getAll].count;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = ((SortData*)[[SortData getAll] objectAtIndex:row]).title;
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:GrayColor}];
    
    return attString;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40.;
}

@end
