//
//  AskQuestionView.m
//  takestok
//
//  Created by Artem on 5/6/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "AskQuestionView.h"

@implementation AskQuestionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(float)defaultHeight{
    return 160;
}

- (IBAction)askQuestion:(id)sender {
    [self.delegate askQuestion];
}

@end
