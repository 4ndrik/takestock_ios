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
#import "OfferStatus.h"
#import "OfferActionView.h"
#import "PaddingTextField.h"
#import "ShippingInfoActionView.h"
#import "OfferServiceManager.h"
#import "TSUserEntity.h"
#import "TSAdvert.h"

@implementation OfferManagerViewController
@synthesize advert = _advert;

-(void)viewDidLoad{
    [super viewDidLoad];
    _offers = [NSMutableArray array];
    _offersTableView.estimatedRowHeight = 124.0;
    _offersTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _offersTableView.rowHeight = UITableViewAutomaticDimension;
    
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
    [self reloadData:nil];
}

#pragma mark - Helpers

-(void)reloadData:(id)owner{
    _page = 1;
    [_offers removeAllObjects];
    [_offersTableView reloadData];
    [_refreshControl beginRefreshing];
    [self loadData];
}

-(void)loadData{
    [[OfferServiceManager sharedManager] loadOffersForAdvert:_advert page:_page compleate:^(NSArray *result, NSDictionary *additionalData, NSError *error) {
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
            [_offers addObjectsFromArray:result];
            [_offersTableView reloadData];
        }
        [_loadingIndicator stopAnimating];
        if (_refreshControl.isRefreshing)
            [_refreshControl endRefreshing];
        _offersTableView.contentInset = UIEdgeInsetsZero;
    }];
}


-(NSMutableAttributedString*)spaceForFont{
    NSMutableAttributedString* spaceString = [[NSMutableAttributedString alloc] initWithString:@"\n \n"];
    [spaceString addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:6]
                        range:NSMakeRange(0, spaceString.length)];
    return spaceString;
}

-(NSMutableAttributedString*)fillOfferInformation:(TSOffer*)offer advert:(TSAdvert*)advert cell:(OfferTableViewCell*)cell{
    
    NSMutableAttributedString* textString = [[NSMutableAttributedString alloc] init];
    if ([offer.status.ident intValue] == tsAccept){
        
        if (textString.length > 0)
            [textString appendAttributedString:[self spaceForFont]];
        
        NSMutableAttributedString* acceptString = [[NSMutableAttributedString alloc] initWithString:@"WAITING FOR PAYMENT"];
        [acceptString addAttribute:NSFontAttributeName
                             value:BrandonGrotesqueBold14
                             range:NSMakeRange(0, acceptString.length)];
        [acceptString addAttribute:NSForegroundColorAttributeName value:OliveMainColor range:NSMakeRange(0, acceptString.length)];
        [textString appendAttributedString:acceptString];
    }else if ([offer.status.ident intValue] == tsDecline){
        
        if (textString.length > 0)
            [textString appendAttributedString:[self spaceForFont]];
        
        NSMutableAttributedString* declineString = [[NSMutableAttributedString alloc] initWithString:@"REJECTED"];
        [declineString addAttribute:NSFontAttributeName
                              value:BrandonGrotesqueBold14
                              range:NSMakeRange(0, declineString.length)];
        [declineString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, declineString.length)];
        [textString appendAttributedString:declineString];
        
        if (offer.comment.length > 0){
            [textString appendAttributedString:[self spaceForFont]];
            
            NSMutableAttributedString* commentString = [[NSMutableAttributedString alloc] initWithString:offer.comment];
            [commentString addAttribute:NSFontAttributeName
                                  value:HelveticaNeue14
                                  range:NSMakeRange(0, commentString.length)];
            [commentString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, commentString.length)];
            [textString appendAttributedString:commentString];
        }
        
    }else if ([offer.status.ident intValue] == tsPending){
        if (!offer.parentOfferId){
            cell.replyPanelHeight.constant = 30.;
        }else{
            NSMutableAttributedString* pendingString = [[NSMutableAttributedString alloc] initWithString:@"WAITING RESPONSE"];
            [pendingString addAttribute:NSFontAttributeName
                                  value:BrandonGrotesqueBold14
                                  range:NSMakeRange(0, pendingString.length)];
            [pendingString addAttribute:NSForegroundColorAttributeName value:OliveMainColor range:NSMakeRange(0, pendingString.length)];
            [textString appendAttributedString:pendingString];
        }
    }
