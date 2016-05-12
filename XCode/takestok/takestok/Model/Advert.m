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
#import "SubCategory.h"
#import "NSData+base64.h"
#import "ImageCacheUrlResolver.h"
#import "Packaging.h"


#define ID_PARAM                    @"id"
#define NAME_PARAM                  @"name"
#define CREATED_PARAM               @"created_at"
#define EXPIRES_PARAM               @"expires_at"
#define UPDATED_AT                  @"updated_at"
#define GUIDE_PRICE_PARAM           @"guide_price"
#define DESCRIPTION_PARAM           @"description"
#define LOCATION_PARAM              @"location"
#define MAIN_ORDER_QUANTITY_PARAM   @"min_order_quantity"
#define ITEMS_COUNT_PARAM           @"items_count"
#define CERTIFICARIONS_EXTRA_PARAM  @"certification_extra"
#define SIZE_PARAM                  @"size"
#define TAGS_PARAM                  @"tags"
#define SHIPPING_PARAM              @"shipping"
#define CATEGORY_PARAM              @"category"
#define SUBCATEGORY_PARAM           @"subcategory"
#define CERTIFICATIONS_PARAM        @"certification"
#define CONDITION_PARAM             @"condition"
#define AUTHOR_PARAM                @"author"
#define AUTHOR_DETAILS_PARAM        @"author_detailed"
#define PHOTOS_PARAM                @"photos"
#define PACKAGING_PARAM             @"packaging"

#define PHOTOS_HEIGHT_PARAM         @"height"
#define PHOTOS_WIDTH_PARAM          @"width"
#define PHOTOS_IMAGE_PARAM          @"image"
#define PHOTOS_IS_MAIN_PARAM        @"is_main"


@implementation Advert

+ (NSString *)entityName {
    return @"Advert";
}

-(void)updateWithDic:(NSDictionary*)jsonDic{
    self.ident = [[jsonDic objectForKeyNotNull:ID_PARAM] intValue];
    self.name = [jsonDic objectForKeyNotNull:NAME_PARAM];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = (@"yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'");
    
    self.created = [[dateFormatter dateFromString:[jsonDic objectForKeyNotNull:CREATED_PARAM]] timeIntervalSinceReferenceDate];
    self.expires = [[dateFormatter dateFromString:[jsonDic objectForKeyNotNull:EXPIRES_PARAM]] timeIntervalSinceReferenceDate];
    self.updated = [[dateFormatter dateFromString:[jsonDic objectForKeyNotNull:UPDATED_AT]] timeIntervalSinceReferenceDate];
    self.guidePrice = [[jsonDic objectForKeyNotNull:GUIDE_PRICE_PARAM] floatValue];
    self.adDescription = [jsonDic objectForKeyNotNull:DESCRIPTION_PARAM];
    self.location = [jsonDic objectForKeyNotNull:LOCATION_PARAM];
    self.minOrderQuantity = [[jsonDic objectForKeyNotNull:MAIN_ORDER_QUANTITY_PARAM] intValue];
    self.count = [[jsonDic objectForKeyNotNull:ITEMS_COUNT_PARAM] intValue];
    self.certificationOther = [jsonDic objectForKeyNotNull:CERTIFICARIONS_EXTRA_PARAM];
    self.size = [jsonDic objectForKeyNotNull:SIZE_PARAM];
    self.tags = [[jsonDic objectForKeyNotNull:TAGS_PARAM] componentsJoinedByString:@", "];
    
    Shipping* shipping = [Shipping getEntityWithId:[[jsonDic objectForKeyNotNull:SHIPPING_PARAM] intValue]];
    if (shipping && shipping.managedObjectContext != self.managedObjectContext){
        shipping = [self.managedObjectContext objectWithID:[shipping objectID]];
    }
    self.shipping = shipping;
    
    Category* category = [Category getEntityWithId:[[jsonDic objectForKeyNotNull:CATEGORY_PARAM] intValue]];
    if (category && category.managedObjectContext != self.managedObjectContext){
        category = [self.managedObjectContext objectWithID:[category objectID]];
    }
    self.category = category;
    
    SubCategory* subCategory = [SubCategory getEntityWithId:[[jsonDic objectForKeyNotNull:SUBCATEGORY_PARAM] intValue]];
    if (subCategory && subCategory.managedObjectContext != self.managedObjectContext){
        subCategory = [self.managedObjectContext objectWithID:[subCategory objectID]];
    }
    self.subCategory = subCategory;
    
    Certification* certification = [Certification getEntityWithId:[[jsonDic objectForKeyNotNull:CERTIFICATIONS_PARAM] intValue]];
    if (certification && certification.managedObjectContext != self.managedObjectContext){
        certification = [self.managedObjectContext objectWithID:[certification objectID]];
    }
    self.certification = certification;
    
    Condition* condition = [Condition getEntityWithId:[[jsonDic objectForKeyNotNull:CONDITION_PARAM] intValue]];
    if (condition && condition.managedObjectContext != self.managedObjectContext){
        condition = [self.managedObjectContext objectWithID:[condition objectID]];
    }
    self.condition = condition;
    
    Packaging* packaging = [Packaging getEntityWithId:[[jsonDic objectForKeyNotNull:PACKAGING_PARAM] intValue]];
    if (packaging && packaging.managedObjectContext != self.managedObjectContext){
        packaging = [self.managedObjectContext objectWithID:[packaging objectID]];
    }
    self.packaging = packaging;
    
    User* user = [User getEntityWithId:[[jsonDic objectForKeyNotNull:AUTHOR_PARAM] intValue]];
    if (!user){
        user = [User tempEntity];
    }
    if (user.managedObjectContext != self.managedObjectContext){
        user = [self.managedObjectContext objectWithID:[user objectID]];
    }
    NSDictionary* userDic = [jsonDic objectForKeyNotNull:AUTHOR_DETAILS_PARAM];
    [user updateWithDic:userDic];
    self.author = user;
    
    
    //    "intended_use": 1,
    //    "is_vat_exempt": true
//    packaging
    
    //
    NSMutableOrderedSet* imageSet = [[NSMutableOrderedSet alloc] init];
    
    for (NSDictionary* imageDic in [jsonDic objectForKeyNotNull:PHOTOS_PARAM]) {
        Image* advImage = self.isForStore ? [Image storedEntity] :[Image tempEntity];
        advImage.height = [[imageDic objectForKeyNotNull:PHOTOS_HEIGHT_PARAM] intValue];
        advImage.width = [[imageDic objectForKeyNotNull:PHOTOS_WIDTH_PARAM] intValue];
        
        advImage.url = [imageDic objectForKeyNotNull:PHOTOS_IMAGE_PARAM];
        advImage.resId = [advImage.url lastPathComponent];
        
        if ([[imageDic objectForKey:PHOTOS_IS_MAIN_PARAM] boolValue]){
            [imageSet insertObject:advImage atIndex:0];
        }else{
             [imageSet addObject:advImage];
        }
    }
    
    [self setImages:imageSet];
}

