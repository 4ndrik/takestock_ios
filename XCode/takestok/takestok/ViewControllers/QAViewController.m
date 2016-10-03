//
//  QAViewController.m
//  takestok
//
//  Created by Artem on 5/6/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "QAViewController.h"
#import "TSAdvert.h"
#import "TSQuestion.h"
#import "TSAnswer.h"
#import "QATableViewCell.h"
#import "AskQuestionView.h"
#import "UIView+NibLoadView.h"
#import "AppSettings.h"
#import "ServerConnectionHelper.h"
#import "AppSettings.h"
#import "LoginViewController.h"
#import "QuestionAnswerServiceManager.h"
#import "UserServiceManager.h"
#import "TSQuestion+Mutable.h"
#import "TSAnswer+Mutable.h"

@interface QAViewController ()

@end

@implementation QAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _loadingIndicator.color = OliveMainColor;
    _loadingIndicator.hidesWhenStopped = YES;
    [_loadingIndicator stopAnimating];
    [_askTableView addSubview:_loadingIndicator];
    
    _askTableView.estimatedRowHeight = 118.0;
    _askTableView.rowHeight = UITableViewAutomaticDimension;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = OliveMainColor;
    [_refreshControl addTarget:self action:@selector(reloadData:) forControlEvents:UIControlEventValueChanged];
    [_askTableView addSubview:_refreshControl];
    
    [self reloadData:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_qaData removeAllObjects];
    [_askTableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reloadData:nil];
}

#pragma mark - Helpers

- (IBAction)hideKeyboard:(id)sender {
    if ([_askQuestionView.questionTextView isFirstResponder]){
        [_askQuestionView.questionTextView resignFirstResponder];
    }
}

-(void)loadQA{
    [[QuestionAnswerServiceManager sharedManager] loadQuestionsAnswers:_advert page:_page compleate:^(NSArray *result, NSDictionary *additionalData, NSError *error) {
        if (error){
            [self showOkAlert:@"Error" text:ERROR_MESSAGE(error)];
        }
        else
        {
            if ([additionalData objectForKeyNotNull:@"next"]){
                _page ++;
            }else{
                _page = 0;
            };
            [_qaData addObjectsFromArray:result];
            [_askTableView reloadData];
        }
        [_loadingIndicator stopAnimating];
        if (_refreshControl.isRefreshing)
            [_refreshControl endRefreshing];
        _askTableView.contentInset = UIEdgeInsetsZero;
    }];
}

-(void)reloadData:(id)owner{
    _qaData = [NSMutableArray array];
    _page = 1;
    [_askTableView reloadData];
    [_refreshControl beginRefreshing];
    if (_askTableView.contentOffset.y == 0) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
            _askTableView.contentOffset = CGPointMake(0, -_refreshControl.frame.size.height);
        } completion:nil];
    }
    [self loadQA];
}

#pragma mark - Handle keyboard

- (void)keyboardWillHide:(NSNotification *)n
{
    _askTableView.contentInset = UIEdgeInsetsZero;
}

- (void)keyboardWillShow:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    _keyboardFrame = keyboardSize.height;
    _askTableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
    
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _qaData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QATableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"QATableViewCell"];
    
    cell.delegate = self;
    
    TSQuestion* question = [_qaData objectAtIndex:indexPath.row];
    
    NSString* questionText = [NSString stringWithFormat:@"%@: %@", question.userName, question.message];
    NSInteger index = question.userName.length + 1;
    
    NSMutableAttributedString *buyerText = [[NSMutableAttributedString alloc] initWithString:questionText];
    [buyerText addAttribute:NSFontAttributeName
                  value:ArialBold14
                  range:NSMakeRange(0, index)];
    
    [buyerText addAttribute:NSFontAttributeName
                  value:ArialItalic14
                  range:NSMakeRange(index, buyerText.length - index)];
    
    cell.questionLabel.attributedText = buyerText;
    
    if (question.answer){
        cell.replyHeightConstraint.constant = 0;
        NSString* answerText = [NSString stringWithFormat:@"%@: %@", question.answer.userName, question.answer.message];
        NSInteger index = question.answer.userName.length + 1;
        NSMutableAttributedString *sellerText = [[NSMutableAttributedString alloc] initWithString:answerText];
        [sellerText addAttribute:NSFontAttributeName
                          value:ArialBold14
                          range:NSMakeRange(0, index)];
        
        [sellerText addAttribute:NSFontAttributeName
                          value:ArialItalic14
                          range:NSMakeRange(index, sellerText.length - index)];
        
        cell.answerLabel.attributedText = sellerText;
    }else if (_advert.author.ident == [[UserServiceManager sharedManager] getMe].ident){
        cell.answerLabel.text = @"";
        cell.replyHeightConstraint.constant = 98;
    }else{
        cell.answerLabel.text = @"";
        cell.replyHeightConstraint.constant = 0;
    }
    
    if (_page > 0 && indexPath.row > _qaData.count -2){
        _loadingIndicator.center = CGPointMake(tableView.center.x, tableView.contentSize.height + 22);
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
        [_loadingIndicator startAnimating];
        [self loadQA];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return _advert.author.ident == [[UserServiceManager sharedManager] getMe].ident ? 0 : [AskQuestionView defaultHeight];
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (_advert.author.ident == [[UserServiceManager sharedManager] getMe].ident)
        return nil;
    
    if (!_askQuestionView){
        _askQuestionView = [AskQuestionView loadFromXib];
    }
    _askQuestionView.delegate = self;
    return _askQuestionView;
}

-(void)askQuestion{
    if ([self checkUserLogin]){
        if (_askQuestionView.questionTextView.text.length == 0){
            [self showOkAlert:@"" text:@"Message is empty"];
        }else{
            
            TSQuestion* question = [[TSQuestion alloc] init];
            question.dateCreated = [NSDate date];
            question.message = _askQuestionView.questionTextView.text;
            question.userIdent = [[UserServiceManager sharedManager] getMe].ident;
            question.userName = [[UserServiceManager sharedManager] getMe].userName;
            question.advertId = _advert.ident;

            [self showLoading];
            
            [[QuestionAnswerServiceManager sharedManager] askQuestion:question compleate:^(NSError *error) {
               [self hideLoading];

                NSString* title = @"";
                NSString* message = @"Question is sent successfully.";
                if (error){
                    title = @"Error";
                    message = ERROR_MESSAGE(error);
                }else{
                    [_qaData insertObject:question atIndex:0];
                    [_askTableView reloadData];
                    [_askTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    _askQuestionView.questionTextView.text = @"";
                }
                [self showOkAlert:title text:message];
            }];
        }
    }
}

#pragma mark - ReplyPrototcol

-(void)reply:(QATableViewCell*)sender{
    __block TSQuestion* question = [_qaData objectAtIndex:[_askTableView indexPathForCell:sender].row];
    if (question){
        TSAnswer* answer = [[TSAnswer alloc] init];
        answer.questionId = question.ident;
        answer.userIdent = [[UserServiceManager sharedManager] getMe].ident;
        answer.message = sender.replyTextEdit.text;
        
        [self showLoading];
        
        [[QuestionAnswerServiceManager sharedManager] makeAnswer:answer compleate:^(NSError *error) {
            [self hideLoading];
            NSString* title = @"";
            NSString* message = @"Answer is sent successfully.";
            if (error){
                title = @"Error";
                message = ERROR_MESSAGE(error);
            }else{
                question.answer = answer;
                [self reloadData:nil];
                [_askTableView reloadData];
            }
            [self showOkAlert:title text:message];
        }];
    }
}

@end