//    else if (offer.status.ident == stCountered ){
//        
//        cell.myRequestLabel.text = @"Your offer:";
//        cell.myQuantityLabel.text = [NSString stringWithFormat:@"%i%@", offer.counterOffer.quantity, advert.packaging ? advert.packaging.title: @""];
//        cell.myPricelabel.text = [NSString stringWithFormat:@"£%.02f", offer.counterOffer.price];
//        
//        if (offer.comment.length > 0){
//            if (textString.length > 0)
//                [textString appendAttributedString:[self spaceForFont]];
//            
//            NSMutableAttributedString* commentString = [[NSMutableAttributedString alloc] initWithString:offer.comment];
//            [commentString addAttribute:NSFontAttributeName
//                                  value:HelveticaNeue14
//                                  range:NSMakeRange(0, commentString.length)];
//            [commentString addAttribute:NSForegroundColorAttributeName value:OberginMainColor range:NSMakeRange(0, commentString.length)];
//            [textString appendAttributedString:commentString];
//        }
//        
//        NSMutableAttributedString* additionalTextString = [self fillOfferInformation:offer.counterOffer advert:advert cell:cell];
//        if (additionalTextString.length > 0){
//            if (textString.length > 0)
//                [textString appendAttributedString:[self spaceForFont]];
//            [textString appendAttributedString:additionalTextString];
//        }
//    }else if (offer.status.ident == stPayment){
//        cell.operationPanelHeight.constant = 30.;
//        
//        NSMutableAttributedString* deliveryString = [[NSMutableAttributedString alloc] initWithString:@"DELIVERY ADDRESS:\n"];
//        [deliveryString addAttribute:NSFontAttributeName
//                              value:BrandonGrotesqueBold13
//                              range:NSMakeRange(0, deliveryString.length)];
//        [deliveryString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, deliveryString.length)];
//        [textString appendAttributedString:deliveryString];
//        
//        NSMutableAttributedString* deliveryAddressString = [[NSMutableAttributedString alloc] initWithString:@"Delivery address\nSome address"];
//        [deliveryAddressString addAttribute:NSFontAttributeName
//                               value:HelveticaNeue14
//                               range:NSMakeRange(0, deliveryAddressString.length)];
//        [deliveryAddressString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, deliveryString.length)];
//        [textString appendAttributedString:deliveryAddressString];
//        [textString appendAttributedString:[self spaceForFont]];
//        
//        [cell.mainButton setTitle:@"SET SHIPPING DETAILS" forState:UIControlStateNormal];
//    }
    
    return textString;
}

//-(void)updateOffer:(Offer*)offer compleate:(void(^)(NSError* error))compleate{
//    [self showLoading];
//    [[ServerConnectionHelper sharedInstance] updateOffer:offer compleate:^(NSError *error) {
//        [self hideLoading];
//        compleate(error);
//    }];
//}

-(void)acceptOffer:(TSOffer*)offer{
    [self showLoading];
    [[OfferServiceManager sharedManager] acceptOffer:offer compleate:^(NSError *error) {
        [self hideLoading];
        NSString* title = @"";
        NSString* text = @"Offer is accepted";
        if (error){
            title = @"Error";
            text = ERROR_MESSAGE(error);
        }

        [self showOkAlert:title text:text];
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
            NSString* text = @"Offer is rejected";
            if (error){
                title = @"Error";
                text = ERROR_MESSAGE(error);
            }
            
            [self showOkAlert:title text:text];
            [_offersTableView reloadData];

        }];
    }
}

-(void)counterOffer:(id)owner{
//    float oPrice = [_offerAlertView.priceTextEdit.text floatValue];
//    int oQuantity = [_offerAlertView.qtyTextEdit.text intValue];
//    
//    NSInteger index = [_offers indexOfObjectPassingTest:^BOOL(Offer*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        return obj.ident == _offerAlertView.tag;
//    }];
//    
//    if (index != NSNotFound && oPrice > 0 && oQuantity > 0){
//        Offer* offer = [_offers objectAtIndex:index];
//        offer.status = [OfferStatus getEntityWithId:stCountered];
//        offer.comment = _offerAlertView.commentTextView.text;
//        
//        Offer* counterOffer = [Offer storedEntity];
//        counterOffer.parentOffer = offer;
//        counterOffer.user = [User getMe];
//        counterOffer.price = oPrice;
//        counterOffer.quantity = oQuantity;
//        counterOffer.status = [OfferStatus getEntityWithId:stPending];
//        
//        [_offerAlertView removeFromSuperview];
//        [self showLoading];
//        [[ServerConnectionHelper sharedInstance] createOffer:counterOffer compleate:^(NSError *error) {
//            if (error){
//                [self hideLoading];
//                [counterOffer.managedObjectContext deleteObject:counterOffer];
//                offer.status = [OfferStatus getEntityWithId:stPending];
//                offer.comment = @"";
//                NSString* title = @"Error";
//                NSString* text = ERROR_MESSAGE(error);
//                [self showOkAlert:title text:text];
//                [_offersTableView reloadData];
//            }else{
//                [self updateOffer:offer compleate:^(NSError *error) {
//                    NSString* title = @"";
//                    NSString* text = @"Offer Countered";
//                    if (error){
//                        title = @"Error";
//                        text = ERROR_MESSAGE(error);
//                        offer.status = [OfferStatus getEntityWithId:stPending];
//                    }
//                    [_offersTableView reloadData];
//                    [self showOkAlert:title text:text];
//                }];
//            }
//        }];
//    }
}

