//
//  Advert.m
//  takestok
//
//  Created by Artem on 4/14/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "Advert.h"
#import "NSDictionary+HandleNil.h"

@implementation Advert

+ (NSString *)entityName {
    return @"Advert";
}

-(void)updateWithJSon:(NSDictionary*)jsonDic{
    self.ident = [[jsonDic objectForKeyNotNull:@"id"] intValue];
    self.name = [jsonDic objectForKeyNotNull:@"name"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = (@"yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'");
    
    self.created = [[dateFormatter dateFromString:[jsonDic objectForKeyNotNull:@"created_at"]] timeIntervalSinceReferenceDate];
    self.expires = [[dateFormatter dateFromString:[jsonDic objectForKeyNotNull:@"expires_at"]] timeIntervalSinceReferenceDate];
    self.updated = [[dateFormatter dateFromString:[jsonDic objectForKeyNotNull:@"updated_at"]] timeIntervalSinceReferenceDate];
    self.guidePrice = [[jsonDic objectForKeyNotNull:@"guide_price"] floatValue];
    self.adDescription = [jsonDic objectForKeyNotNull:@"description"];
    self.location = [jsonDic objectForKeyNotNull:@"location"];
    //    "author": 3,
    //    "intended_use": 1,
    //    "shipping": 1,
    //    "is_vat_exempt": true
    
    //
    NSMutableOrderedSet* imageSet = [[NSMutableOrderedSet alloc] init];
    Image* advImage = [Image tempEntity];
    advImage.height = 1136;
    advImage.width = 640;
    
    advImage.resId = @"838f7d1b-8ca1-4425-9ec7-3bce6c4fd3d3";
    [imageSet addObject:advImage];
    
    [self setImages:imageSet];
    
}

@end
