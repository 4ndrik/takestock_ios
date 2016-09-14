//
//  TSBaseDictionaryEntity.h
//  takestok
//
//  Created by Artem on 9/9/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSBaseEntity.h"

@interface TSBaseDictionaryEntity : TSBaseEntity<NSCoding>{
    NSString* _title;
}
@property (nonatomic, readonly) NSString *title;

@end
