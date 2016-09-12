//
//  TSAdvertSubCategory.h
//  takestok
//
//  Created by Artem on 9/9/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSBaseDictionaryEntity.h"

@interface TSAdvertSubCategory : TSBaseDictionaryEntity{
    NSNumber* _parentIdent;
}

@property (readonly)NSNumber* parentIdent;

-(instancetype)initWithParentIdent:(NSNumber*)parentIdent;

@end
