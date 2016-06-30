//
//  QAViewController.m
//  takestok
//
//  Created by Artem on 5/6/16.
//  Copyright © 2016 Artem. All rights reserved.
//

#import "QAViewController.h"
#import "Advert.h"
#import "QATableViewCell.h"
#import "AskQuestionView.h"
#import "UIView+NibLoadView.h"
#import "AppSettings.h"
#import "ServerConnectionHelper.h"
#import "Question.h"
#import "Answer.h"
#import "AppSettings.h"
#import "LoginViewController.h"
#import "Answer.h"

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


#pragma mark - Helpers

-(void)setAdvert:(Advert*)advert{
    _advert = advert;
    if (self.isViewLoaded){
        [self reloadData:nil];
    }
}

- (IBAction)hideKeyboard:(id)sender {
    if ([_askQuestionView.questionTextView isFirstResponder]){
        [_askQuestionView.questionTextView resignFirstResponder];
    }
}


-(void)loadQA{
    [[ServerConnectionHelper sharedInstance] loadQuestionAnswersWithAd:_advert page:_page compleate:^(NSArray *qaArray, NSDictionary *additionalData, NSError *error) {
        
        if (error){
            UIAlertController* errorController = [UIAlertController alertControllerWithTitle:@"Error" message:ERROR_MESSAGE(error) preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* closeAction = [UIAlertAction
                                          actionWithTitle:@"Ok"
                                          style:UIAlertActionStyleCancel
                                          handler:^(UIAlertAction * action)
                                          {
                                              [errorController dismissViewControllerAnimated:YES completion:nil];
                                              
                                          }];
            
            
            [errorController addAction:closeAction];
            
            [self presentViewController:errorController animated:YES completion:nil];
        }
        else
        {
            if ([additionalData objectForKeyNotNull:@"next"]){
                _page ++;
            }else{
                _page = 0;
            };
            [_qaData addObjectsFromArray:qaArray];
            [_askTableView reloadData];
        }
        [_loadingIndicator stopAnimating];
        if (_refreshControl.isRefreshing)
            [_refreshControl endRefreshing];
        _askTableView.contentInset = UIEdgeInsetsZero;
    }];
}

-(void)reloadData:(id)owner{
    if (_advert.author.ident == [User getMe].ident){
        _qaData = [NSMutableArray arrayWithArray:[_advert.questions allObjects]];
        _page = 0;
        [_refreshControl endRefreshing];
    }else{
        _qaData = [NSMutableArray array];
        _page = 1;
        [_refreshControl beginRefreshing];
        [self loadQA];
    }
    [_askTableView reloadData];
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
    
    Question* question = [_qaData objectAtIndex:indexPath.row];
    
    NSString* questionText = [NSString stringWithFormat:@"%@: %@", question.user.userName, question.message];
    NSInteger index = question.user.userName.length + 1;
    
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
        NSString* answerText = [NSString stringWithFormat:@"%@: %@", question.answer.user.userName, question.answer.message];
        NSInteger index = question.answer.user.userName.length + 1;
        NSMutableAttributedString *sellerText = [[NSMutableAttributedString alloc] initWithString:answerText];
        [sellerText addAttribute:NSFontAttributeName
                          value:ArialBold14
                          range:NSMakeRange(0, index)];
        
        [sellerText addAttribute:NSFontAttributeName
                          value:ArialItalic14
                          range:NSMakeRange(index, sellerText.length - index)];
        
        cell.answerLabel.attributedText = sellerText;
    }else if (_advert.author.ident == [User getMe].ident){
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
    return _advert.author.ident == [User getMe].ident ? 0 : [AskQuestionView defaultHeight];
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (_advert.author.ident == [User getMe].ident)
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
            UIAlertController* errorController = [UIAlertController alertControllerWithTitle:@"" message:@"Message is empty" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* closeAction = [UIAlertAction
                                          actionWithTitle:@"Ok"
                                          style:UIAlertActionStyleCancel
                                          handler:^(UIAlertAction * action)
                                          {
                                              [errorController dismissViewControllerAnimated:YES completion:nil];
                                              
                                          }];
            
            
            [errorController addAction:closeAction];
            
            [self presentViewController:errorController animated:YES completion:nil];
        }else{
            Question* question = [_advert isForStore] ? [Question storedEntity] : [Question tempEntity];
            
            question.advert = _advert;
            User* user = [User getMe];
            if (user.managedObjectContext != question.managedObjectContext){
                user = [question.managedObjectContext objectWithID:[user objectID]];
            }
            question.user = user;
            question.message = _askQuestionView.questionTextView.text;
            [self showLoading];
            [[ServerConnectionHelper sharedInstance] askQuestion:question compleate:^(NSError *error) {
               [self hideLoading];
                
                NSString* title = @"";
                NSString* message = @"Question asked";
                if (error){
                    title = @"Error";
                    message = ERROR_MESSAGE(error);
                    [question.managedObjectContext deleteObject:question];
                }else{
                    [self reloadData:nil];
                    _askQuestionView.questionTextView.text = @"";
                }
                UIAlertController* errorController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* closeAction = [UIAlertAction
                                              actionWithTitle:@"Ok"
                                              style:UIAlertActionStyleCancel
                                              handler:^(UIAlertAction * action)
                                              {
                                                  [errorController dismissViewControllerAnimated:YES completion:nil];
                                                  
                                              }];
                
                
                [errorController addAction:closeAction];
                
                [self presentViewController:errorController animated:YES completion:nil];
                
            }];
        }
    }
}

#pragma mark - ReplyPrototcol

-(void)reply:(QATableViewCell*)sender{
    Question* question = [_qaData objectAtIndex:[_askTableView indexPathForCell:sender].row];
    if (question){
        Answer* answer = question.isForStore ? [Answer storedEntity] : [Answer tempEntity];
        answer.question = question;
        User* user = [User getMe];
        if (user.managedObjectContext != answer.managedObjectContext){
            user = [answer.managedObjectContext objectWithID:[user objectID]];
        }
        answer.user = user;
        answer.message = sender.replyTextEdit.text;
        
        [self showLoading];
        [[ServerConnectionHelper sharedInstance] sendAnswer:answer compleate:^(NSError *error) {
            [self hideLoading];
            NSString* title = @"";
            NSString* message = @"Question asked";
            if (error){
                title = @"Error";
                message = ERROR_MESSAGE(error);
                [answer.managedObjectContext deleteObject:answer];
            }else{
                [self reloadData:nil];
                [_askTableView reloadData];
            }
            UIAlertController* errorController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* closeAction = [UIAlertAction
                                          actionWithTitle:@"Ok"
                                          style:UIAlertActionStyleCancel
                                          handler:^(UIAlertAction * action)
                                          {
                                              [errorController dismissViewControllerAnimated:YES completion:nil];
                                              
                                          }];
            
            
            [errorController addAction:closeAction];
            
            [self presentViewController:errorController animated:YES completion:nil];
        }];
    }
}

@end
