//
//  Certification.h
//  takestok
//
//  Created by Artem on 4/21/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dictionary.h"
#import "Image.h"

#define CERT_ID_PARAM               @"pk"
#define CERT_NAME_PARAM             @"name"
#define CERT_DESCRIPTION_PARAM      @"description"
#define CERT_LOGO_PARAM             @"logo"

NS_ASSUME_NONNULL_BEGIN

@interface Certification : Dictionary

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Certification+CoreDataProperties.h"
