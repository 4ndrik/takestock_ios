//
//  TSOfferStatus.h
//  takestok
//
//  Created by Artem on 9/22/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSBaseDictionaryEntity.h"

typedef enum {
    tsAccept = 1,
    tsDecline = 2,
    tsPending = 3,
    tsCountered = 4,
    tsPayment = 5,
    tsCounteredByByer = 6,
    tsAddressReceived = 7,
    tsConfirmStock = 8,
    tsStockInTransit = 9,
    tsGoodsReceived = 10,
    tsInDispute = 11
} TSOfferStatusType;

@interface TSOfferStatus : TSBaseDictionaryEntity

@end
