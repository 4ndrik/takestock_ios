//
//  Advert.h
//  takestok
//
//  Created by Artem on 4/14/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseEntity.h"
#import "Image.h"

NS_ASSUME_NONNULL_BEGIN

@interface Advert : BaseEntity

-(void)updateWithJSon:(NSDictionary*)jsonDic;

@end

NS_ASSUME_NONNULL_END

#import "Advert+CoreDataProperties.h"
