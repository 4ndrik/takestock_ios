//
//  OfferManagerViewController.m
//  takestok
//
//  Created by Artem on 4/25/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "OfferManagerViewController.h"
#import "OfferTableViewCell.h"
#import "OfferTitleView.h"
#import "UIView+NibLoadView.h"
#import "BackgroundImageView.h"
#import "TopBottomStripesLabel.h"
#import "TSOffer.h"
#import "TSOfferStatus.h"
#import "ServerConnectionHelper.h"
#import "OfferActionView.h"
#import "PaddingTextField.h"
#import "ShippingInfoActionView.h"
#import "OfferServiceManager.h"
#import "TSUserEntity.h"
#import "TSAdvert.h"
#import "PaddingLabel.h"
#import "UserServiceManager.h"
#import "TSShippingInfo.h"
#import "AdvertServiceManager.h"

@implementation OfferManagerViewController
@synthesize advert = _advert;
@synthesize advertId = _advertId;
@synthesize offerId = _offerId;

-(void)viewDidLoad{
    [super viewDidLoad];
    _offers = [NSMutableArray array];
    
    [_offersTableView registerNib:[UINib nibWithNibName:@"OfferTableViewCell" bundle:nil] forCellReuseIdentifier:@"OfferTableViewCell"];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = OliveMainColor;
    [_refreshControl addTarget:self action:@selector(reloadData:) forControlEvents:UIControlEventValueChanged];
    [_offersTableView addSubview:_refreshControl];
    
    _loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _loadingIndicator.color = OliveMainColor;
    _loadingIndicator.hidesWhenStopped = YES;
    [_loadingIndicator stopAnimating];
    [_offersTableView addSubview:_loadingIndicator];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_offersTableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_offers.count == 0)
        [self reloadData:nil];
}

#pragma mark - Helpers

-(void)reloadData:(id)owner{
    _page = 1;
    [_offers removeAllObjects];
    [_offersTableView reloadData];
    [_refreshControl beginRefreshing];
    if (_offersTableView.contentOffset.y == 0) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
            _offersTableView.contentOffset = CGPointMake(0, -_refreshControl.frame.size.height);
        } completion:nil];
    }
    
    [self loadData];
}

-(void)loadData{
    
    _loading = YES;
    
    if (!_advert){
        
        if (_advertId){
            [[AdvertServiceManager sharedManager] loadAdvertWithId:_advertId compleate:^(TSAdvert *advert, NSError *error) {
                _advert = advert;
                [[AdvertServiceManager sharedManager] sendReadNotificationsWithAdvert:_advert];
                [_offersTableView reloadData];
            }];
        }else if (_offerId){
            [[OfferServiceManager sharedManager] loadOffer:_offerId compleate:^(TSOffer *offer, NSError *error) {
                if (!error){
                    _advertId = offer.advertId;
                    [self loadData];
                }else{
                    [self showOkAlert:@"Error" text:ERROR_MESSAGE(error) compleate:nil];
                }
            }];
        }
    }
    if (_advert || _advertId){
        [[OfferServiceManager sharedManager] loadOffersForAdvertId:_advert ? _advert.ident : _advertId page:_page compleate:^(NSArray *result, NSDictionary *additionalData, NSError *error) {
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
                NSMutableArray* array = [NSMutableArray array];
                for (TSOffer* offer in result){
                    [array addObject:offer];
                    TSOffer* o = offer;
                    while (o.childOffers.count > 0) {
                        o = [offer.childOffers lastObject];
                        [array addObject:o];
                    }
                }
                [_offers addObjectsFromArray:[array sortedArrayUsingComparator:^NSComparisonResult(TSOffer*  _Nonnull obj1, TSOffer*  _Nonnull obj2) {
                    NSComparisonResult result = [obj2.dateUpdated compare:obj1.dateUpdated];
                    if (result == NSOrderedSame)
                        return [obj2.dateCreated compare:obj1.dateCreated];
                    return result;
                }]];
                [_offersTableView reloadData];
            }
            _loading = NO;
            [_loadingIndicator stopAnimating];
            if (_refreshControl.isRefreshing)
                [_refreshControl endRefreshing];
            _offersTableView.contentInset = UIEdgeInsetsZero;
        }];
    }
}

