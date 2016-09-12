//
//  TSAdvertCertefication.m
//  takestok
//
//  Created by Artem on 9/9/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSAdvertCertification.h"


#define CERTIFICATE_ID_PARAM                 @"pk"
#define CERTIFICATE_NAME_PARAM               @"name"
#define CERTIFICATE_DESCRIPTION_PARAM        @"description"
//#define CERTIFICATE_LOGO_PARAM               @"logo"

@implementation TSAdvertCertification

@synthesize description = _description;

-(void)updateWithDic:(NSDictionary*)dict{
    _ident = [TSAdvertCertification identFromDic:dict];
    _title = [dict objectForKeyNotNull:CERTIFICATE_NAME_PARAM];
    _description = [dict objectForKeyNotNull:CERTIFICATE_DESCRIPTION_PARAM];
}

+(NSNumber*)identFromDic:(NSDictionary*)dict{
    return [dict objectForKeyNotNull:CERTIFICATE_ID_PARAM];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    _description = [aDecoder decodeObjectForKey:CERTIFICATE_DESCRIPTION_PARAM];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_description forKey:CERTIFICATE_DESCRIPTION_PARAM];
}

@end
