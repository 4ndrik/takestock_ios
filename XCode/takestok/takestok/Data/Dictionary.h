//
//  Dictionary.h
//  takestok
//
//  Created by Artem on 4/21/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface Dictionary : BaseEntity

@property (nonatomic) int32_t ident;
@property (nullable, nonatomic, retain) NSString *title;

+(void)syncWithJsonArray:(NSArray*)array;

@end

NS_ASSUME_NONNULL_END
