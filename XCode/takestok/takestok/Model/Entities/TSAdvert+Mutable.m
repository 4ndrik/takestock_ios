//
//  TSAdvert+Mutable.m
//  takestok
//
//  Created by Artem on 9/20/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "TSAdvert+Mutable.h"

@implementation TSAdvert (Mutable)

-(void)setName:(NSString *)name{
    _name = name;
}

-(void)setDateExpires:(NSDate *)dateExpires{
    _dateExpires = dateExpires;
}

-(void)setGuidePrice:(float)guidePrice{
    _guidePrice = guidePrice;
}

-(void)setAdDescription:(NSString *)adDescription{
    _adDescription = adDescription;
}

-(void)setLocation:(NSString *)location{
    _location = location;
}

-(void)setShipping:(TSAdvertShipping *)shipping{
    _shipping = shipping;
}

-(void)setIsVatExtempt:(BOOL)isVatExtempt{
    _isVatExtempt = isVatExtempt;
}

-(void)setPhotos:(NSArray<TSImageEntity *> *)photos{
    _photos = photos;
}

-(void)setAuthor:(TSUserEntity *)author{
    _author = author;
}

-(void)setCategory:(TSAdvertCategory *)category{
    _category = category;
}

-(void)setSubCategory:(TSAdvertSubCategory *)subCategory{
    _subCategory = subCategory;
}

-(void)setPackaging:(TSAdvertPackagingType *)packaging{
    _packaging = packaging;
}

-(void)setMinOrderQuantity:(int)minOrderQuantity{
    _minOrderQuantity = minOrderQuantity;
}

-(void)setSize:(NSString *)size{
    _size = size;
}

-(void)setCertificationOther:(NSString *)certificationOther{
    _certificationOther = certificationOther;
}

-(void)setCertification:(TSAdvertCertification *)certification{
    _certification = certification;
}

-(void)setCondition:(TSAdvertCondition *)condition{
    _condition = condition;
}

-(void)setCount:(int)count{
    _count = count;
}

-(void)setTags:(NSString *)tags{
    _tags = tags;
}

-(void)setIsInDrafts:(BOOL)isInDrafts{
    _isInDrafts = isInDrafts;
}

-(void)setState:(TSAdvertState *)state{
    _state = state;
}

-(void)setIsInWatchList:(BOOL)isInWatchList{
    _isInWatchList = isInWatchList;
}

//@property (readwrite, nonatomic, retain) NSArray* photos;


@end