-(NSDictionary*)getDictionary{
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    if (self.ident > 0){
        [result setValue:[NSNumber numberWithInt:self.ident] forKey:ID_PARAM];
    }
    [result setValue:self.name forKey:NAME_PARAM];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = (@"yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'");
    
    [result setValue:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:self.expires]] forKey:EXPIRES_PARAM];
    [result setValue:[NSNumber numberWithFloat:self.guidePrice] forKey:GUIDE_PRICE_PARAM];
    [result setValue:self.adDescription forKey:DESCRIPTION_PARAM];
    [result setValue:self.location forKey:LOCATION_PARAM];
    [result setValue:[NSNumber numberWithInteger:self.minOrderQuantity] forKey:MAIN_ORDER_QUANTITY_PARAM];
    [result setValue:[NSNumber numberWithInteger:self.count] forKey:ITEMS_COUNT_PARAM];
    [result setValue:self.certificationOther forKey:CERTIFICARIONS_EXTRA_PARAM];
    [result setValue:self.size forKey:SIZE_PARAM];
    [result setValue:[self.tags componentsSeparatedByString:@", "] forKey:TAGS_PARAM];
    [result setValue:[NSNumber numberWithInteger:self.shipping.ident] forKey:SHIPPING_PARAM];
    [result setValue:[NSNumber numberWithInteger:self.category.ident] forKey:CATEGORY_PARAM];
    [result setValue:[NSNumber numberWithInteger:self.subCategory.ident] forKey:SUBCATEGORY_PARAM];
    [result setValue:[NSNumber numberWithInteger:self.certification.ident] forKey:CERTIFICATIONS_PARAM];
    [result setValue:[NSNumber numberWithInteger:self.condition.ident] forKey:CONDITION_PARAM];
    [result setValue:[NSNumber numberWithInt:self.packaging.ident] forKey:PACKAGING_PARAM];
    [result setValue:[NSNumber numberWithInteger:self.author.ident] forKey:AUTHOR_PARAM];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    NSMutableArray* photos = [NSMutableArray arrayWithCapacity:self.images.count];
    for (int i = 0; i < self.images.count; i++ ){
        Image* image = [self.images objectAtIndex:i];
        NSString* filePath = [ImageCacheUrlResolver getPathForImage:image];
        
        if ([fileManager fileExistsAtPath:filePath] && [[[fileManager attributesOfItemAtPath:filePath error:nil] objectForKey:@"NSFileSize"]intValue] > 0)
        {
            NSData *imageData = [NSData dataWithContentsOfFile:filePath];
            NSString* imageString = [imageData base64Encoding];
            [photos addObject:[NSString stringWithFormat:@"data:image/png;base64,%@",imageString]];
        }
    }
    [result setValue:photos forKey:@"photos_list"];
    return result;
}

@end
