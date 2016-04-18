//
//  Advert+Parce.h
//  takestok
//
//  Created by Artem on 4/18/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "Advert.h"

@interface Advert (Parce)

-(void)updateWithJSon:(NSDictionary*)jsonDic;

@end
