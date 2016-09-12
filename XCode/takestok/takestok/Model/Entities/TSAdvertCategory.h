//
//  TSAdvertCategory.h
//  takestok
//
//  Created by Artem on 9/9/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSBaseDictionaryEntity.h"

@interface TSAdvertCategory : TSBaseDictionaryEntity{
    BOOL _isFood;
    NSMutableArray* _subCategories;
}

@property (readonly, nonatomic)BOOL isFood;
@property (readonly, nonatomic)NSArray* subCategories;

@end
