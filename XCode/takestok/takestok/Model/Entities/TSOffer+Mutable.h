//
//  TSOffer+Mutable.h
//  takestok
//
//  Created by Artem on 9/23/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSOffer.h"

@interface TSOffer (Mutable)

@property (nonatomic, retain, readwrite) NSNumber* advertId;
@property (nonatomic, assign, readwrite) float price;
@property (nonatomic, assign, readwrite) int quantity;
@property (nonatomic, retain, readwrite) TSUserEntity *user;
//@property (nonatomic, assign, readwrite) NSString *url;

@end