-(NSMutableAttributedString*)spaceForFont{
    NSMutableAttributedString* spaceString = [[NSMutableAttributedString alloc] initWithString:@"\n \n"];
    [spaceString addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:6]
                        range:NSMakeRange(0, spaceString.length)];
    return spaceString;
}

-(void)configureCell:(OfferTableViewCell*)cell withOffer:(TSOffer*)offer advert:(TSAdvert*)advert{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = kCFDateFormatterMediumStyle;
    cell.dateCreatedLabel.text = [NSString stringWithFormat:@"Updated: %@", [dateFormatter stringFromDate:offer.dateUpdated]];
    
    cell.offerTitleLabel.text = offer.user.userName;
    cell.offerCountLabel.text = [NSString stringWithFormat:@"%i%@", offer.quantity, _advert.packaging ? _advert.packaging.title: @""];
    cell.offerPriceLabel.text = [NSString stringWithFormat:@"£%.02f", offer.price];
    
    cell.statusLabel.text = @"";
    cell.mainActionHeight.constant = 0;
    cell.offerActionHeight.constant = 0;
    cell.transportActionHeight.constant = 0;
    cell.contactUsActionHeight.constant = 0;
    cell.contactUserActionHeight.constant = 0;
    cell.payActionHeight.constant = 0;
    cell.bottomTextHeight.constant = 0;
    [cell.contactUserButton setTitle:@"CONTACT BUYER" forState:UIControlStateNormal];
    
    cell.stateLabel.text = [offer.status.title uppercaseString];
    cell.stateLabel.textColor = [UIColor redColor];
    
    NSMutableAttributedString* textString = [[NSMutableAttributedString alloc] init];
    
    if (offer.comment.length > 0){
        
        NSMutableAttributedString* commentString = [[NSMutableAttributedString alloc] initWithString:offer.comment];
        [commentString addAttribute:NSFontAttributeName
                              value:HelveticaNeue14
                              range:NSMakeRange(0, commentString.length)];
        [commentString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, commentString.length)];
        [textString appendAttributedString:commentString];
    }
    
    if (offer.shippingInfo.phone){
        if (textString.length > 0)
            [textString appendAttributedString:[self spaceForFont]];
        NSMutableAttributedString* shippingString = [[NSMutableAttributedString alloc] initWithString:@"Shippping info:"];
        [shippingString addAttribute:NSFontAttributeName
                               value:HelveticaNeue16
                               range:NSMakeRange(0, shippingString.length)];
        [shippingString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, shippingString.length)];
        
        [textString appendAttributedString:shippingString];
        
        NSMutableString* shippingInfoString = [[NSMutableString alloc] init];
        
        if (offer.shippingInfo.house.length > 0){
            [shippingInfoString appendFormat:@"\nHouse: %@", offer.shippingInfo.house];
        }
        if (offer.shippingInfo.street.length > 0){
            [shippingInfoString appendFormat:@"\nStreet: %@", offer.shippingInfo.street];
        }
        if (offer.shippingInfo.city.length > 0){
            [shippingInfoString appendFormat:@"\nCity: %@", offer.shippingInfo.city];
        }
        if (offer.shippingInfo.postcode.length > 0){
            [shippingInfoString appendFormat:@"\nPostcode: %@", offer.shippingInfo.postcode];
        }
        if (offer.shippingInfo.phone.length > 0){
            [shippingInfoString appendFormat:@"\nPhone: %@", offer.shippingInfo.phone];
        }

        NSMutableAttributedString* shippingInfo = [[NSMutableAttributedString alloc] initWithString:shippingInfoString];
        [shippingInfo addAttribute:NSFontAttributeName
                             value:HelveticaNeue14
                             range:NSMakeRange(0, shippingInfo.length)];
        [shippingInfo addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, shippingInfo.length)];
        
        [textString appendAttributedString:shippingInfo];
    }
    
    if ([offer.status.ident intValue] == tsPending){
        cell.stateLabel.textColor = OliveMainColor;
        
        if (!offer.isFromSeller){
            cell.offerActionHeight.constant = 40.;
        }
    }else if ([offer.status.ident intValue] == tsAddressReceived ){
        cell.transportActionHeight.constant = 40;
        cell.contactUserActionHeight.constant = 40;
    }else if ([offer.status.ident intValue] == tsConfirmStock){
        cell.mainActionHeight.constant = 40;
        cell.contactUserActionHeight.constant = 40;
        [cell.mainActionButton setTitle:@"CONFIRM STOCK DISPATCHED" forState:UIControlStateNormal];
    }else if ([offer.status.ident intValue] == tsStockInTransit){
        cell.contactUserActionHeight.constant = 40;
        cell.contactUsActionHeight.constant = 40;
    }else if ([offer.status.ident intValue] == tsGoodsReceived){
        cell.contactUserActionHeight.constant = 40;
    }else if ([offer.status.ident intValue] == tsInDispute){
        cell.contactUserActionHeight.constant = 40;
        cell.contactUsActionHeight.constant = 40;
        if (textString.length > 0)
            [textString appendAttributedString:[self spaceForFont]];
        
        NSMutableAttributedString* commentString = [[NSMutableAttributedString alloc] initWithString:@"The buyer has raised a dispute on this purchase. The takestock team are looking into this ad we will contact you as soon as possible)"];
        [commentString addAttribute:NSFontAttributeName
                              value:HelveticaNeue14
                              range:NSMakeRange(0, commentString.length)];
        [commentString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, commentString.length)];
        [textString appendAttributedString:commentString];
    }else if ([offer.status.ident intValue] == tsPayByBacs){
        cell.contactUserActionHeight.constant = 40;
    }
    
    cell.statusLabel.attributedText = textString;
}

