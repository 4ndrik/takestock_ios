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
#import "Offer.h"


@implementation Advert

+ (NSString *)entityName {
    return @"Advert";
}

-(void)updateWithDic:(NSDictionary*)jsonDic{
    self.ident = [[jsonDic objectForKeyNotNull:ADVERT_ID_PARAM] intValue];
    self.name = [jsonDic objectForKeyNotNull:ADVERT_NAME_PARAM];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    self.created = [[NSDate dateFromString:[jsonDic objectForKeyNotNull:ADVERT_CREATED_PARAM] format:DEFAULT_DATE_FORMAT timeZone:timeZone] timeIntervalSinceReferenceDate];
    self.expires = [[NSDate dateFromString:[jsonDic objectForKeyNotNull:ADVERT_EXPIRES_PARAM] format:DEFAULT_DATE_FORMAT timeZone:timeZone] timeIntervalSinceReferenceDate];
    self.date_updated = [[NSDate dateFromString:[jsonDic objectForKeyNotNull:ADVERT_UPDATED_AT] format:DEFAULT_DATE_FORMAT timeZone:timeZone] timeIntervalSinceReferenceDate];
    
    self.guidePrice = [[jsonDic objectForKeyNotNull:ADVERT_GUIDE_PRICE_PARAM] floatValue];
    self.adDescription = [jsonDic objectForKeyNotNull:ADVERT_DESCRIPTION_PARAM];
    self.location = [jsonDic objectForKeyNotNull:ADVERT_LOCATION_PARAM];
    self.minOrderQuantity = [[jsonDic objectForKeyNotNull:ADVERT_MAIN_ORDER_QUANTITY_PARAM] intValue];
    self.count = [[jsonDic objectForKeyNotNull:ADVERT_ITEMS_COUNT_PARAM] intValue];
    self.certificationOther = [jsonDic objectForKeyNotNull:ADVERT_CERTIFICARIONS_EXTRA_PARAM];
    self.size = [jsonDic objectForKeyNotNull:ADVERT_SIZE_PARAM];
    self.tags = [[jsonDic objectForKeyNotNull:ADVERT_TAGS_PARAM] componentsJoinedByString:@", "];
    
    Shipping* shipping = [Shipping getEntityWithId:[[jsonDic objectForKeyNotNull:ADVERT_SHIPPING_PARAM] intValue]];
    if (shipping && shipping.managedObjectContext != self.managedObjectContext){
        shipping = [self.managedObjectContext objectWithID:[shipping objectID]];
    }
    self.shipping = shipping;
    
    Category* category = [Category getEntityWithId:[[jsonDic objectForKeyNotNull:ADVERT_CATEGORY_PARAM] intValue]];
    if (category && category.managedObjectContext != self.managedObjectContext){
        category = [self.managedObjectContext objectWithID:[category objectID]];
    }
    self.category = category;
    
    SubCategory* subCategory = [SubCategory getEntityWithId:[[jsonDic objectForKeyNotNull:ADVERT_SUBCATEGORY_PARAM] intValue]];
    if (subCategory && subCategory.managedObjectContext != self.managedObjectContext){
        subCategory = [self.managedObjectContext objectWithID:[subCategory objectID]];
    }
    self.subCategory = subCategory;
    
    if ([jsonDic objectForKeyNotNull:ADVERT_CERTIFICATIONS_PARAM]){
        Certification* certification = [Certification getEntityWithId:[[jsonDic objectForKeyNotNull:ADVERT_CERTIFICATIONS_PARAM] intValue]];
        if (certification && certification.managedObjectContext != self.managedObjectContext){
            certification = [self.managedObjectContext objectWithID:[certification objectID]];
        }
        self.certification = certification;
    }
    
    Condition* condition = [Condition getEntityWithId:[[jsonDic objectForKeyNotNull:ADVERT_CONDITION_PARAM] intValue]];
    if (condition && condition.managedObjectContext != self.managedObjectContext){
        condition = [self.managedObjectContext objectWithID:[condition objectID]];
    }
    self.condition = condition;
    
    Packaging* packaging = [Packaging getEntityWithId:[[jsonDic objectForKeyNotNull:ADVERT_PACKAGING_PARAM] intValue]];
    if (packaging && packaging.managedObjectContext != self.managedObjectContext){
        packaging = [self.managedObjectContext objectWithID:[packaging objectID]];
    }
    self.packaging = packaging;
    
    User* user = [User getEntityWithId:[[jsonDic objectForKeyNotNull:ADVERT_AUTHOR_PARAM] intValue]];
    if (!user){
        user = self.isForStore ? [User storedEntity] : [User tempEntity];
    }else if (user.managedObjectContext != self.managedObjectContext){
        user = [self.managedObjectContext objectWithID:[user objectID]];
    }

    NSDictionary* userDic = [jsonDic objectForKeyNotNull:ADVERT_AUTHOR_DETAILS_PARAM];
    [user updateWithDic:userDic];
    self.author = user;
    
    
    //    "intended_use": 1,
    //    "is_vat_exempt": true
//    packaging
    
    //
    NSMutableOrderedSet* imageSet = [[NSMutableOrderedSet alloc] init];
    
    for (NSDictionary* imageDic in [jsonDic objectForKeyNotNull:ADVERT_PHOTOS_PARAM]) {
        int imageId = [[imageDic objectForKeyNotNull:IMAGE_ID_PARAM] intValue];
        
        Image* advImage = [Image getEntityWithId:imageId];
        
        if (!advImage){
            advImage = self.isForStore ? [Image storedEntity] :[Image tempEntity];
        }else if (advImage.managedObjectContext != self.managedObjectContext){
            advImage = [self.managedObjectContext objectWithID:[advImage objectID]];
        }
        
        [advImage updateWithDic:imageDic];
        
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
        [result setValue:[NSNumber numberWithInt:self.ident] forKey:ADVERT_ID_PARAM];
    }
    [result setValue:self.name forKey:ADVERT_NAME_PARAM];
    
    NSTimeZone* timeZone = [NSTimeZone systemTimeZone];
    if (self.expires > 0){
        
        [result setValue:[NSDate stringFromTimeInterval:self.expires format:DEFAULT_DATE_FORMAT timeZone:timeZone] forKey:ADVERT_EXPIRES_PARAM];
    }
    else{
        [result setValue:nil forKey:ADVERT_EXPIRES_PARAM];
    }
    [result setValue:[NSNumber numberWithFloat:self.guidePrice] forKey:ADVERT_GUIDE_PRICE_PARAM];
    [result setValue:self.adDescription forKey:ADVERT_DESCRIPTION_PARAM];
    [result setValue:self.location forKey:ADVERT_LOCATION_PARAM];
    [result setValue:[NSNumber numberWithInteger:self.minOrderQuantity] forKey:ADVERT_MAIN_ORDER_QUANTITY_PARAM];
    [result setValue:[NSNumber numberWithInteger:self.count] forKey:ADVERT_ITEMS_COUNT_PARAM];
    [result setValue:self.certificationOther forKey:ADVERT_CERTIFICARIONS_EXTRA_PARAM];
    if (self.sizeType){
        [result setValue:self.size forKey:ADVERT_SIZE_PARAM];
    }else{
        [result setValue:@"" forKey:ADVERT_SIZE_PARAM];
    }
    [result setValue:[self.tags componentsSeparatedByString:@", "] forKey:ADVERT_TAGS_PARAM];
    [result setValue:[NSNumber numberWithInteger:self.shipping.ident] forKey:ADVERT_SHIPPING_PARAM];
    [result setValue:[NSNumber numberWithInteger:self.category.ident] forKey:ADVERT_CATEGORY_PARAM];
    [result setValue:[NSNumber numberWithInteger:self.subCategory.ident] forKey:ADVERT_SUBCATEGORY_PARAM];
    if (self.certification.ident > 0)
        [result setValue:[NSNumber numberWithInteger:self.certification.ident] forKey:ADVERT_CERTIFICATIONS_PARAM];
    [result setValue:[NSNumber numberWithInteger:self.condition.ident] forKey:ADVERT_CONDITION_PARAM];
    [result setValue:[NSNumber numberWithInt:self.packaging.ident] forKey:ADVERT_PACKAGING_PARAM];
    [result setValue:[NSNumber numberWithInteger:self.author.ident] forKey:ADVERT_AUTHOR_PARAM];
    
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

+(NSArray*)getMyAdverts{
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date_updated" ascending:NO];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"author == %@", [User getMe]];
    NSFetchRequest* request = [self getFetchRequestForPredicate:predicate withSortDescriptions:[NSArray arrayWithObjects:sortDescriptor, nil]];
    return [[DB sharedInstance].storedManagedObjectContext executeFetchRequest:request error:nil];
}

+(NSArray*)getWatchList{
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"expires" ascending:YES];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"inWatchList == %i", YES];
    NSFetchRequest* request = [self getFetchRequestForPredicate:predicate withSortDescriptions:[NSArray arrayWithObjects:sortDescriptor, nil]];
    return [[DB sharedInstance].storedManagedObjectContext executeFetchRequest:request error:nil];
}

@end
