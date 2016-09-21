//
//  TSImageEntity+Mutable.m
//  takestok
//
//  Created by Artem on 9/20/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSImageEntity+Mutable.h"

@implementation TSImageEntity (Mutable)

-(void)setHeight:(int)height{
    _height = height;
}

-(void)setWidth:(int)width{
    _width = width;
}

-(void)setIsMain:(BOOL)isMain{
    _isMain = isMain;
}

-(void)setResId:(NSString *)resId{
    _resId = resId;
}

-(void)setUrl:(NSString *)url{
    _url = url;
}

@end
