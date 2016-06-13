//
//  BuyingViewController.m
//  takestok
//
//  Created by Artem on 4/20/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BuyingViewController.h"
#import "Advert.h"
#import "Offer.h"
#import "OfferStatus.h"
#import "BackgroundImageView.h"
#import "BuyingTableViewCell.h"
#import "OfferManagerViewController.h"
#import "ServerConnectionHelper.h"
#import "OfferActionView.h"
#import "UIView+NibLoadView.h"
#import "AdvertDetailViewController.h"
#import <Stripe/Stripe.h>

@implementation BuyingViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:OFFERS_UPDATED_NOTIFICATION object:nil];
    
    _buyingTableView.estimatedRowHeight = 116.0;
    _buyingTableView.rowHeight = UITableViewAutomaticDimension;
    
    self.title = @"BUYING";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshData:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OFFERS_UPDATED_NOTIFICATION object:nil];
}

-(void)refreshData:(id)owner{
    _offers = [Offer getMyOffers];
    [_buyingTableView reloadData];
}

#pragma mark - Helpers

-(NSMutableAttributedString*)spaceForFont{
    NSMutableAttributedString* spaceString = [[NSMutableAttributedString alloc] initWithString:@"\n \n"];
    [spaceString addAttribute:NSFontAttributeName
                         value:[UIFont systemFontOfSize:6]
                         range:NSMakeRange(0, spaceString.length)];
    return spaceString;
}

-(NSMutableAttributedString*)fillOfferInformation:(Offer*)offer advert:(Advert*)advert cell:(BuyingTableViewCell*)cell{
    
     NSMutableAttributedString* textString = [[NSMutableAttributedString alloc] init];
    if (offer.status.ident == stAccept){
        
        if (textString.length > 0)
            [textString appendAttributedString:[self spaceForFont]];
        
        NSMutableAttributedString* acceptString = [[NSMutableAttributedString alloc] initWithString:@"ACCEPTED"];
        [acceptString addAttribute:NSFontAttributeName
                             value:BrandonGrotesqueBold14
                             range:NSMakeRange(0, acceptString.length)];
        [acceptString addAttribute:NSForegroundColorAttributeName value:OliveMainColor range:NSMakeRange(0, acceptString.length)];
        [textString appendAttributedString:acceptString];
        
        cell.acceptHeight.constant = 30.;
        [cell.acceptButton setTitle:@"ADD SHIPPING" forState:UIControlStateNormal];
    }else if (offer.status.ident == stDecline){
        
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
        
    }else if (offer.status.ident == stPending){
        
        if (offer.parentOffer){
            cell.additionalActionHeight.constant = 30.;
        }else{
            NSMutableAttributedString* pendingString = [[NSMutableAttributedString alloc] initWithString:@"WAITING RESPONCE"];
            [pendingString addAttribute:NSFontAttributeName
                                  value:BrandonGrotesqueBold14
                                  range:NSMakeRange(0, pendingString.length)];
            [pendingString addAttribute:NSForegroundColorAttributeName value:OliveMainColor range:NSMakeRange(0, pendingString.length)];
            [textString appendAttributedString:pendingString];
        }
    }
    else if (offer.status.ident == stCountered ){
        
        cell.counterTextLabel.text = @"Counteroffer:";
        cell.counterCountLabel.text = [NSString stringWithFormat:@"%i%@", offer.counterOffer.quantity, advert.packaging ? advert.packaging.title: @""];
        cell.counterPriceLabel.text = [NSString stringWithFormat:@"£%.02f", offer.counterOffer.price];
        
        
        if (offer.comment.length > 0){
            if (textString.length > 0)
                [textString appendAttributedString:[self spaceForFont]];
            
            NSMutableAttributedString* commentString = [[NSMutableAttributedString alloc] initWithString:offer.comment];
            [commentString addAttribute:NSFontAttributeName
                                  value:HelveticaNeue14
                                  range:NSMakeRange(0, commentString.length)];
            [commentString addAttribute:NSForegroundColorAttributeName value:OberginMainColor range:NSMakeRange(0, commentString.length)];
            [textString appendAttributedString:commentString];
        }
        
        NSMutableAttributedString* additionalTextString = [self fillOfferInformation:offer.counterOffer advert:advert cell:cell];
        if (additionalTextString.length > 0){
            if (textString.length > 0)
                [textString appendAttributedString:[self spaceForFont]];
            [textString appendAttributedString:additionalTextString];
        }
    }
    
    return textString;

}

-(void)updateOffer:(Offer*)offer compleate:(void(^)(NSError* error))compleate{
    [self showLoading];
    [[ServerConnectionHelper sharedInstance] updateOffer:offer compleate:^(NSError *error) {
        [self hideLoading];
        compleate(error);
    }];
}

