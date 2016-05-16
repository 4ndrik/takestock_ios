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

@interface QAViewController ()

@end

@implementation QAViewController

-(void)setAdvert:(Advert*)advert{
    _advert = advert;

    if (self.isViewLoaded){
        [self reloadData:nil];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (IBAction)hideKeyboard:(id)sender {
    if ([_askQuestionView.questionTextView isFirstResponder]){
        [_askQuestionView.questionTextView resignFirstResponder];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
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

-(void)loadQA{
    _loading = YES;
    [[ServerConnectionHelper sharedInstance] loadQuestionAnswersWithAdvId:_advert.ident page:0 compleate:^(NSArray *qaArray, NSDictionary *additionalData, NSError *error) {
        [_qaData addObjectsFromArray:qaArray];
        [_askTableView reloadData];
        [_refreshControl endRefreshing];
        _loading = NO;
    }];
}

-(void)reloadData:(id)owner{
    _page = 1;
    _qaData = [NSMutableArray array];
    _page = 1;
    [_askTableView reloadData];
    [_refreshControl beginRefreshing];
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
    
    Question* question = [_qaData objectAtIndex:indexPath.row];
    
    NSString* questionText = [NSString stringWithFormat:@"%@: %@", question.user.userName, question.message];
    int index = question.user.userName.length +1;
    
    NSMutableAttributedString *buyerText = [[NSMutableAttributedString alloc] initWithString:questionText];
    [buyerText addAttribute:NSFontAttributeName
                  value:ArialBold14
                  range:NSMakeRange(0, index)];
    
    [buyerText addAttribute:NSFontAttributeName
                  value:ArialItalic14
                  range:NSMakeRange(index, buyerText.length - index)];
    
    cell.questionLabel.attributedText = buyerText;
    
    if (question.answer){
        NSString* answerText = [NSString stringWithFormat:@"%@: %@", question.answer.user.userName, question.answer.message];
        int index = question.answer.user.userName.length +1;
        NSMutableAttributedString *sellerText = [[NSMutableAttributedString alloc] initWithString:answerText];
        [sellerText addAttribute:NSFontAttributeName
                          value:ArialBold14
                          range:NSMakeRange(0, index)];
        
        [sellerText addAttribute:NSFontAttributeName
                          value:ArialItalic14
                          range:NSMakeRange(index, sellerText.length - index)];
        
        cell.answerLabel.attributedText = sellerText;
    }else{
        cell.answerLabel.hidden = YES;
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
    }else if ([AppSettings getUserId] == 0){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *controller = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentViewController:controller animated:YES completion:nil];
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
                message = [error localizedDescription];
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

@end
