//
//  Advert+Parce.m
//  takestok
//
//  Created by Artem on 4/18/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "Advert+Parce.h"
#import "NSDictionary+HandleNil.h"

@implementation Advert (Parce)

-(void)updateWithJSon:(NSDictionary*)jsonDic{
    self.ident = [[jsonDic objectForKeyNotNull:@"id"] intValue];
    self.name = [jsonDic objectForKeyNotNull:@"name"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = (@"yyyy-MM-dd'T'hh:mm:ss'Z'");
    self.created = [[dateFormatter dateFromString:[jsonDic objectForKeyNotNull:@"created_at"]] timeIntervalSince1970];
    self.expires = [[dateFormatter dateFromString:[jsonDic objectForKeyNotNull:@"expires_at"]] timeIntervalSince1970];
    self.updated = [[dateFormatter dateFromString:[jsonDic objectForKeyNotNull:@"updated_at"]] timeIntervalSince1970];
    self.guidePrice = [[jsonDic objectForKeyNotNull:@"guide_price"] floatValue];
    self.adDescription = [jsonDic objectForKeyNotNull:@"description"];
    self.location = [jsonDic objectForKeyNotNull:@"location"];
//    "author": 3,
//    "intended_use": 1,
//    "shipping": 1,
//    "is_vat_exempt": true
    
}

@end
