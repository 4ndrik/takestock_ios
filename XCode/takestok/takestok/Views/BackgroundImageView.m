//
//  BackgroundImageView.m
//  UnsharedTV
//
//  Created by N-iX Artem Serbin on 12/10/10.
//  Copyright (c) 2013 App Dev LLC. All rights reserved.
//

#import "BackgroundImageView.h"
#import "UIImage+ExtendedImage.h"
#import "ImageLoader.h"

@interface BackgroundImageView()
@property (retain)UIActivityIndicatorView* activityIndicator;
@property (readonly)NSString* currentImageIdent;

@end

@implementation BackgroundImageView
@synthesize placeHolder = _placeHolder;


-(void)initializations
{
    self.clipsToBounds = YES;
    [self setExclusiveTouch:YES];
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityIndicator.color = [UIColor grayColor];
    [_activityIndicator setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    _activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _activityIndicator.hidesWhenStopped = YES;
    [self addSubview:_activityIndicator];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self initializations];
    }
    
    return self;
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initializations];
    }
    return self;
}

-(void)setImage:(UIImage *)image
{
    if (!image)
        return;
    super.image = image;
    [self.activityIndicator stopAnimating];
}

- (void)loadImage:(id<ImageProtocol>)image
{
    __weak BackgroundImageView* weak_ = self;
    _successBlock = ^(UIImage *image, NSString* fileIdent) {
        if ([weak_.currentImageIdent isEqualToString:fileIdent])
        {
            weak_.image = image;
        }
    };
    
    [_activityIndicator startAnimating];
    
    if (_placeHolder)
        self.image = _placeHolder;
    else
        super.image = nil;
    
    if (image)
    {
        _currentImageIdent = image.resId;
        
        [[ImageLoader sharedInstance] loadImage:image success:_successBlock];
    }else
    {
        _currentImageIdent = @"";
        //        self.image = [UIImage imageNamed:@"placeHolder"];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview){
        _successBlock = nil;
    }
}

@end
