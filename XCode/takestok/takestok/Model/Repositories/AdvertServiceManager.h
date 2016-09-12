//
//  AdvertServiceManager.h
//  takestok
//
//  Created by Artem on 9/9/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TSAdvertCategory;

@interface AdvertServiceManager : NSObject{
    NSMutableDictionary* _states;
    NSMutableDictionary* _sizeTypes;
    NSMutableDictionary* _certifications;
    NSMutableDictionary* _shipping;
    NSMutableDictionary* _conditions;
    NSMutableDictionary* _categories;
    NSMutableDictionary* _packageTypes;
}

+(instancetype)sharedManager;
-(void)fetchRequiredData;

-(NSArray*)getCategories;
-(TSAdvertCategory*)getCategoyWithId:(NSNumber*)ident;

@end