#pragma mark - OfferActionDelegate

-(void)acceptOffer:(TSOffer*)offer{
    [self showLoading];
    [[OfferServiceManager sharedManager] acceptOffer:offer compleate:^(NSError *error) {
        [self hideLoading];
        NSString* title = @"";
        NSString* text = @"Offer accepted";
        if (error){
            title = @"Error";
            text = ERROR_MESSAGE(error);
        }

        [self showOkAlert:title text:text compleate:nil];
        [_offersTableView reloadData];

    }];
}

-(void)rejectOffer:(id)owner{
    NSInteger index = [_offers indexOfObjectPassingTest:^BOOL(TSOffer*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj.ident intValue] == _offerAlertView.tag;
    }];
    if (index != NSNotFound){
        TSOffer* offer = [_offers objectAtIndex:index];
        NSString* comment = _offerAlertView.commentTextView.text;
        [_offerAlertView removeFromSuperview];
        [self showLoading];
        [[OfferServiceManager sharedManager] rejectOffer:offer withComment:comment compleate:^(NSError *error) {
            [self hideLoading];
            NSString* title = @"";
            NSString* text = @"Offer rejected";
            if (error){
                title = @"Error";
                text = ERROR_MESSAGE(error);
            }
            
            [self showOkAlert:title text:text compleate:nil];
            [_offersTableView reloadData];
        }];
    }
}

