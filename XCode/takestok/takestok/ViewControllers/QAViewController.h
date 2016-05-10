//
//  QAViewController.h
//  takestok
//
//  Created by Artem on 5/6/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BaseViewController.h"

@class Advert;
@class AskQuestionView;
@interface QAViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>{
    Advert* _advert;
    AskQuestionView* _askQuestionView;
    __weak IBOutlet UITableView *_askTableView;
    NSMutableArray* _qaData;
    
    float _keyboardFrame;
}

-(void)setAdvert:(Advert*)advert;
- (IBAction)hideKeyboard:(id)sender;

@end