-(BOOL)validateShippingInfo{
    NSMutableString* message = [[NSMutableString alloc] init];
//    if (_payView.destinationAddress.text.length == 0)
//        [message appendString:@"Fill destination address.\n"];
//    
//    if (![_payView.cardControl isValid]){
//        [message appendString:@"Card data invalid."];
//        
//    }
    
    if (message.length > 0){
        [self showOkAlert:@"" text:message];
        return NO;
        
    }else{
        return YES;
    }
}

-(void)setShippingInfo:(id)owner{
    if ([self validateShippingInfo]){
        NSLog(@"dasd");
    }
}

-(void)hideAlertView:(id)owner{
    [_offerAlertView removeFromSuperview];
    _offerAlertView = nil;
    
    [_shippingInfoActionView removeFromSuperview];
    _shippingInfoActionView = nil;
}

#pragma mark - UITableViewDelegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _offers.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TSOffer* offer = [_offers objectAtIndex:indexPath.row];
    
    OfferTableViewCell* cell = (OfferTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"OfferTableViewCell"];
    cell.delegate = self;
    
    cell.autorNameLabel.text = offer.user.userName;
    cell.quantityLabel.text = [NSString stringWithFormat:@"%i%@", offer.quantity, _advert.packaging ? _advert.packaging.title: @""];
    cell.priceLabel.text = [NSString stringWithFormat:@"£%.02f", offer.price];
    
    cell.commentLabel.text = @"offer comment";//offer.comment;
    cell.myRequestLabel.text = @"";
    cell.myQuantityLabel.text = @"";
    cell.myPricelabel.text = @"";
    cell.replyPanelHeight.constant = 0.;
    cell.operationPanelHeight.constant = 0.;
    
    NSMutableAttributedString* textString = [self fillOfferInformation:offer advert:_advert cell:cell];
    [cell.commentLabel setAttributedText:textString];
    
    if (_page > 0 && indexPath.row > _offers.count -2){
        _loadingIndicator.center = CGPointMake(_offersTableView.center.x, _offersTableView.contentSize.height + 22);
        _offersTableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
        [_loadingIndicator startAnimating];
        [self loadData];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [OfferTitleView defaultSize];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    OfferTitleView* offerTitleView =  [OfferTitleView loadFromXib];
    [offerTitleView.advertImageView loadImage:[_advert.photos firstObject]];
    offerTitleView.advertTitleLabel.text = _advert.name;
    
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
//    
//    _offerAlertView =  [OfferActionView loadFromXib];
//    _offerAlertView.frame = self.navigationController.view.bounds;
//    
//    _offerAlertView.titleLabel.text = @"Counter offer.";
//    NSUInteger index = [_offersTableView indexPathForCell:owner].row;
//    Offer* offer = [_offers objectAtIndex:index];
//    _offerAlertView.tag = offer.ident;
//    [_offerAlertView.cancelButton addTarget:self action:@selector(hideAlertView:) forControlEvents:UIControlEventTouchUpInside];
//    [_offerAlertView.sendButton addTarget:self action:@selector(counterOffer:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.navigationController.view addSubview:_offerAlertView];
//    
//    _offerAlertView.priceTypeLabel.text = @"£";
//    _offerAlertView.qtytypeLabel.text = offer.advert.packaging ? offer.advert.packaging.title: @"";
//    
//    [_offerAlertView.priceTextEdit becomeFirstResponder];
}

-(void)mainAction:(OfferTableViewCell *)owner{
//    _shippingInfoActionView = [ShippingInfoActionView loadFromXib];
//    _shippingInfoActionView.frame = self.navigationController.view.bounds;
//    
//    [_shippingInfoActionView.cancelButton addTarget:self action:@selector(hideAlertView:) forControlEvents:UIControlEventTouchUpInside];
//    [_shippingInfoActionView.setButton addTarget:self action:@selector(setShippingInfo:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.navigationController.view addSubview:_shippingInfoActionView];
//    
//    [_shippingInfoActionView.dateShippedTextField becomeFirstResponder];
}

@end
