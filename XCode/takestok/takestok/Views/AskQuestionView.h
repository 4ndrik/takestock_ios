//
//  AskQuestionView.h
//  takestok
//
//  Created by Artem on 5/6/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AskQuestionProtocol <NSObject>

-(void)askQuestion;

@end

@interface AskQuestionView : UIView

@property (weak, nonatomic) IBOutlet UITextView *questionTextView;
@property (weak) id<AskQuestionProtocol>delegate;

- (IBAction)askQuestion:(id)sender;

+(float)defaultHeight;

@end
