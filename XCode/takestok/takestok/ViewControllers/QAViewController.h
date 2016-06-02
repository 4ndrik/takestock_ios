//
//  QAViewController.h
//  takestok
//
//  Created by Artem on 5/6/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "BaseViewController.h"
#import "AskQuestionView.h"
#import "QATableViewCell.h"

@class Advert;
@class UIRefreshControl;

@interface QAViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, AskQuestionProtocol, ReplyProtocol>{
    UIActivityIndicatorView* _loadingIndicator;
    Advert* _advert;
    AskQuestionView* _askQuestionView;
    __weak IBOutlet UITableView *_askTableView;
    NSMutableArray* _qaData;
    int _page;
    float _keyboardFrame;
    UIRefreshControl* _refreshControl;
}

-(void)setAdvert:(Advert*)advert;
- (IBAction)hideKeyboard:(id)sender;

@end
