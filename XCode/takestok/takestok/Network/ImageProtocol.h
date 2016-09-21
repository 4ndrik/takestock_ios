//
//  ImageProtocol.h
//  takestok
//
//  Created by Artem on 4/14/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageProtocol<NSObject>

@property (nonatomic, retain, readwrite) NSString *resId;
@property (nonatomic, retain, readwrite) NSString *url;

@end