-(void)counterOffer:(id)owner{
    float oPrice = [_offerAlertView.priceTextEdit.text floatValue];
    int oQuantity = [_offerAlertView.qtyTextEdit.text intValue];
    
    NSInteger index = [_offers indexOfObjectPassingTest:^BOOL(TSOffer*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj.ident intValue] == _offerAlertView.tag;
    }];
    
    if (index != NSNotFound && oPrice > 0 && oQuantity > 0){
        TSOffer* offer = [_offers objectAtIndex:index];
        
        [_offerAlertView removeFromSuperview];
        [self showLoading];
        
        
        [[OfferServiceManager sharedManager] createCounterOffer:offer withCount:oQuantity price:oPrice withComment:_offerAlertView.commentTextView.text byByer:NO compleate:^(NSError *error) {
            [self hideLoading];
            NSString* title = @"";
            NSString* text = @"Thanks. Counter offer sent. fingers crossed!";
            if (error){
                title = @"Error";
                text = ERROR_MESSAGE(error);
            }else{
                [_offers insertObject:offer.childOffers.lastObject atIndex:0];
            }
            
            [self showOkAlert:title text:text compleate:nil];
            [_offersTableView reloadData];
        }];
    }
}

-(void)hideAlertView:(id)owner{
    [_offerAlertView removeFromSuperview];
    _offerAlertView = nil;
    
    [_shippingInfoActionView removeFromSuperview];
    _shippingInfoActionView = nil;
}

