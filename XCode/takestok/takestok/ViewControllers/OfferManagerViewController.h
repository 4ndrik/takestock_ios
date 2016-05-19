//
//  OfferManagerViewController.h
//  takestok
//
//  Created by Artem on 4/25/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BaseViewController.h"
#import "Advert.h"
#import "OfferTableViewCell.h"

@interface OfferManagerViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, OfferActionDelegate>{
     __weak IBOutlet UITableView *_offersTableView;
    NSArray* _offers;
}

@property (nonatomic, retain)Advert* advert;

@end
