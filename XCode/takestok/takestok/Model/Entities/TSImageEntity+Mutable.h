//
//  TSImageEntity+Mutable.h
//  takestok
//
//  Created by Artem on 9/20/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSImageEntity.h"

@interface TSImageEntity (Mutable)

@property (nonatomic, assign, readwrite) int height;
@property (nonatomic, assign, readwrite) int width;
@property (nonatomic, assign, readwrite) BOOL isMain;

@end