-(void)contactUsAction:(UITableViewCell *)owner{
    NSString *subject = [NSString stringWithFormat:@""];
    NSString *mail = [NSString stringWithFormat:CONTACT_US_EMAIL];
    NSCharacterSet *set = [NSCharacterSet URLHostAllowedCharacterSet];
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"mailto:?to=%@&subject=%@",
                                                [mail stringByAddingPercentEncodingWithAllowedCharacters:set],
                                                [subject stringByAddingPercentEncodingWithAllowedCharacters:set]]];
    if ([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(void)contactUserAction:(UITableViewCell *)owner{
    NSUInteger index = [_offersTableView indexPathForCell:owner].row;
    if (index != NSNotFound){
        TSOffer* offer = [_offers objectAtIndex:index];
        if([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
            mailCont.mailComposeDelegate = self;
            
            [mailCont setSubject:@"Takestock Trade Message"];
            [mailCont setToRecipients:[NSArray arrayWithObject:offer.user.email]];
            [mailCont setCcRecipients:[NSArray arrayWithObject:CONTACT_US_EMAIL]];
            [mailCont setMessageBody:[NSString stringWithFormat:@"AdvertName: %@ (%@/selling/%@/)", _advert.name, TAKESTOK_IMAGE_URL, _advert.ident] isHTML:NO];
            
            [self presentViewController:mailCont animated:YES completion:nil];
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegates

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _offers.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TSOffer* offer = [_offers objectAtIndex:indexPath.row];
    
    OfferTableViewCell* cell = (OfferTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"OfferTableViewCell"];
    cell.delegate = self;
    
    [self configureCell:cell withOffer:offer advert:_advert];
    
    if (!_loading &&  _page > 0 && indexPath.row > _offers.count - 2){
        _loadingIndicator.center = CGPointMake(_offersTableView.center.x, _offersTableView.contentSize.height + 22);
        _offersTableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
        [_loadingIndicator startAnimating];
        [self loadData];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return _advert ? [OfferTitleView defaultSize] : 0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    OfferTitleView* offerTitleView =  [OfferTitleView loadFromXib];
    [offerTitleView.advertImageView loadImage:[_advert.photos firstObject]];
    offerTitleView.advertTitleLabel.text = _advert.name;
    offerTitleView.soldOutImage.hidden = ![_advert.state.ident isEqualToNumber:SOLD_OUT_IDENT];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = kCFDateFormatterMediumStyle;
    offerTitleView.advertDataCreated.text = [NSString stringWithFormat:@"Updated: %@", [dateFormatter stringFromDate:_advert.dateUpdated]];
    
    offerTitleView.advertPriceLabel.text = [NSString stringWithFormat:@"£%.02f", _advert.guidePrice];
    offerTitleView.advertAvailableLabel.text = [NSString stringWithFormat:@"%i%@", _advert.count, _advert.packaging ? _advert.packaging.title: @""];
    
    return offerTitleView;
}

#pragma mark - OfferActionDelegate

-(void)acceptOfferAction:(OfferTableViewCell*)owner{
    
    UIAlertController * alertController =   [UIAlertController
                                        alertControllerWithTitle:@""
                                        message:@"Accept offer?"
                                        preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:NO completion:nil];
        NSInteger index = [_offersTableView indexPathForCell:owner].row;
        TSOffer* offer = [_offers objectAtIndex:index];
        [self acceptOffer:offer];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)rejectOfferAction:(OfferTableViewCell*)owner{
    _offerAlertView =  [OfferActionView loadFromXib];
    _offerAlertView.frame = self.navigationController.view.bounds;
    
    _offerAlertView.titleLabel.text = @"Reject offer.";
    _offerAlertView.priceQtyHeightConstraints.constant = 0;
    NSInteger index = [_offersTableView indexPathForCell:owner].row;
    TSOffer* offer = [_offers objectAtIndex:index];
    _offerAlertView.tag = [offer.ident intValue];
    [_offerAlertView.cancelButton addTarget:self action:@selector(hideAlertView:) forControlEvents:UIControlEventTouchUpInside];
    [_offerAlertView.sendButton addTarget:self action:@selector(rejectOffer:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationController.view addSubview:_offerAlertView];
    
    [_offerAlertView.commentTextView becomeFirstResponder];
}

-(void)counterOfferAction:(OfferTableViewCell*)owner{
    _offerAlertView =  [OfferActionView loadFromXib];
    _offerAlertView.frame = self.navigationController.view.bounds;
    
    _offerAlertView.titleLabel.text = @"Counter offer.";
    NSUInteger index = [_offersTableView indexPathForCell:owner].row;
    TSOffer* offer = [_offers objectAtIndex:index];
    _offerAlertView.tag = [offer.ident intValue];
    [_offerAlertView.cancelButton addTarget:self action:@selector(hideAlertView:) forControlEvents:UIControlEventTouchUpInside];
    [_offerAlertView.sendButton addTarget:self action:@selector(counterOffer:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationController.view addSubview:_offerAlertView];
    
    _offerAlertView.priceTypeLabel.text = @"£";
    _offerAlertView.qtytypeLabel.text = _advert.packaging ? _advert.packaging.title: @"";
    
    [_offerAlertView.priceTextEdit becomeFirstResponder];
}

-(void)sellerArrangedTransport:(UITableViewCell *)owner{
    NSUInteger index = [_offersTableView indexPathForCell:owner].row;
    TSOffer* offer = [_offers objectAtIndex:index];
    [self showLoading];
    
    [[OfferServiceManager sharedManager] setTransportInfo:YES withOffer:offer compleate:^(NSError *error) {
        [self hideLoading];
        NSString* title = @"";
        NSString* text = @"Transport information sent.";
        if (error){
            title = @"Error";
            text = ERROR_MESSAGE(error);
        }
        
        [self showOkAlert:title text:text compleate:nil];
        [_offersTableView reloadData];
    }];
}

-(void)buyerArrangedTransport:(UITableViewCell *)owner{
    NSUInteger index = [_offersTableView indexPathForCell:owner].row;
    TSOffer* offer = [_offers objectAtIndex:index];
    [self showLoading];
    
    [[OfferServiceManager sharedManager] setTransportInfo:NO withOffer:offer compleate:^(NSError *error) {
        [self hideLoading];
        NSString* title = @"";
        NSString* text = @"Transport information sent.";
        if (error){
            title = @"Error";
            text = ERROR_MESSAGE(error);
        }
        
        [self showOkAlert:title text:text compleate:nil];
        [_offersTableView reloadData];
    }];
}


-(void)mainAction:(OfferTableViewCell *)owner{
    NSUInteger index = [_offersTableView indexPathForCell:owner].row;
    TSOffer* offer = [_offers objectAtIndex:index];
    if ([offer.status.ident intValue] == tsConfirmStock ){
        [self performSegueWithIdentifier:OFFERS_DISPATCH_INFO_SEQUE sender:offer];
    }
}

@end
