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

@class TSAdvert;
@class UIRefreshControl;

@interface QAViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, AskQuestionProtocol, ReplyProtocol>{
    UIActivityIndicatorView* _loadingIndicator;
    TSAdvert* _advert;
    AskQuestionView* _askQuestionView;
    __weak IBOutlet UITableView *_askTableView;
    NSMutableArray* _qaData;
    int _page;
    float _keyboardFrame;
    UIRefreshControl* _refreshControl;
    BOOL _loading;
}

-(void)setAdvert:(TSAdvert*)advert;
- (IBAction)hideKeyboard:(id)sender;

@end
