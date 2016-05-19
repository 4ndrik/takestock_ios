//
//  OfferStatus.h
//  takestok
//
//  Created by Artem on 5/13/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dictionary.h"

@class Offer;

typedef enum {
    stAccept = 1,
    stDecline = 2,
    stPending = 3,
    stCountered = 4
} StatusType;

NS_ASSUME_NONNULL_BEGIN

@interface OfferStatus : Dictionary

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "OfferStatus+CoreDataProperties.h"
