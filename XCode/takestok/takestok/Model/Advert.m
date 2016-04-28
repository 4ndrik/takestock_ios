//
//  Advert.m
//  takestok
//
//  Created by Artem on 4/14/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "Advert.h"
#import "Shipping.h"
#import "Category.h"
#import "Certification.h"
#import "Condition.h"
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
    self.minOrderQuantity = [[jsonDic objectForKeyNotNull:@"min_order_quantity"] intValue];
    self.count = [[jsonDic objectForKeyNotNull:@"items_count"] intValue];
    self.certificationOther = [jsonDic objectForKeyNotNull:@"certification_extra"];
    
    Shipping* shipping = [Shipping getEntityWithId:[[jsonDic objectForKeyNotNull:@"shipping"] intValue]];
    if (shipping.managedObjectContext != self.managedObjectContext){
        shipping = [self.managedObjectContext objectWithID:[shipping objectID]];
    }
    self.shipping = shipping;
    
    Category* category = [Category getEntityWithId:[[jsonDic objectForKeyNotNull:@"category"] intValue]];
    if (category.managedObjectContext != self.managedObjectContext){
        category = [self.managedObjectContext objectWithID:[category objectID]];
    }
    self.category = category;
    
    Category* subCategory = [Category getEntityWithId:[[jsonDic objectForKeyNotNull:@"subcategory"] intValue]];
    if (subCategory.managedObjectContext != self.managedObjectContext){
        subCategory = [self.managedObjectContext objectWithID:[subCategory objectID]];
    }
    self.subCategory = subCategory;
    
    Certification* certification = [Certification getEntityWithId:[[jsonDic objectForKeyNotNull:@"certification"] intValue]];
    if (certification.managedObjectContext != self.managedObjectContext){
        certification = [self.managedObjectContext objectWithID:[subCategory objectID]];
    }
    self.certification = certification;
    
    Condition* condition = [Condition getEntityWithId:[[jsonDic objectForKeyNotNull:@"condition"] intValue]];
    if (condition.managedObjectContext != self.managedObjectContext){
        condition = [self.managedObjectContext objectWithID:[subCategory objectID]];
    }
    self.condition = condition;
    
    
    //    "author": 3,
    //    "intended_use": 1,
    //    "is_vat_exempt": true
//    packaging
//    certification_extra
    
    //
    NSMutableOrderedSet* imageSet = [[NSMutableOrderedSet alloc] init];
    
    for (NSDictionary* imageDic in [jsonDic objectForKeyNotNull:@"photos"]) {
        Image* advImage = self.isForStore ? [Image storedEntity] :[Image tempEntity];
        advImage.height = 1136;
        advImage.width = 640;
        
        advImage.url = [imageDic objectForKeyNotNull:@"image"];
        advImage.resId = [advImage.url lastPathComponent];
        
        if ([[imageDic objectForKey:@"is_main"] boolValue]){
            [imageSet insertObject:advImage atIndex:0];
        }else{
             [imageSet addObject:advImage];
        }
    }
    
    [self setImages:imageSet];
}

@end
