//
//  ActionItem.h
//  takestok
//
//  Created by Artem on 6/13/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionItem : NSObject
@property (nonatomic, strong)UIImage* image;
@property (nonatomic, strong)NSString* title;
@property (nonatomic, unsafe_unretained)SEL action;
@end
