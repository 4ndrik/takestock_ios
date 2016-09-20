//
//  TSImageEntity.h
//  takestok
//
//  Created by Artem on 9/13/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSBaseEntity.h"
#import "ImageProtocol.h"

@interface TSImageEntity : TSBaseEntity<ImageProtocol>

@property (nonatomic, assign, readonly) int height;
@property (nonatomic, assign, readonly) int width;
@property (nonatomic, assign, readonly) BOOL isMain;

-(instancetype)initWithUrl:(NSString *)url;
+(NSNumber*)identFromDic:(NSDictionary*)dict;

@end