-(void)showOkAlert:(NSString*)title text:(NSString*)text{
    UIAlertController * alertController =   [UIAlertController
                                             alertControllerWithTitle:title
                                             message:text
                                             preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)acceptOffer:(Offer*)offer{
    offer = offer.counterOffer;
    offer.status = [OfferStatus getEntityWithId:stAccept];
    [self updateOffer:offer compleate:^(NSError *error) {
        NSString* title = @"";
        NSString* text = @"Offer accepted";
        if (error){
            title = @"Error";
            text = ERROR_MESSAGE(error);
            offer.status = [OfferStatus getEntityWithId:stPending];
        }
        
        [self showOkAlert:title text:text];
        [_buyingTableView reloadData];
    }];
}

-(void)rejectOffer:(id)owner{
    NSInteger index = [_offers indexOfObjectPassingTest:^BOOL(Offer*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return obj.ident == _offerAlertView.tag;
    }];
    if (index != NSNotFound){
        Offer* offer = ((Offer*)[_offers objectAtIndex:index]).counterOffer;
        offer.status = [OfferStatus getEntityWithId:stDecline];
        offer.comment = _offerAlertView.commentTextView.text;
        [_offerAlertView removeFromSuperview];
        [self updateOffer:offer compleate:^(NSError *error) {
            NSString* title = @"";
            NSString* text = @"Offer rejected";
            if (error){
                title = @"Error";
                text = ERROR_MESSAGE(error);
                offer.status = [OfferStatus getEntityWithId:stPending];
            }
            
            [self showOkAlert:title text:text];
            [_buyingTableView reloadData];
        }];
    }
}

-(void)hideOfferView:(id)owner{
    [_offerAlertView removeFromSuperview];
    _offerAlertView = nil;
}

-(void)makePaymant{
//    [[STPAPIClient sharedClient]
//     createTokenWithCard:self.paymentTextField.cardParams
//     completion:^(STPToken *token, NSError *error) {
//         if (error) {
//             [self handleError:error];
//         } else {
//             [self createBackendChargeWithToken:token completion:^(PKPaymentAuthorizationStatus status) {
//                 //
//             }];
//         }
//     }];
}

#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _offers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BuyingTableViewCell* cell = (BuyingTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"BuyingTableViewCell"];
    Offer* offer = [_offers objectAtIndex:indexPath.row];
    Advert* advert = offer.advert;
    [cell.adImageView loadImage:advert.images.firstObject];
    cell.titleLabel.text = advert.name;
    cell.priceLabel.text = [NSString stringWithFormat:@"£%.02f", advert.guidePrice];
    cell.quantityLabel.text = [NSString stringWithFormat:@"%i%@", advert.count, advert.packaging ? advert.packaging.title: @""];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = kCFDateFormatterMediumStyle;
    NSDate* updatedDate = [NSDate dateWithTimeIntervalSinceReferenceDate:offer.date_updated];
    cell.createdLabel.text = [NSString stringWithFormat:@"Updated: %@", [dateFormatter stringFromDate:updatedDate]];
    
    cell.offerPriceLabel.text = [NSString stringWithFormat:@"£%.02f", offer.price];
    cell.offerCountLabel.text = [NSString stringWithFormat:@"%i%@", offer.quantity, advert.packaging ? advert.packaging.title: @""];
    
    cell.counterTextLabel.text = @"";
    cell.counterCountLabel.text = @"";
    cell.counterPriceLabel.text = @"";
    
    cell.additionalActionHeight.constant = 0;
    cell.acceptHeight.constant = 0;
    
    NSMutableAttributedString* textString = [self fillOfferInformation:offer advert:advert cell:cell];
    
    [cell.offerTextLabel setAttributedText:textString];
    
    cell.delegate = self;
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"AdvertDetailSegue"]) {
        AdvertDetailViewController* vc = (AdvertDetailViewController*)segue.destinationViewController;
        [vc setAdvert:sender];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Offer* offer = [_offers objectAtIndex:indexPath.row];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *viewAdvertAction = [UIAlertAction actionWithTitle:@"View advert"
                                                                 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                     [tableView deselectRowAtIndexPath:indexPath animated:NO];
                                                                     [self performSegueWithIdentifier:@"AdvertDetailSegue" sender:offer.advert];
                                                                 }];
    UIAlertAction *viewUserAction = [UIAlertAction actionWithTitle:@"View user"
                                                                 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                     [tableView deselectRowAtIndexPath:indexPath animated:NO];
//                                                                     [self performSegueWithIdentifier:@"QuestionSegue" sender:offer.user];
                                                                 }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
                                                               [tableView deselectRowAtIndexPath:indexPath animated:NO];
                                                               NSLog(@"You pressed button two");
                                                           }];
    [alert addAction:viewAdvertAction];
    [alert addAction:viewUserAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - OfferActionDelegate

-(void)mainAction:(UITableViewCell*)owner{
    
}

-(void)acceptOfferAction:(UITableViewCell*)owner{
    UIAlertController * alertController =   [UIAlertController
                                             alertControllerWithTitle:@""
                                             message:@"Accept offer?"
                                             preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:NO completion:nil];
        int index = [_buyingTableView indexPathForCell:owner].row;
        Offer* offer = [_offers objectAtIndex:index];
        [self acceptOffer:offer];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

-(void)rejectOfferAction:(UITableViewCell*)owner{
    _offerAlertView =  [OfferActionView loadFromXib];
    _offerAlertView.frame = self.view.bounds;
    
    _offerAlertView.titleLabel.text = @"Reject offer.";
    _offerAlertView.priceQtyHeightConstraints.constant = 0;
    int index = [_buyingTableView indexPathForCell:owner].row;
    Offer* offer = [_offers objectAtIndex:index];
    _offerAlertView.tag = offer.ident;
    [_offerAlertView.cancelButton addTarget:self action:@selector(hideOfferView:) forControlEvents:UIControlEventTouchUpInside];
    [_offerAlertView.sendButton addTarget:self action:@selector(rejectOffer:) forControlEvents:UIControlEventTouchUpInside];
    
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:_offerAlertView];
    
    [_offerAlertView.commentTextView becomeFirstResponder];
}

@end
