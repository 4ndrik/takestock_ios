//
//  Categoriy.m
//  takestok
//
//  Created by Artem on 4/21/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "Category.h"
#import "Advert.h"
#import "NSDictionary+HandleNil.h"
#import "SubCategory.h"

@implementation Category

+ (NSString *)entityName {
    return @"Category";
}

+(Dictionary*)syncClass:(Class)class withDb:(NSArray*)dbCategories withJson:(NSDictionary*)jsonCategory{
    int ident = [[jsonCategory objectForKeyNotNull:CATEGORY_ID_PARAM] intValue];
    NSUInteger index = [dbCategories indexOfObjectPassingTest:^BOOL(Dictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return obj.ident = ident;
    }];
    
    Category* dbCategory;
    if (index != NSNotFound){
        dbCategory = [dbCategories objectAtIndex:index];
    }else{
        dbCategory = [class storedEntity];
    }
    
    dbCategory.ident = ident;
    dbCategory.title = [jsonCategory objectForKeyNotNull:CATEGORY_NAME_PARAM];
    
    return dbCategory;

}

+(void)syncWithJsonArray:(NSArray*)array{
    NSArray* dbCategories = [self getAll];
    NSArray* dbSubCategories = [SubCategory getAll];
    //    NSMutableArray* allIdents = [NSMutableArray array];
    for (NSDictionary* jsonCategory in array){
        Category* dbCategory = (Category*)[self syncClass:[Category class] withDb:dbCategories withJson:jsonCategory];
        for (NSDictionary* subCategory in [jsonCategory objectForKeyNotNull:CATEGORY_SUBCATEGORIES_PARAM]){
            SubCategory* dbSubCategory = (SubCategory*)[self syncClass:[SubCategory class] withDb:dbSubCategories withJson:subCategory];
            dbSubCategory.category = dbCategory;
        }
    }
    
    [[DB sharedInstance].storedManagedObjectContext save:nil];
    
    //TODO Remove old items
}

@end
